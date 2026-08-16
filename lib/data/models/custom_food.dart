import '../../core/constants/micronutrient_reference.dart';

/// A product remembered for reuse — either typed in manually, or picked
/// once from the commercial-product search (see FoodProduct) and kept here
/// so the next search for the same name is instant even offline. Macro
/// fields are nullable for fully-manual entries where the user only knows
/// the calorie index. [lastGramsUsed] is the portion size from the most
/// recent time this food was logged — it's what the quick-add checklist
/// pre-fills, so re-logging a usual breakfast doesn't mean re-typing the
/// same 200g every time.
class CustomFood {
  const CustomFood({
    required this.id,
    required this.name,
    required this.kcalPer100g,
    this.proteinPer100g,
    this.carbsPer100g,
    this.fatPer100g,
    this.lastGramsUsed,
    this.micronutrients,
  });

  final String id;
  final String name;
  final double kcalPer100g;
  final double? proteinPer100g;
  final double? carbsPer100g;
  final double? fatPer100g;
  final double? lastGramsUsed;
  final MicronutrientProfile? micronutrients;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'kcalPer100g': kcalPer100g,
    'proteinPer100g': proteinPer100g,
    'carbsPer100g': carbsPer100g,
    'fatPer100g': fatPer100g,
    'lastGramsUsed': lastGramsUsed,
    'micronutrients': micronutrients?.toJson(),
  };

  factory CustomFood.fromJson(Map<String, dynamic> json) {
    final micronutrientsJson = json['micronutrients'] as Map<String, dynamic>?;
    return CustomFood(
      id: json['id'] as String,
      name: json['name'] as String,
      kcalPer100g: (json['kcalPer100g'] as num).toDouble(),
      proteinPer100g: (json['proteinPer100g'] as num?)?.toDouble(),
      carbsPer100g: (json['carbsPer100g'] as num?)?.toDouble(),
      fatPer100g: (json['fatPer100g'] as num?)?.toDouble(),
      lastGramsUsed: (json['lastGramsUsed'] as num?)?.toDouble(),
      micronutrients: micronutrientsJson == null ? null : MicronutrientProfile.fromJson(micronutrientsJson),
    );
  }
}
