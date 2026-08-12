import 'density_table.dart';

/// Phase 1 placeholder: average kcal/100g per density category, used only
/// until real per-food nutrition lookup (USDA FoodData Central / Open Food
/// Facts) lands in Phase 4. This exists so the photo -> calorie pipeline
/// produces an end-to-end number to validate against real plates now,
/// not because it's an accurate substitute for a real food database.
const Map<DensityCategory, double> averageKcalPer100gByCategory = {
  DensityCategory.cookedRice: 130,
  DensityCategory.cookedPasta: 160,
  DensityCategory.leafySalad: 20,
  DensityCategory.choppedVegetables: 40,
  DensityCategory.denseMeat: 190,
  DensityCategory.groundMeat: 230,
  DensityCategory.fish: 180,
  DensityCategory.legumes: 120,
  DensityCategory.soupStew: 110,
  DensityCategory.breadBaked: 265,
  DensityCategory.friedStarch: 310,
  DensityCategory.cheeseSolid: 380,
  DensityCategory.sauceThin: 90,
  DensityCategory.fruitWhole: 55,
  DensityCategory.eggCooked: 150,
  DensityCategory.dessertBaked: 380,
  DensityCategory.unknown: 150,
};
