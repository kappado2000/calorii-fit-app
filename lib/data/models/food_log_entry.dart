import '../../core/constants/micronutrient_reference.dart';
import 'meal_type.dart';

/// One logged food entry within a day's diary — always tied to a meal
/// (breakfast/lunch/dinner) per the app's menu structure. Macro fields are
/// nullable: entries logged before macro tracking was added, or fully
/// manual entries where the user only knows the calorie index, simply omit
/// them rather than showing a fabricated zero. [micronutrients] is nullable
/// for the same reason and is additionally only populated for a subset of
/// foods (see MicronutrientProfile) — most home-cooked entries won't have it.
class FoodLogEntry {
  const FoodLogEntry({
    required this.id,
    required this.mealType,
    required this.foodName,
    required this.grams,
    required this.kcalPer100g,
    this.proteinPer100g,
    this.carbsPer100g,
    this.fatPer100g,
    this.micronutrients,
  });

  final String id;
  final MealType mealType;
  final String foodName;
  final double grams;
  final double kcalPer100g;
  final double? proteinPer100g;
  final double? carbsPer100g;
  final double? fatPer100g;
  final MicronutrientProfile? micronutrients;

  double get calories => grams / 100 * kcalPer100g;
  double? get protein => proteinPer100g == null ? null : grams / 100 * proteinPer100g!;
  double? get carbs => carbsPer100g == null ? null : grams / 100 * carbsPer100g!;
  double? get fat => fatPer100g == null ? null : grams / 100 * fatPer100g!;

  /// True when any of macros/micronutrients is missing — not just when
  /// *all* of them are (a fully manual entry). A real database match
  /// commonly carries macros but no micronutrients (see the class doc),
  /// which is just as much a gap the AI-completion feature should offer to
  /// fill — see FoodNutritionCompletionController, which preserves
  /// whichever of these fields are already non-null rather than
  /// overwriting them with a fresh AI guess.
  bool get needsNutritionCompletion =>
      proteinPer100g == null || carbsPer100g == null || fatPer100g == null || micronutrients == null;

  /// The actual amount of [nutrient] contributed by this entry's portion,
  /// or null if this food has no known value for it.
  double? micronutrientAmount(Micronutrient nutrient) {
    final per100g = micronutrients?.valueFor(nutrient);
    return per100g == null ? null : grams / 100 * per100g;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'mealType': mealType.name,
    'foodName': foodName,
    'grams': grams,
    'kcalPer100g': kcalPer100g,
    'proteinPer100g': proteinPer100g,
    'carbsPer100g': carbsPer100g,
    'fatPer100g': fatPer100g,
    'micronutrients': micronutrients?.toJson(),
  };

  factory FoodLogEntry.fromJson(Map<String, dynamic> json) {
    final micronutrientsJson = json['micronutrients'] as Map<String, dynamic>?;
    return FoodLogEntry(
      id: json['id'] as String,
      mealType: MealType.values.firstWhere(
        (type) => type.name == json['mealType'],
        orElse: () => MealType.breakfast,
      ),
      foodName: json['foodName'] as String,
      grams: (json['grams'] as num).toDouble(),
      kcalPer100g: (json['kcalPer100g'] as num).toDouble(),
      proteinPer100g: (json['proteinPer100g'] as num?)?.toDouble(),
      carbsPer100g: (json['carbsPer100g'] as num?)?.toDouble(),
      fatPer100g: (json['fatPer100g'] as num?)?.toDouble(),
      micronutrients: micronutrientsJson == null ? null : MicronutrientProfile.fromJson(micronutrientsJson),
    );
  }
}
