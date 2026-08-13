/// A commercial product returned by the searchFoods Cloud Function
/// (Open Food Facts) — the app-determined nutritional facts for a product
/// the user picked by name, before they enter how many grams they ate.
class FoodProduct {
  const FoodProduct({
    required this.name,
    required this.kcalPer100g,
    this.barcode,
    this.brand,
    this.proteinPer100g,
    this.carbsPer100g,
    this.fatPer100g,
    this.imageUrl,
  });

  final String? barcode;
  final String name;
  final String? brand;
  final double kcalPer100g;
  final double? proteinPer100g;
  final double? carbsPer100g;
  final double? fatPer100g;
  final String? imageUrl;

  /// Name including brand, when known, for disambiguating near-identical
  /// product names in the results list (e.g. two different "Iaurt grecesc").
  String get displayName => brand == null ? name : '$name — $brand';

  factory FoodProduct.fromJson(Map<String, dynamic> json) {
    return FoodProduct(
      barcode: json['barcode'] as String?,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      kcalPer100g: (json['kcalPer100g'] as num).toDouble(),
      proteinPer100g: (json['proteinPer100g'] as num?)?.toDouble(),
      carbsPer100g: (json['carbsPer100g'] as num?)?.toDouble(),
      fatPer100g: (json['fatPer100g'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
