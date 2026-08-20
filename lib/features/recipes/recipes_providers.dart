import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/datasources/remote/firestore/recipes_firestore_datasource.dart';
import '../../data/models/meal_type.dart';
import '../../data/models/recipe.dart';
import '../auth/uid_provider.dart';
import '../food_log/food_log_providers.dart';

const _uuid = Uuid();

class RecipesNotifier extends StateNotifier<List<Recipe>> {
  RecipesNotifier(this._dataSource, this._ref) : super([]) {
    _subscription = _dataSource.watchAll().listen((recipes) => state = recipes);
  }

  final RecipesFirestoreDataSource _dataSource;
  final Ref _ref;
  late final StreamSubscription<List<Recipe>> _subscription;

  Future<void> saveRecipe({
    String? id,
    required String name,
    required int servings,
    required List<RecipeIngredient> ingredients,
    String icon = kDefaultRecipeIcon,
  }) {
    return _dataSource.save(
      Recipe(id: id ?? _uuid.v4(), name: name, servings: servings, ingredients: ingredients, icon: icon),
    );
  }

  Future<void> deleteRecipe(String id) => _dataSource.delete(id);

  /// Logs [servingsEaten] servings of [recipe] as a single diary entry —
  /// grams scale with the serving count, densities (kcal/macros per 100g)
  /// stay fixed, exactly like scaling any other product by portion size.
  Future<void> logServings(
    Recipe recipe, {
    required MealType mealType,
    required DateTime date,
    double servingsEaten = 1,
  }) {
    return _ref
        .read(dailyLogProvider(date).notifier)
        .addEntry(
          mealType: mealType,
          foodName: recipe.name,
          grams: recipe.perServingGrams * servingsEaten,
          kcalPer100g: recipe.kcalPer100g,
          proteinPer100g: recipe.proteinPer100g,
          carbsPer100g: recipe.carbsPer100g,
          fatPer100g: recipe.fatPer100g,
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final recipesProvider = StateNotifierProvider<RecipesNotifier, List<Recipe>>((ref) {
  final uid = ref.watch(currentUidProvider);
  return RecipesNotifier(RecipesFirestoreDataSource(ref.watch(firestoreProvider), uid), ref);
});
