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

/// [entries] must be oldest-first (as weightEntriesProvider already
/// provides). Anchors the "start" of the diet on the first entry logged
/// on or after [programStartDate] when one exists; falls back to
/// [onboardingWeightKg] (the profile's own starting weight) anchored at
/// [programStartDate] when no entry has been logged since the program
/// began yet; falls back further to the very first entry ever logged when
/// there's no program start date to anchor on at all (profile still
/// loading). Returns null only when there's no weight data whatsoever.
WeightEvolutionSummary? computeWeightEvolution({
  required List<WeightEntry> entries,
  DateTime? programStartDate,
  double? onboardingWeightKg,
}) {
  if (entries.isEmpty) return null;
  final latest = entries.last;

  if (programStartDate != null) {
    for (final entry in entries) {
      if (!entry.date.isBefore(programStartDate)) {
        return WeightEvolutionSummary(
          startWeightKg: entry.weightKg,
          latestWeightKg: latest.weightKg,
          startDate: entry.date,
          latestDate: latest.date,
        );
      }
    }
    if (onboardingWeightKg != null) {
      return WeightEvolutionSummary(
        startWeightKg: onboardingWeightKg,
        latestWeightKg: latest.weightKg,
        startDate: programStartDate,
        latestDate: latest.date,
      );
    }
  }

  final first = entries.first;
  return WeightEvolutionSummary(
    startWeightKg: first.weightKg,
    latestWeightKg: latest.weightKg,
    startDate: first.date,
    latestDate: latest.date,
  );
}
