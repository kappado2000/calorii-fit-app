import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/data/models/recipe.dart';

void main() {
  final recipe = Recipe(
    id: 'r1',
    name: 'Salata mea de pui',
    servings: 2,
    ingredients: const [
      RecipeIngredient(name: 'Piept de pui', grams: 200, kcalPer100g: 165, proteinPer100g: 31, carbsPer100g: 0, fatPer100g: 3.6),
      RecipeIngredient(name: 'Salată verde', grams: 100, kcalPer100g: 15, proteinPer100g: 1.4, carbsPer100g: 2.9, fatPer100g: 0.2),
    ],
  );

  test('totalGrams and totalCalories sum every ingredient', () {
    expect(recipe.totalGrams, 300);
    expect(recipe.totalCalories, closeTo(200 / 100 * 165 + 100 / 100 * 15, 0.01));
  });

  test('perServingGrams divides total by the serving count', () {
    expect(recipe.perServingGrams, 150);
  });

  test('kcalPer100g is a weighted density of the whole mixed dish', () {
    final expectedDensity = recipe.totalCalories / recipe.totalGrams * 100;
    expect(recipe.kcalPer100g, closeTo(expectedDensity, 0.01));
  });

  test('macro density is null when any ingredient is missing that macro', () {
    final partial = Recipe(
      id: 'r2',
      name: 'Mix cu un ingredient manual',
      servings: 1,
      ingredients: const [
        RecipeIngredient(name: 'Orez', grams: 150, kcalPer100g: 130, proteinPer100g: 2.7, carbsPer100g: 28, fatPer100g: 0.3),
        RecipeIngredient(name: 'Sos secret', grams: 20, kcalPer100g: 300),
      ],
    );

    expect(partial.proteinPer100g, isNull);
    expect(partial.kcalPer100g, greaterThan(0));
  });

  test('a recipe with zero total grams reports zero density instead of dividing by zero', () {
    const empty = Recipe(id: 'r3', name: 'Gol', servings: 1, ingredients: []);
    expect(empty.kcalPer100g, 0);
    expect(empty.perServingGrams, 0);
  });
}
