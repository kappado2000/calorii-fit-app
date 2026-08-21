import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/micronutrient_reference.dart';
import '../../data/datasources/remote/firestore/food_log_firestore_datasource.dart';
import '../../data/datasources/remote/firestore/workout_firestore_datasource.dart';
import '../../data/models/food_log_entry.dart';
import '../../data/models/user_profile.dart';
import '../../l10n/app_localizations.dart';
import '../auth/uid_provider.dart';
import '../food_log/food_log_providers.dart';
import '../profile/profile_providers.dart';

enum ProgressPeriod { last7Days, last30Days, sinceProgramStart }

extension ProgressPeriodLabel on ProgressPeriod {
  String label(AppLocalizations l10n) {
    switch (this) {
      case ProgressPeriod.last7Days:
        return l10n.progressPeriod7Days;
      case ProgressPeriod.last30Days:
        return l10n.progressPeriod30Days;
      case ProgressPeriod.sinceProgramStart:
        return l10n.progressPeriodWholeProgram;
    }
  }
}

(DateTime start, DateTime end) _dateRangeForPeriod(ProgressPeriod period, UserProfile? profile) {
  final end = normalizeDate(DateTime.now());
  final DateTime start;
  switch (period) {
    case ProgressPeriod.last7Days:
      start = end.subtract(const Duration(days: 6));
    case ProgressPeriod.last30Days:
      start = end.subtract(const Duration(days: 29));
    case ProgressPeriod.sinceProgramStart:
      start = profile != null ? normalizeDate(profile.programStartDate) : end;
  }
  return (start, end);
}

/// Daily calorie-intake totals for the selected [ProgressPeriod], keyed by
/// normalized date — feeds the intake chart in progress_screen.dart.
final dailyCalorieHistoryProvider = StreamProvider.family<Map<DateTime, double>, ProgressPeriod>((
  ref,
  period,
) {
  final uid = ref.watch(currentUidProvider);
  final profile = ref.watch(userProfileProvider).valueOrNull;
  final (start, end) = _dateRangeForPeriod(period, profile);

  return FoodLogFirestoreDataSource(
    ref.watch(firestoreProvider),
    uid,
  ).watchDailyTotalsForRange(start, end);
});

/// Daily exercise-calories-burned totals for the selected [ProgressPeriod]
/// — combined with intake in the deficit chart (deficit = TDEE + burned -
/// intake, matching the "eat back exercise calories" model used on the
/// food log screen).
final dailyBurnedHistoryProvider = StreamProvider.family<Map<DateTime, double>, ProgressPeriod>((
  ref,
  period,
) {
  final uid = ref.watch(currentUidProvider);
  final profile = ref.watch(userProfileProvider).valueOrNull;
  final (start, end) = _dateRangeForPeriod(period, profile);

  return WorkoutFirestoreDataSource(
    ref.watch(firestoreProvider),
    uid,
  ).watchDailyTotalsForRange(start, end);
});

/// Macro + micronutrient totals across every entry in the selected period —
/// what the "meals healthy %" analysis is built from. Micronutrient
/// coverage is inherently partial (see MicronutrientProfile), so each
/// nutrient's total only counts entries that actually had a value for it,
/// and [entriesWithMicronutrientData] / [totalEntries] lets the UI show an
/// honest "date parțiale" note instead of implying full coverage.
class PeriodNutritionSummary {
  const PeriodNutritionSummary({
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.micronutrientTotals,
    required this.entriesWithMicronutrientData,
    required this.totalEntries,
  });

  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final Map<Micronutrient, double> micronutrientTotals;
  final int entriesWithMicronutrientData;
  final int totalEntries;

  static const empty = PeriodNutritionSummary(
    totalCalories: 0,
    totalProtein: 0,
    totalCarbs: 0,
    totalFat: 0,
    micronutrientTotals: {},
    entriesWithMicronutrientData: 0,
    totalEntries: 0,
  );
}

PeriodNutritionSummary _summarize(List<FoodLogEntry> entries) {
  var calories = 0.0, protein = 0.0, carbs = 0.0, fat = 0.0;
  final micronutrientTotals = <Micronutrient, double>{};
  var entriesWithMicronutrients = 0;

  for (final entry in entries) {
    calories += entry.calories;
    protein += entry.protein ?? 0;
    carbs += entry.carbs ?? 0;
    fat += entry.fat ?? 0;

    if (entry.micronutrients?.hasAnyValue ?? false) {
      entriesWithMicronutrients++;
      for (final nutrient in Micronutrient.values) {
        final amount = entry.micronutrientAmount(nutrient);
        if (amount != null) {
          micronutrientTotals[nutrient] = (micronutrientTotals[nutrient] ?? 0) + amount;
        }
      }
    }
  }

  return PeriodNutritionSummary(
    totalCalories: calories,
    totalProtein: protein,
    totalCarbs: carbs,
    totalFat: fat,
    micronutrientTotals: micronutrientTotals,
    entriesWithMicronutrientData: entriesWithMicronutrients,
    totalEntries: entries.length,
  );
}

final periodNutritionSummaryProvider = StreamProvider.family<PeriodNutritionSummary, ProgressPeriod>((
  ref,
  period,
) {
  final uid = ref.watch(currentUidProvider);
  final profile = ref.watch(userProfileProvider).valueOrNull;
  final (start, end) = _dateRangeForPeriod(period, profile);

  return FoodLogFirestoreDataSource(
    ref.watch(firestoreProvider),
    uid,
  ).watchEntriesForRange(start, end).map(_summarize);
});

/// Entries in the selected period with no macro data at all — feeds the
/// premium-only bulk "Completează cu AI" action on ProgressScreen (see
/// FoodNutritionCompletionController). A separate stream rather than
/// folding a count into PeriodNutritionSummary because the bulk action
/// needs each entry's id/foodName, not just a tally.
final periodEntriesMissingMacrosProvider = StreamProvider.family<List<FoodLogEntry>, ProgressPeriod>((ref, period) {
  final uid = ref.watch(currentUidProvider);
  final profile = ref.watch(userProfileProvider).valueOrNull;
  final (start, end) = _dateRangeForPeriod(period, profile);

  return FoodLogFirestoreDataSource(ref.watch(firestoreProvider), uid)
      .watchEntriesForRange(start, end)
      .map(
        (entries) => entries
            .where((e) => e.proteinPer100g == null && e.carbsPer100g == null && e.fatPer100g == null)
            .toList(growable: false),
      );
});
