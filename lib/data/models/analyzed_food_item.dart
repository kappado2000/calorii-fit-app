import '../../core/constants/density_table.dart';
import 'bounding_box.dart';
import 'food_product.dart';

/// One food item as identified by Claude — identification only, no
/// volume/weight/calories (those are computed locally, see
/// VolumeToCalorieCalculator and CalorieEstimator in domain/usecases).
class AnalyzedFoodItem {
  const AnalyzedFoodItem({
    required this.label,
    required this.confidence,
    required this.boundingBox,
    required this.densityCategory,
    required this.textureCues,
    this.notes,
    this.nutritionMatch,
  });

  final String label;
  final double confidence;
  final BoundingBox boundingBox;
  final DensityCategory densityCategory;
  final String textureCues;
  final String? notes;

  /// Best-effort real per-100g nutrition match for [label], found
  /// server-side against the same database the manual/barcode search uses
  /// (see analyzePhoto.ts). Null when nothing matched confidently — the
  /// calorie calculator then falls back to the coarse per-category average.
  final FoodProduct? nutritionMatch;

  factory AnalyzedFoodItem.fromJson(Map<String, dynamic> json) {
    final nutritionMatchJson = json['nutritionMatch'] as Map<String, dynamic>?;
    return AnalyzedFoodItem(
      label: json['label'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      boundingBox: BoundingBox.fromJson(json['boundingBox'] as Map<String, dynamic>),
      densityCategory: densityCategoryFromWire(json['estimatedDensityCategory'] as String),
      textureCues: json['textureCues'] as String? ?? '',
      notes: json['notes'] as String?,
      nutritionMatch: nutritionMatchJson == null ? null : FoodProduct.fromJson(nutritionMatchJson),
    );
  }
}

class AnalyzePhotoResponse {
  const AnalyzePhotoResponse({
    required this.mixedPlateDetected,
    required this.overallConfidence,
    required this.items,
  });

  final bool mixedPlateDetected;
  final double overallConfidence;
  final List<AnalyzedFoodItem> items;

  factory AnalyzePhotoResponse.fromJson(Map<String, dynamic> json) {
    return AnalyzePhotoResponse(
      mixedPlateDetected: json['mixedPlateDetected'] as bool? ?? false,
      overallConfidence: (json['overallConfidence'] as num?)?.toDouble() ?? 0,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => AnalyzedFoodItem.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}
