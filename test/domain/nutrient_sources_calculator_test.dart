import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/core/constants/micronutrient_reference.dart';
import 'package:calorie_app/data/models/food_log_entry.dart';
import 'package:calorie_app/data/models/meal_type.dart';
import 'package:calorie_app/domain/usecases/nutrient_sources_calculator.dart';

FoodLogEntry _entry({
  required String foodName,
  required double grams,
  double kcalPer100g = 100,
  double? proteinPer100g,
  double? carbsPer100g,
  double? fatPer100g,
  MicronutrientProfile? micronutrients,
}) {
  return FoodLogEntry(
    id: '$foodName-${grams.toStringAsFixed(0)}',
    mealType: MealType.lunch,
    foodName: foodName,
    grams: grams,
    kcalPer100g: kcalPer100g,
    proteinPer100g: proteinPer100g,
    carbsPer100g: carbsPer100g,
    fatPer100g: fatPer100g,
    micronutrients: micronutrients,
  );
}

void main() {
  test('ranks foods by their share of a macro, descending', () {
    final entries = [
      _entry(foodName: 'Piept de pui', grams: 200, proteinPer100g: 31), // 62g protein
      _entry(foodName: 'Ou fiert', grams: 100, proteinPer100g: 13), // 13g protein
      _entry(foodName: 'Orez', grams: 200, carbsPer100g: 28), // no protein at all
    ];

    final summary = computeNutrientSources(entries);
    final protein = summary.macroSources[MacroNutrient.protein]!;

    expect(protein, hasLength(2)); // Orez has no protein, correctly excluded
    expect(protein[0].foodName, 'Piept de pui');
    expect(protein[0].amount, closeTo(62, 0.001));
    expect(protein[1].foodName, 'Ou fiert');
    // 62 / (62+13) = 82.67%, 13 / 75 = 17.33%
    expect(protein[0].sharePercent, closeTo(82.67, 0.1));
    expect(protein[1].sharePercent, closeTo(17.33, 0.1));
    expect(protein[0].sharePercent + protein[1].sharePercent, closeTo(100, 0.001));
  });

  test('sums the same food name logged multiple times into one source', () {
    final entries = [
      _entry(foodName: 'Iaurt grecesc', grams: 100, proteinPer100g: 10),
      _entry(foodName: 'Iaurt grecesc', grams: 150, proteinPer100g: 10),
    ];

    final summary = computeNutrientSources(entries);
    final protein = summary.macroSources[MacroNutrient.protein]!;

    expect(protein, hasLength(1)); // one row, not two
    expect(protein.single.amount, closeTo(25, 0.001)); // 10 + 15
    expect(protein.single.sharePercent, closeTo(100, 0.001));
  });

  test('a macro with zero contributions across every entry is absent, not an empty-share list', () {
    final entries = [_entry(foodName: 'Ulei', grams: 10, fatPer100g: 100)];

    final summary = computeNutrientSources(entries);

    expect(summary.macroSources[MacroNutrient.protein], isEmpty);
    expect(summary.macroSources[MacroNutrient.carbs], isEmpty);
    expect(summary.macroSources[MacroNutrient.fat], hasLength(1));
  });

  test('micronutrients are ranked the same way, independently of macro coverage', () {
    final entries = [
      _entry(
        foodName: 'Portocală',
        grams: 100,
        micronutrients: const MicronutrientProfile(vitaminCMg: 53.2),
      ),
      _entry(
        foodName: 'Ardei gras roșu',
        grams: 100,
        micronutrients: const MicronutrientProfile(vitaminCMg: 127.7),
      ),
      _entry(foodName: 'Piept de pui', grams: 100, proteinPer100g: 31), // no micronutrients at all
    ];

    final summary = computeNutrientSources(entries);
    final vitaminC = summary.micronutrientSources[Micronutrient.vitaminC]!;

    expect(vitaminC, hasLength(2)); // chicken breast correctly excluded
    expect(vitaminC.first.foodName, 'Ardei gras roșu'); // higher amount ranks first
    expect(summary.micronutrientSources[Micronutrient.vitaminD], isEmpty);
  });

  test('computeNutrientSources on an empty entry list returns only empty source lists', () {
    final summary = computeNutrientSources(const []);

    for (final macro in MacroNutrient.values) {
      expect(summary.macroSources[macro], isEmpty);
    }
    for (final nutrient in Micronutrient.values) {
      expect(summary.micronutrientSources[nutrient], isEmpty);
    }
  });
}
