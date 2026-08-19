/// One ingredient within a saved [Recipe] — a nutrition snapshot (same
/// per-100g shape as FoodLogEntry/CustomFood), not a live reference, so a
/// recipe's macros stay stable even if the source product's data changes
/// later.
class RecipeIngredient {
  const RecipeIngredient({
    required this.name,
    required this.grams,
    required this.kcalPer100g,
    this.proteinPer100g,
    this.carbsPer100g,
    this.fatPer100g,
  });

  final String name;
  final double grams;
  final double kcalPer100g;
  final double? proteinPer100g;
  final double? carbsPer100g;
  final double? fatPer100g;

  double get calories => grams / 100 * kcalPer100g;

  Map<String, dynamic> toJson() => {
    'name': name,
    'grams': grams,
    'kcalPer100g': kcalPer100g,
    'proteinPer100g': proteinPer100g,
    'carbsPer100g': carbsPer100g,
    'fatPer100g': fatPer100g,
  };

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) => RecipeIngredient(
    name: json['name'] as String,
    grams: (json['grams'] as num).toDouble(),
    kcalPer100g: (json['kcalPer100g'] as num).toDouble(),
    proteinPer100g: (json['proteinPer100g'] as num?)?.toDouble(),
    carbsPer100g: (json['carbsPer100g'] as num?)?.toDouble(),
    fatPer100g: (json['fatPer100g'] as num?)?.toDouble(),
  );
}

/// A saved combination of ingredients the user cooks/eats together
/// repeatedly (e.g. "Salata mea de pui") — logged as a single diary entry
/// (see RecipesNotifier.logServings), not as N separate ingredient rows,
/// matching how a home-cooked meal is actually remembered and re-logged.
class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.servings,
    required this.ingredients,
  });

  final String id;
  final String name;
  final int servings;
  final List<RecipeIngredient> ingredients;

  double get totalGrams => ingredients.fold(0, (sum, i) => sum + i.grams);
  double get totalCalories => ingredients.fold(0, (sum, i) => sum + i.calories);
  double get perServingGrams => servings <= 0 ? totalGrams : totalGrams / servings;

  /// Macro density of the mixed recipe as a whole — the same "per 100g of
  /// the finished dish" shape a FoodLogEntry expects, so logging N servings
  /// is just grams = perServingGrams * N against these densities.
  double get kcalPer100g => totalGrams <= 0 ? 0 : totalCalories / totalGrams * 100;

  double? get proteinPer100g => _densityOrNull((i) => i.proteinPer100g);
  double? get carbsPer100g => _densityOrNull((i) => i.carbsPer100g);
  double? get fatPer100g => _densityOrNull((i) => i.fatPer100g);

  /// Null (rather than an understated partial sum) unless every ingredient
  /// has this macro known — a recipe missing one ingredient's protein
  /// shouldn't silently report a too-low protein total.
  double? _densityOrNull(double? Function(RecipeIngredient) select) {
    if (totalGrams <= 0) return null;
    var sum = 0.0;
    for (final ingredient in ingredients) {
      final value = select(ingredient);
      if (value == null) return null;
      sum += ingredient.grams / 100 * value;
    }
    return sum / totalGrams * 100;
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'servings': servings,
    'ingredients': ingredients.map((i) => i.toJson()).toList(),
  };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'] as String,
    name: json['name'] as String,
    servings: (json['servings'] as num).toInt(),
    ingredients: (json['ingredients'] as List<dynamic>)
        .map((i) => RecipeIngredient.fromJson(i as Map<String, dynamic>))
        .toList(),
  );
}
