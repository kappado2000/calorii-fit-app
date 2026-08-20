import 'dart:math' as math;

import 'package:depth_capture/depth_capture.dart';

import '../../core/constants/density_table.dart';
import '../../core/constants/micronutrient_reference.dart';
import '../../core/constants/nutrition_reference.dart';
import '../../data/models/bounding_box.dart';
import '../../data/models/food_product.dart';

/// Result of converting a depth map (or reference-object fallback) + a
/// bounding box into a real-world food estimate. `isRoughEstimate` is true
/// whenever no real depth data was available (reference-object fallback) —
/// callers must surface this distinction in the confirmation UI rather than
/// presenting every estimate with the same implied confidence (see project
/// plan, Risk #3: iOS accuracy is itself bimodal, same applies to Android).
///
/// `proteinG`/`carbsG`/`fatG`/`micronutrients` are null whenever no real
/// per-food database match was found for this item — `usedRealNutritionData`
/// distinguishes that case from a genuine zero, so the UI can show whether
/// calories/macros come from an actual matched product or the coarse
/// per-density-category placeholder average.
class FoodEstimate {
  const FoodEstimate({
    required this.volumeCm3,
    required this.grams,
    required this.calories,
    required this.depthSource,
    required this.isRoughEstimate,
    required this.usedRealNutritionData,
    this.proteinG,
    this.carbsG,
    this.fatG,
    this.micronutrients,
  });

  final double volumeCm3;
  final double grams;
  final double calories;
  final DepthSource depthSource;
  final bool isRoughEstimate;
  final bool usedRealNutritionData;
  final double? proteinG;
  final double? carbsG;
  final double? fatG;
  final MicronutrientProfile? micronutrients;

  FoodEstimate scaledByPortionFactor(double factor) {
    return FoodEstimate(
      volumeCm3: volumeCm3 * factor,
      grams: grams * factor,
      calories: calories * factor,
      depthSource: depthSource,
      isRoughEstimate: isRoughEstimate,
      usedRealNutritionData: usedRealNutritionData,
      proteinG: proteinG == null ? null : proteinG! * factor,
      carbsG: carbsG == null ? null : carbsG! * factor,
      fatG: fatG == null ? null : fatG! * factor,
      micronutrients: micronutrients,
    );
  }
}

/// Converts a depth-map-derived (or reference-object-derived) volume into
/// grams and calories, entirely locally — no network call and no dependency
/// on Claude for the numeric estimate. See "Strategia de prompt Claude
/// Haiku 4.5" in the project plan: the model identifies foods, this class
/// does the arithmetic.
class VolumeToCalorieCalculator {
  const VolumeToCalorieCalculator({
    this.assumedMoundHeightCm = 2.5,
    this.assumedFrameWidthCm = 30,
  });

  /// Used only in the reference-object fallback path (no depth map): a flat
  /// assumed height for the food mound. Deliberately conservative — this
  /// path is documented as materially rougher than depth-based estimation.
  final double assumedMoundHeightCm;

  /// Used only in the reference-object fallback path when the native side
  /// didn't supply a scale hint: assumes the photo's full width represents
  /// roughly a dinner-plate-sized frame (~30cm).
  final double assumedFrameWidthCm;

  FoodEstimate estimate({
    required DepthCaptureResult capture,
    required BoundingBox boundingBox,
    required DensityCategory densityCategory,
    FoodProduct? nutritionMatch,
  }) {
    final volumeCm3 = capture.depthMap != null && capture.intrinsics != null
        ? _volumeFromDepthMap(capture.depthMap!, capture.intrinsics!, boundingBox)
        : _volumeFromReferenceObject(boundingBox, capture.referenceObjectScaleHint);

    final gramsPerCm3 = densityGramsPerCm3[densityCategory] ?? densityGramsPerCm3[DensityCategory.unknown]!;
    final grams = volumeCm3 * gramsPerCm3;

    // A real per-food database match (see AnalyzedFoodItem.nutritionMatch)
    // replaces the coarse per-density-category placeholder for BOTH
    // calories and macros — it's a strictly better estimate of the actual
    // food than a category average that blends very different real foods
    // together (e.g. "denseMeat" spans chicken breast and pork belly).
    // Portion mass (grams) itself is unaffected either way: it comes from
    // the depth-sensed volume x density, never from the matched product.
    final kcalPer100g = nutritionMatch?.kcalPer100g ??
        averageKcalPer100gByCategory[densityCategory] ??
        averageKcalPer100gByCategory[DensityCategory.unknown]!;
    final calories = grams / 100 * kcalPer100g;

    double? scaledPer100g(double? per100g) => per100g == null ? null : grams / 100 * per100g;

    return FoodEstimate(
      volumeCm3: volumeCm3,
      grams: grams,
      calories: calories,
      depthSource: capture.depthSource,
      isRoughEstimate: capture.depthMap == null,
      usedRealNutritionData: nutritionMatch != null,
      proteinG: scaledPer100g(nutritionMatch?.proteinPer100g),
      carbsG: scaledPer100g(nutritionMatch?.carbsPer100g),
      fatG: scaledPer100g(nutritionMatch?.fatPer100g),
      micronutrients: nutritionMatch?.micronutrients,
    );
  }

  /// Plane-sweep volume estimate: for each pixel in the bounding box, treats
  /// the surrounding border of the box as the "table/plate" reference plane,
  /// and integrates (height above that plane) x (real-world pixel area at
  /// that distance) over the box. Real-world pixel size at distance d is
  /// approximately d / focalLengthPx (pinhole camera model).
  double _volumeFromDepthMap(DepthMapData depthMap, CameraIntrinsics intrinsics, BoundingBox box) {
    final w = depthMap.widthPx;
    final h = depthMap.heightPx;
    if (w == 0 || h == 0) return 0;

    final xMinPx = (box.xMin * w).round().clamp(0, w - 1);
    final xMaxPx = (box.xMax * w).round().clamp(0, w - 1);
    final yMinPx = (box.yMin * h).round().clamp(0, h - 1);
    final yMaxPx = (box.yMax * h).round().clamp(0, h - 1);
    if (xMaxPx <= xMinPx || yMaxPx <= yMinPx) return 0;

    double depthAt(int x, int y) => depthMap.depthValuesMeters[y * w + x];

    final tableDepthM = _estimateTableDepth(depthMap, xMinPx, yMinPx, xMaxPx, yMaxPx);
    if (tableDepthM == null || tableDepthM <= 0) return 0;

    double volumeM3 = 0;
    for (var y = yMinPx; y <= yMaxPx; y++) {
      for (var x = xMinPx; x <= xMaxPx; x++) {
        final d = depthAt(x, y);
        if (d.isNaN || d <= 0) continue;
        final heightM = tableDepthM - d;
        if (heightM <= 0) continue;
        final pixelSizeM = d / intrinsics.focalLengthXPx;
        volumeM3 += heightM * pixelSizeM * pixelSizeM;
      }
    }
    return volumeM3 * 1e6; // m^3 -> cm^3
  }

  /// Samples the pixel border just outside the bounding box (expected to be
  /// plate/table surface, not food) and takes the median as the reference
  /// depth the food mound's height is measured against.
  double? _estimateTableDepth(DepthMapData depthMap, int xMin, int yMin, int xMax, int yMax) {
    final w = depthMap.widthPx;
    final h = depthMap.heightPx;
    double depthAt(int x, int y) => depthMap.depthValuesMeters[y * w + x];

    final expandedXMin = (xMin - 4).clamp(0, w - 1);
    final expandedXMax = (xMax + 4).clamp(0, w - 1);
    final expandedYMin = (yMin - 4).clamp(0, h - 1);
    final expandedYMax = (yMax + 4).clamp(0, h - 1);

    final samples = <double>[];
    for (var x = expandedXMin; x <= expandedXMax; x++) {
      _addIfValid(samples, depthAt(x, expandedYMin));
      _addIfValid(samples, depthAt(x, expandedYMax));
    }
    for (var y = expandedYMin; y <= expandedYMax; y++) {
      _addIfValid(samples, depthAt(expandedXMin, y));
      _addIfValid(samples, depthAt(expandedXMax, y));
    }

    if (samples.isEmpty) return null;
    samples.sort();
    return samples[samples.length ~/ 2];
  }

  void _addIfValid(List<double> samples, double value) {
    if (!value.isNaN && value > 0) samples.add(value);
  }

  /// Materially rougher fallback used when no depth data is available at
  /// all (reference-object method — see project plan §6, fallback tier 3).
  /// Assumes the bounding box maps linearly onto an assumed real-world
  /// frame width, and applies a flat assumed mound height rather than a
  /// measured one.
  double _volumeFromReferenceObject(BoundingBox box, double? scaleHintCmPerFrameWidth) {
    final frameWidthCm = scaleHintCmPerFrameWidth ?? assumedFrameWidthCm;
    final widthCm = box.width * frameWidthCm;
    // Assume roughly square pixels in real-world cm (no separate vertical
    // scale hint in Phase 1) — a further-known limitation of this fallback.
    final depthCm = box.height * frameWidthCm;
    final areaCm2 = widthCm * depthCm;
    return math.max(0, areaCm2 * assumedMoundHeightCm);
  }
}
