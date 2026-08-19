import '../../data/models/user_profile.dart';
import '../../data/models/weight_entry.dart';

/// The actual measured weight change over the diet, as opposed to the
/// deficit-projected estimate shown elsewhere (_PeriodStatsRow's "Scădere
/// estimată") — this is what a scale actually recorded, not a calorie-math
/// prediction.
class WeightEvolutionSummary {
  const WeightEvolutionSummary({
    required this.startWeightKg,
    required this.latestWeightKg,
    required this.startDate,
    required this.latestDate,
  });

  final double startWeightKg;
  final double latestWeightKg;
  final DateTime startDate;
  final DateTime latestDate;

  /// Negative = lost weight, positive = gained — same sign convention as
  /// a plain subtraction, deliberately not flipped like the deficit-based
  /// estimate elsewhere (that one reads "as a scale would"; this one *is*
  /// the scale, so it stays literal).
  double get differenceKg => latestWeightKg - startWeightKg;
}

/// [entries] must already be sorted oldest-first (as
/// [effectiveWeightEntries] and weightEntriesProvider both provide).
/// Returns null only when there's no weight data at all.
WeightEvolutionSummary? computeWeightEvolution(List<WeightEntry> entries) {
  if (entries.isEmpty) return null;
  return WeightEvolutionSummary(
    startWeightKg: entries.first.weightKg,
    latestWeightKg: entries.last.weightKg,
    startDate: entries.first.date,
    latestDate: entries.last.date,
  );
}

/// The onboarding weight *is*, conceptually, the diet's first weigh-in —
/// it just isn't stored as a real WeightEntry document (see
/// onboarding_screen.dart, which now seeds one for every *new* profile,
/// but profiles created before that existed have no such entry). This
/// treats it as a virtual entry dated at the program's start, so the
/// weight chart/analysis has a real starting point even for a user who
/// has logged only one real weigh-in since — but only until a real entry
/// exists at or before that date, since a genuine log is always more
/// trustworthy than the profile's possibly-stale weightKg field.
List<WeightEntry> effectiveWeightEntries(List<WeightEntry> entries, UserProfile? profile) {
  if (profile == null) return entries;
  final hasEntryAtOrBeforeStart = entries.any((e) => !e.date.isAfter(profile.programStartDate));
  if (hasEntryAtOrBeforeStart) return entries;

  final onboardingEntry = WeightEntry(
    id: '_onboarding',
    date: profile.programStartDate,
    weightKg: profile.weightKg,
    source: WeightSource.manual,
  );
  return [onboardingEntry, ...entries]..sort((a, b) => a.date.compareTo(b.date));
}
