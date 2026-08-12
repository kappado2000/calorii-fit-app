/// A user-entered commercial product remembered for reuse — name + calorie
/// index (kcal per 100g). Kept deliberately minimal for now (grams +
/// caloric index only, as requested); macro fields can be added later
/// (Phase 5) without breaking this shape.
class CustomFood {
  const CustomFood({required this.id, required this.name, required this.kcalPer100g});

  final String id;
  final String name;
  final double kcalPer100g;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'kcalPer100g': kcalPer100g};

  factory CustomFood.fromJson(Map<String, dynamic> json) {
    return CustomFood(
      id: json['id'] as String,
      name: json['name'] as String,
      kcalPer100g: (json['kcalPer100g'] as num).toDouble(),
    );
  }
}
