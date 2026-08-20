import 'package:depth_capture/depth_capture.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_app/core/constants/density_table.dart';
import 'package:calorie_app/core/constants/nutrition_reference.dart';
import 'package:calorie_app/data/models/bounding_box.dart';
import 'package:calorie_app/data/models/food_product.dart';
import 'package:calorie_app/domain/usecases/volume_to_calorie_calculator.dart';

void main() {
  final calculator = const VolumeToCalorieCalculator();

  group('depth-map based estimation', () {
    test('computes volume from a raised region against a flat table plane', () {
      // 10x10 depth map: table at 0.50m everywhere, except a 4x4 raised
      // region (rows/cols 3..6) at 0.45m (5cm mound height).
      const size = 10;
      final values = List<double>.filled(size * size, 0.50);
      for (var y = 3; y <= 6; y++) {
        for (var x = 3; x <= 6; x++) {
          values[y * size + x] = 0.45;
        }
      }
      final depthMap = DepthMapData(
        widthPx: size,
        heightPx: size,
        depthValuesMeters: values,
        filePath: '/tmp/depth.raw',
      );
      // focalLength chosen so that at 0.5m, one pixel ~= 0.5/500 = 1mm,
      // i.e. the whole 10px frame ~= 1cm across — keeps numbers small and
      // easy to hand-verify.
      const intrinsics = CameraIntrinsics(
        focalLengthXPx: 500,
        focalLengthYPx: 500,
        principalPointXPx: 5,
        principalPointYPx: 5,
      );
      final capture = DepthCaptureResult(
        photoPath: '/tmp/photo.jpg',
        depthSource: DepthSource.lidar,
        depthMap: depthMap,
        intrinsics: intrinsics,
      );
      // Bounding box covering the raised 4x4 region (normalized 0-1 over 10px).
      const box = BoundingBox(xMin: 0.3, yMin: 0.3, xMax: 0.7, yMax: 0.7);

      final result = calculator.estimate(
        capture: capture,
        boundingBox: box,
        densityCategory: DensityCategory.cookedRice,
      );

      expect(result.isRoughEstimate, isFalse);
      expect(result.depthSource, DepthSource.lidar);
      // Independently derive the expected volume from the pinhole-camera
      // formula: 16 raised pixels, each contributing
      // height(m) x (depth/focalLength)^2 (real-world pixel area at that
      // pixel's own depth) of volume.
      const raisedPixelCount = 16;
      const heightM = 0.05;
      const raisedDepthM = 0.45;
      const focalLengthPx = 500.0;
      final pixelAreaM2 = (raisedDepthM / focalLengthPx) * (raisedDepthM / focalLengthPx);
      final expectedVolumeCm3 = raisedPixelCount * heightM * pixelAreaM2 * 1e6;
      expect(result.volumeCm3, closeTo(expectedVolumeCm3, 0.01));
      expect(result.grams, closeTo(result.volumeCm3 * densityGramsPerCm3[DensityCategory.cookedRice]!, 0.5));
      expect(result.calories, greaterThan(0));
    });

    test('returns zero volume when the box has no raised pixels', () {
      const size = 6;
      final values = List<double>.filled(size * size, 0.5);
      final depthMap = DepthMapData(
        widthPx: size,
        heightPx: size,
        depthValuesMeters: values,
        filePath: '/tmp/depth.raw',
      );
      const intrinsics = CameraIntrinsics(
        focalLengthXPx: 500,
        focalLengthYPx: 500,
        principalPointXPx: 3,
        principalPointYPx: 3,
      );
      final capture = DepthCaptureResult(
        photoPath: '/tmp/photo.jpg',
        depthSource: DepthSource.arcoreDepth,
        depthMap: depthMap,
        intrinsics: intrinsics,
      );
      const box = BoundingBox(xMin: 0.2, yMin: 0.2, xMax: 0.8, yMax: 0.8);

      final result = calculator.estimate(
        capture: capture,
        boundingBox: box,
        densityCategory: DensityCategory.leafySalad,
      );

      expect(result.volumeCm3, 0);
      expect(result.grams, 0);
      expect(result.calories, 0);
    });
  });

  group('reference-object fallback estimation', () {
    test('produces a rough, non-zero estimate with no depth map', () {
      const capture = DepthCaptureResult(
        photoPath: '/tmp/photo.jpg',
        depthSource: DepthSource.referenceObjectOnly,
        referenceObjectScaleHint: 28, // assumed plate diameter in cm
      );
      const box = BoundingBox(xMin: 0.2, yMin: 0.2, xMax: 0.5, yMax: 0.5);

      final result = calculator.estimate(
        capture: capture,
        boundingBox: box,
        densityCategory: DensityCategory.denseMeat,
      );

      expect(result.isRoughEstimate, isTrue);
      expect(result.depthSource, DepthSource.referenceObjectOnly);
      expect(result.volumeCm3, greaterThan(0));
      expect(result.calories, greaterThan(0));
    });
  });

  group('nutritionMatch', () {
    const capture = DepthCaptureResult(
      photoPath: '/tmp/photo.jpg',
      depthSource: DepthSource.referenceObjectOnly,
      referenceObjectScaleHint: 28,
    );
    const box = BoundingBox(xMin: 0.2, yMin: 0.2, xMax: 0.5, yMax: 0.5);

    test('a real product match replaces the category-average calories and adds macros', () {
      const product = FoodProduct(
        name: 'Piept de pui la grătar',
        kcalPer100g: 165,
        proteinPer100g: 31,
        carbsPer100g: 0,
        fatPer100g: 3.6,
      );

      final withoutMatch = calculator.estimate(
        capture: capture,
        boundingBox: box,
        densityCategory: DensityCategory.denseMeat,
      );
      final withMatch = calculator.estimate(
        capture: capture,
        boundingBox: box,
        densityCategory: DensityCategory.denseMeat,
        nutritionMatch: product,
      );

      // Mass (grams) comes only from depth-sensed volume x density — a
      // nutrition match must never change it, only which per-100g figures
      // are applied to it.
      expect(withMatch.grams, closeTo(withoutMatch.grams, 0.001));
      expect(withMatch.usedRealNutritionData, isTrue);
      expect(withoutMatch.usedRealNutritionData, isFalse);
      expect(withoutMatch.proteinG, isNull);

      final factor = withMatch.grams / 100;
      expect(withMatch.calories, closeTo(product.kcalPer100g * factor, 0.001));
      expect(withMatch.proteinG, closeTo(product.proteinPer100g! * factor, 0.001));
      expect(withMatch.carbsG, closeTo(product.carbsPer100g! * factor, 0.001));
      expect(withMatch.fatG, closeTo(product.fatPer100g! * factor, 0.001));
      // Confirms this is actually a *different* number from the coarse
      // category placeholder, not a coincidental match.
      expect(
        withMatch.calories,
        isNot(closeTo(averageKcalPer100gByCategory[DensityCategory.denseMeat]! * factor, 0.001)),
      );
    });

    test('no nutrition match falls back to the category-average placeholder, as before', () {
      final result = calculator.estimate(
        capture: capture,
        boundingBox: box,
        densityCategory: DensityCategory.denseMeat,
      );

      expect(result.usedRealNutritionData, isFalse);
      expect(result.proteinG, isNull);
      expect(result.carbsG, isNull);
      expect(result.fatG, isNull);
      expect(result.micronutrients, isNull);
    });

    test('scaledByPortionFactor scales macros linearly alongside calories', () {
      const product = FoodProduct(name: 'Somon', kcalPer100g: 208, proteinPer100g: 20, fatPer100g: 13);
      final base = calculator.estimate(
        capture: capture,
        boundingBox: box,
        densityCategory: DensityCategory.fish,
        nutritionMatch: product,
      );

      final doubled = base.scaledByPortionFactor(2.0);

      expect(doubled.proteinG, closeTo(base.proteinG! * 2, 0.001));
      expect(doubled.fatG, closeTo(base.fatG! * 2, 0.001));
      expect(doubled.usedRealNutritionData, isTrue);
    });
  });

  group('scaledByPortionFactor', () {
    test('scales grams and calories linearly, preserving flags', () {
      const capture = DepthCaptureResult(
        photoPath: '/tmp/photo.jpg',
        depthSource: DepthSource.referenceObjectOnly,
        referenceObjectScaleHint: 28,
      );
      const box = BoundingBox(xMin: 0.2, yMin: 0.2, xMax: 0.5, yMax: 0.5);
      final base = calculator.estimate(
        capture: capture,
        boundingBox: box,
        densityCategory: DensityCategory.denseMeat,
      );

      final doubled = base.scaledByPortionFactor(2.0);

      expect(doubled.grams, closeTo(base.grams * 2, 0.001));
      expect(doubled.calories, closeTo(base.calories * 2, 0.001));
      expect(doubled.isRoughEstimate, base.isRoughEstimate);
      expect(doubled.depthSource, base.depthSource);
    });
  });
}
