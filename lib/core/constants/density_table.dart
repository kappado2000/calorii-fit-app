/// Mirrors functions/src/densityTable.ts — the category keys here MUST match
/// the `estimatedDensityCategory` enum values Claude is asked to return, and
/// the calorie math (volume x density) happens locally using this table
/// rather than trusting a model-provided weight.
enum DensityCategory {
  cookedRice,
  cookedPasta,
  leafySalad,
  choppedVegetables,
  denseMeat,
  groundMeat,
  fish,
  legumes,
  soupStew,
  breadBaked,
  friedStarch,
  cheeseSolid,
  sauceThin,
  fruitWhole,
  eggCooked,
  dessertBaked,
  unknown,
}

DensityCategory densityCategoryFromWire(String value) {
  return DensityCategory.values.firstWhere(
    (category) => category.name == value,
    orElse: () => DensityCategory.unknown,
  );
}

/// Grams per cubic centimeter for each density category. Approximate,
/// tuned iteratively against real corrections in later phases (see
/// `analysisLogs` in the project plan) rather than treated as ground truth.
const Map<DensityCategory, double> densityGramsPerCm3 = {
  DensityCategory.cookedRice: 0.85,
  DensityCategory.cookedPasta: 0.6,
  DensityCategory.leafySalad: 0.2,
  DensityCategory.choppedVegetables: 0.55,
  DensityCategory.denseMeat: 1.05,
  DensityCategory.groundMeat: 0.95,
  DensityCategory.fish: 1.0,
  DensityCategory.legumes: 0.8,
  DensityCategory.soupStew: 1.0,
  DensityCategory.breadBaked: 0.3,
  DensityCategory.friedStarch: 0.55,
  DensityCategory.cheeseSolid: 1.1,
  DensityCategory.sauceThin: 1.0,
  DensityCategory.fruitWhole: 0.65,
  DensityCategory.eggCooked: 1.03,
  DensityCategory.dessertBaked: 0.5,
  DensityCategory.unknown: 0.7,
};
