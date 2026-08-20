import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/data/models/meal_type.dart';
import 'package:calorie_app/data/models/recipe.dart';
import 'package:calorie_app/features/auth/auth_providers.dart';
import 'package:calorie_app/features/food_log/food_log_providers.dart';
import 'package:calorie_app/features/recipes/recipes_providers.dart';

ProviderContainer _buildContainer() {
  final mockAuth = MockFirebaseAuth(mockUser: MockUser(uid: 'test-uid', email: 't@e.com'), signedIn: true);
  final fakeFirestore = FakeFirebaseFirestore();

  return ProviderContainer(
    overrides: [
      firebaseAuthProvider.overrideWithValue(mockAuth),
      firestoreProvider.overrideWithValue(fakeFirestore),
    ],
  );
}

void main() {
  test('saveRecipe persists a new recipe with its icon, deleteRecipe removes it', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();
    final notifier = container.read(recipesProvider.notifier);

    await notifier.saveRecipe(
      name: 'Salata mea',
      servings: 2,
      ingredients: const [RecipeIngredient(name: 'Pui', grams: 200, kcalPer100g: 165)],
      icon: '🥗',
    );
    await pumpEventQueue();

    final recipes = container.read(recipesProvider);
    expect(recipes, hasLength(1));
    expect(recipes.single.name, 'Salata mea');
    expect(recipes.single.icon, '🥗');

    await notifier.deleteRecipe(recipes.single.id);
    await pumpEventQueue();

    expect(container.read(recipesProvider), isEmpty);
  });

  test('logServings scales grams by servings eaten, keeping densities fixed', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();
    final notifier = container.read(recipesProvider.notifier);
    final date = DateTime(2026, 6, 1);

    await notifier.saveRecipe(
      name: 'Tocanita',
      servings: 4,
      // 400g total across 4 servings = 100g/serving, 200 kcal/100g density.
      ingredients: const [RecipeIngredient(name: 'Carne', grams: 400, kcalPer100g: 200)],
    );
    await pumpEventQueue();
    final recipe = container.read(recipesProvider).single;

    await notifier.logServings(recipe, mealType: MealType.dinner, date: date, servingsEaten: 1.5);
    await pumpEventQueue();

    final loggedEntries = container.read(dailyLogProvider(date));
    expect(loggedEntries, hasLength(1));
    // 100g/serving * 1.5 servings = 150g, at 200 kcal/100g = 300 kcal.
    expect(loggedEntries.single.grams, 150);
    expect(loggedEntries.single.calories, 300);
    expect(loggedEntries.single.foodName, 'Tocanita');
  });
}
