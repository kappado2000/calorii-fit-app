/**
 * Static food-density reference table sent to Claude as part of the cached
 * system prompt (see analyzePhoto.ts). Categories are intentionally coarse —
 * Claude picks the closest category per identified food item, and the actual
 * grams-per-cm3 lookup happens client-side against this same table.
 *
 * NOTE: this is a Phase 1 starter set (~duzine of categories), tuned later
 * against the `analysisLogs` correction data described in the project plan.
 */
export const DENSITY_TABLE: Record<string, { label: string; gPerCm3: number; examples: string }> = {
  cookedRice: { label: "cooked rice / grains", gPerCm3: 0.85, examples: "white rice, pilaf, quinoa" },
  cookedPasta: { label: "cooked pasta", gPerCm3: 0.6, examples: "spaghetti, penne, noodles" },
  leafySalad: { label: "leafy salad / raw greens", gPerCm3: 0.2, examples: "lettuce, spinach, mixed greens" },
  choppedVegetables: { label: "chopped/cooked vegetables", gPerCm3: 0.55, examples: "broccoli, carrots, peppers" },
  denseMeat: { label: "dense cooked meat", gPerCm3: 1.05, examples: "grilled chicken breast, steak, pork chop" },
  groundMeat: { label: "ground/minced meat dish", gPerCm3: 0.95, examples: "meatballs, burger patty, mince sauce" },
  fish: { label: "cooked fish", gPerCm3: 1.0, examples: "salmon fillet, white fish, fried fish" },
  legumes: { label: "beans / legumes", gPerCm3: 0.8, examples: "lentils, chickpeas, black beans" },
  soupStew: { label: "soup / stew / curry", gPerCm3: 1.0, examples: "curry, goulash, thick soup" },
  breadBaked: { label: "bread / baked dough", gPerCm3: 0.3, examples: "bread slice, roll, flatbread" },
  friedStarch: { label: "fried starchy side", gPerCm3: 0.55, examples: "french fries, hash browns" },
  cheeseSolid: { label: "solid cheese", gPerCm3: 1.1, examples: "cheese cubes, slices" },
  sauceThin: { label: "thin sauce / dressing", gPerCm3: 1.0, examples: "vinaigrette, gravy, thin sauce" },
  fruitWhole: { label: "whole/sliced fruit", gPerCm3: 0.65, examples: "apple slices, banana, berries" },
  eggCooked: { label: "cooked egg", gPerCm3: 1.03, examples: "fried egg, omelette, boiled egg" },
  dessertBaked: { label: "baked dessert", gPerCm3: 0.5, examples: "cake slice, pastry" },
  unknown: { label: "unclassified / mixed", gPerCm3: 0.7, examples: "fallback when no category fits well" },
};

export function densityTableAsPromptText(): string {
  const rows = Object.entries(DENSITY_TABLE)
    .map(([key, v]) => `- ${key}: ${v.label} (~${v.gPerCm3} g/cm3) — e.g. ${v.examples}`)
    .join("\n");
  return `Density reference table (key: description (g/cm3) — examples):\n${rows}`;
}
