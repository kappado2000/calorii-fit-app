/// A product remembered for reuse — either typed in manually, or picked
/// once from the commercial-product search (see FoodProduct) and kept here
/// so the next search for the same name is instant even offline. Macro
/// fields are nullable for fully-manual entries where the user only knows
/// the calorie index.
class CustomFood {
  const CustomFood({
    required this.id,
    required this.name,
    required this.kcalPer100g,
    this.proteinPer100g,
    this.carbsPer100g,
    this.fatPer100g,
  });

  final String id;
  final String name;
  final double kcalPer100g;
  final double? proteinPer100g;
  final double? carbsPer100g;
  final double? fatPer100g;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'kcalPer100g': kcalPer100g,
    'proteinPer100g': proteinPer100g,
    'carbsPer100g': carbsPer100g,
    'fatPer100g': fatPer100g,
  };

  factory CustomFood.fromJson(Map<String, dynamic> json) {
    return CustomFood(
      id: json['id'] as String,
      name: json['name'] as String,
      kcalPer100g: (json['kcalPer100g'] as num).toDouble(),
      proteinPer100g: (json['proteinPer100g'] as num?)?.toDouble(),
      carbsPer100g: (json['carbsPer100g'] as num?)?.toDouble(),
      fatPer100g: (json['fatPer100g'] as num?)?.toDouble(),
    );
  }
}
