import 'meal_type.dart';

/// One logged food entry within a day's diary — always tied to a meal
/// (breakfast/lunch/dinner) per the app's menu structure.
class FoodLogEntry {
  const FoodLogEntry({
    required this.id,
    required this.mealType,
    required this.foodName,
    required this.grams,
    required this.kcalPer100g,
  });

  final String id;
  final MealType mealType;
  final String foodName;
  final double grams;
  final double kcalPer100g;

  double get calories => grams / 100 * kcalPer100g;

  Map<String, dynamic> toJson() => {
    'id': id,
    'mealType': mealType.name,
    'foodName': foodName,
    'grams': grams,
    'kcalPer100g': kcalPer100g,
  };

  factory FoodLogEntry.fromJson(Map<String, dynamic> json) {
    return FoodLogEntry(
      id: json['id'] as String,
      mealType: MealType.values.firstWhere(
        (type) => type.name == json['mealType'],
        orElse: () => MealType.breakfast,
      ),
      foodName: json['foodName'] as String,
      grams: (json['grams'] as num).toDouble(),
      kcalPer100g: (json['kcalPer100g'] as num).toDouble(),
    );
  }
}
