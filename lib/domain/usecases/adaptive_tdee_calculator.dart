import '../../data/models/weight_entry.dart';
import 'tdee_calculator.dart';

class AdaptiveTdeeResult {
  const AdaptiveTdeeResult({
    required this.estimatedTdee,
    required this.weightTrendKgPerWeek,
    required this.loggedDays,
    required this.windowDays,
  });

  final double estimatedTdee;

  /// Positive = gaining, negative = losing, from a linear trend across
  /// the window's weigh-ins (not a raw first-vs-last delta, which is
  /// noisy — day-to-day weight swings ±1kg from water/food weight alone).
  final double weightTrendKgPerWeek;
  final int loggedDays;
  final int windowDays;
}

/// Derives an "effective" TDEE from the user's own recent energy balance
/// — actual logged intake vs. actual weight trend — the same idea
/// MacroFactor and similar adaptive trackers use, instead of relying
/// solely on the static Mifflin-St Jeor formula (which is a population
/// average, not a measurement of this specific person's metabolism).
///
/// Energy balance identity: totalIntake - TDEE*days = weightChangeKg *
/// kcalPerKgBodyFat, rearranged to solve for TDEE.
class AdaptiveTdeeCalculator {
  const AdaptiveTdeeCalculator({
    this.windowDays = 21,
    this.minLoggedDays = 14,
    this.minWeightSpanDays = 10,
  });

  final int windowDays;
  final int minLoggedDays;
  final int minWeightSpanDays;

  /// Returns null when there isn't enough recent history to trust an
  /// estimate — a sparse-data adaptive number would be noisier than just
  /// keeping the static formula, which defeats the point.
  AdaptiveTdeeResult? calculate({
    required List<WeightEntry> weightEntries,
    required Map<DateTime, double> dailyIntake,
    required DateTime asOf,
  }) {
    final windowStart = _normalize(asOf).subtract(Duration(days: windowDays - 1));

    final entriesInWindow = weightEntries.where((e) => _inRange(e.date, windowStart, asOf)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    if (entriesInWindow.length < 2) return null;

    final spanDays = _normalize(entriesInWindow.last.date).difference(_normalize(entriesInWindow.first.date)).inDays;
    if (spanDays < minWeightSpanDays) return null;

    final loggedDays = dailyIntake.entries
        .where((e) => e.value > 0 && _inRange(e.key, windowStart, asOf))
        .toList();
    if (loggedDays.length < minLoggedDays) return null;

    final avgDailyIntake = loggedDays.fold<double>(0, (sum, e) => sum + e.value) / loggedDays.length;
    final estimatedTotalIntake = avgDailyIntake * windowDays;

    final slopeKgPerDay = _weightTrendSlope(entriesInWindow);
    final weightChangeKg = slopeKgPerDay * windowDays;

    final estimatedTdee = (estimatedTotalIntake - weightChangeKg * kcalPerKgBodyFat) / windowDays;

    return AdaptiveTdeeResult(
      estimatedTdee: estimatedTdee,
      weightTrendKgPerWeek: slopeKgPerDay * 7,
      loggedDays: loggedDays.length,
      windowDays: windowDays,
    );
  }

  bool _inRange(DateTime date, DateTime start, DateTime end) {
    final normalized = _normalize(date);
    return !normalized.isBefore(start) && !normalized.isAfter(_normalize(end));
  }

  DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Least-squares slope of weight (kg) against days-since-first-entry —
  /// smooths across every weigh-in in the window rather than trusting
  /// just the first and last, which could each individually be an outlier.
  double _weightTrendSlope(List<WeightEntry> entries) {
    final x0 = _normalize(entries.first.date);
    final xs = entries.map((e) => _normalize(e.date).difference(x0).inDays.toDouble()).toList();
    final ys = entries.map((e) => e.weightKg).toList();
    final n = entries.length;

    final sumX = xs.fold<double>(0, (s, x) => s + x);
    final sumY = ys.fold<double>(0, (s, y) => s + y);
    var sumXY = 0.0, sumXX = 0.0;
    for (var i = 0; i < n; i++) {
      sumXY += xs[i] * ys[i];
      sumXX += xs[i] * xs[i];
    }

    final denominator = n * sumXX - sumX * sumX;
    if (denominator == 0) return 0;
    return (n * sumXY - sumX * sumY) / denominator;
  }
}
