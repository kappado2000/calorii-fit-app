import '../../core/constants/micronutrient_reference.dart';
import '../../data/models/food_log_entry.dart';

/// One food's contribution to a single nutrient over a period — [amount]
/// is the absolute total (grams for macros, mg/µg for micronutrients);
/// [sharePercent] is that food's share of the nutrient's period total.
class NutrientSource {
  const NutrientSource({required this.foodName, required this.amount, required this.sharePercent});

  final String foodName;
  final double amount;
  final double sharePercent;
}

class NutrientSourcesSummary {
  const NutrientSourcesSummary({required this.macroSources, required this.micronutrientSources});

  final Map<MacroNutrient, List<NutrientSource>> macroSources;
  final Map<Micronutrient, List<NutrientSource>> micronutrientSources;

  static const empty = NutrientSourcesSummary(macroSources: {}, micronutrientSources: {});
}

/// For each macro/micronutrient, which foods in [entries] contributed to
/// it and what share of that nutrient's period total each one represents
/// — "alimentele predominante" per nutrient, not just a period-wide total.
/// Same food name logged multiple times in the period is summed into one
/// source rather than appearing as repeated rows. A nutrient with no data
/// across every entry is simply absent from the result maps (see
/// FoodLogEntry's own nullable-macro/partial-micronutrient-coverage
/// rationale) rather than showing a fabricated zero-share list.
NutrientSourcesSummary computeNutrientSources(List<FoodLogEntry> entries) {
  final macroTotals = <MacroNutrient, Map<String, double>>{
    for (final macro in MacroNutrient.values) macro: {},
  };
  final microTotals = <Micronutrient, Map<String, double>>{
    for (final nutrient in Micronutrient.values) nutrient: {},
  };

  for (final entry in entries) {
    _addIfPresent(macroTotals[MacroNutrient.protein]!, entry.foodName, entry.protein);
    _addIfPresent(macroTotals[MacroNutrient.carbs]!, entry.foodName, entry.carbs);
    _addIfPresent(macroTotals[MacroNutrient.fat]!, entry.foodName, entry.fat);
    for (final nutrient in Micronutrient.values) {
      _addIfPresent(microTotals[nutrient]!, entry.foodName, entry.micronutrientAmount(nutrient));
    }
  }

  return NutrientSourcesSummary(
    macroSources: macroTotals.map((macro, byFood) => MapEntry(macro, _rankedSources(byFood))),
    micronutrientSources: microTotals.map((nutrient, byFood) => MapEntry(nutrient, _rankedSources(byFood))),
  );
}

void _addIfPresent(Map<String, double> byFood, String foodName, double? amount) {
  if (amount == null || amount <= 0) return;
  byFood[foodName] = (byFood[foodName] ?? 0) + amount;
}

/// Descending by amount, with each food's share of the nutrient's period
/// total — empty (not a divide-by-zero list) when nothing contributed.
List<NutrientSource> _rankedSources(Map<String, double> byFood) {
  final total = byFood.values.fold<double>(0, (sum, v) => sum + v);
  if (total <= 0) return const [];

  final sources = byFood.entries
      .map((e) => NutrientSource(foodName: e.key, amount: e.value, sharePercent: e.value / total * 100))
      .toList();
  sources.sort((a, b) => b.amount.compareTo(a.amount));
  return sources;
}
