import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/data/models/food_log_entry.dart';
import 'package:calorie_app/data/models/meal_type.dart';

void main() {
  test('protein/carbs/fat scale linearly with grams when known', () {
    final entry = FoodLogEntry(
      id: '1',
      mealType: MealType.lunch,
      foodName: 'Iaurt grecesc',
      grams: 200,
      kcalPer100g: 100,
      proteinPer100g: 10,
      carbsPer100g: 20,
      fatPer100g: 5,
    );

    expect(entry.calories, 200);
    expect(entry.protein, 20);
    expect(entry.carbs, 40);
    expect(entry.fat, 10);
  });

  test('macro getters stay null when the macro is unknown, not zero', () {
    const entry = FoodLogEntry(id: '2', mealType: MealType.lunch, foodName: 'Necunoscut', grams: 100, kcalPer100g: 50);

    expect(entry.protein, isNull);
    expect(entry.carbs, isNull);
    expect(entry.fat, isNull);
  });

  test('toJson/fromJson round-trips macro fields, including null', () {
    const withMacros = FoodLogEntry(
      id: '3',
      mealType: MealType.dinner,
      foodName: 'Piept de pui',
      grams: 150,
      kcalPer100g: 165,
      proteinPer100g: 31,
      carbsPer100g: 0,
      fatPer100g: 3.6,
    );
    final decoded = FoodLogEntry.fromJson(withMacros.toJson());
    expect(decoded.proteinPer100g, 31);
    expect(decoded.carbsPer100g, 0);
    expect(decoded.fatPer100g, 3.6);

    const withoutMacros = FoodLogEntry(id: '4', mealType: MealType.snack, foodName: 'X', grams: 50, kcalPer100g: 200);
    final decodedNoMacros = FoodLogEntry.fromJson(withoutMacros.toJson());
    expect(decodedNoMacros.proteinPer100g, isNull);
    expect(decodedNoMacros.carbsPer100g, isNull);
    expect(decodedNoMacros.fatPer100g, isNull);
  });
}
