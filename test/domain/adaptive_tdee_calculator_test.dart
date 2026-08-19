import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/data/models/weight_entry.dart';
import 'package:calorie_app/domain/usecases/adaptive_tdee_calculator.dart';
import 'package:calorie_app/domain/usecases/tdee_calculator.dart';

void main() {
  const calculator = AdaptiveTdeeCalculator();
  final today = DateTime(2026, 3, 21);

  Map<DateTime, double> intakeForDays(int count, double kcal, {DateTime? end}) {
    final base = end ?? today;
    return {for (var i = 0; i < count; i++) base.subtract(Duration(days: i)): kcal};
  }

  List<WeightEntry> weighIns(List<(int daysAgo, double kg)> points) {
    return [
      for (final (daysAgo, kg) in points)
        WeightEntry(id: 'w$daysAgo', date: today.subtract(Duration(days: daysAgo)), weightKg: kg, source: WeightSource.manual),
    ];
  }

  test('returns null with fewer than 2 weigh-ins', () {
    final result = calculator.calculate(
      weightEntries: weighIns([(0, 80)]),
      dailyIntake: intakeForDays(14, 2000),
      asOf: today,
    );
    expect(result, isNull);
  });

  test('returns null when weigh-ins are too close together to show a real trend', () {
    final result = calculator.calculate(
      weightEntries: weighIns([(5, 80), (0, 79.8)]),
      dailyIntake: intakeForDays(14, 2000),
      asOf: today,
    );
    expect(result, isNull);
  });

  test('returns null with too few logged days even with a good weight trend', () {
    final result = calculator.calculate(
      weightEntries: weighIns([(20, 82), (0, 80)]),
      dailyIntake: intakeForDays(5, 2000),
      asOf: today,
    );
    expect(result, isNull);
  });

  test('a maintaining weight at a known intake implies TDEE roughly equals that intake', () {
    // Flat weight over 3 weeks at 2200 kcal/day, logged every day -> the
    // person's TDEE is ~2200 (no surplus or deficit to explain).
    final result = calculator.calculate(
      weightEntries: weighIns([(20, 75.0), (10, 75.0), (0, 75.0)]),
      dailyIntake: intakeForDays(21, 2200),
      asOf: today,
    );
    expect(result, isNotNull);
    expect(result!.estimatedTdee, closeTo(2200, 1));
    expect(result.weightTrendKgPerWeek, closeTo(0, 0.01));
  });

  test('losing weight at a known intake implies a higher TDEE than the intake', () {
    // Lost 1.4kg over the 20-day span between the two weigh-ins, at 1800
    // kcal/day -> the deficit implied by the weight loss (extrapolated
    // from the daily slope across the full 21-day window) means TDEE was
    // above 1800.
    final result = calculator.calculate(
      weightEntries: weighIns([(20, 81.4), (0, 80.0)]),
      dailyIntake: intakeForDays(21, 1800),
      asOf: today,
    );
    expect(result, isNotNull);
    final slopeKgPerDay = (80.0 - 81.4) / 20;
    final weightChangeKg = slopeKgPerDay * 21;
    final expectedTdee = 1800 - (weightChangeKg * kcalPerKgBodyFat / 21);
    expect(result!.estimatedTdee, closeTo(expectedTdee, 1));
    expect(result.weightTrendKgPerWeek, lessThan(0));
  });

  test('gaining weight at a known intake implies a lower TDEE than the intake', () {
    final result = calculator.calculate(
      weightEntries: weighIns([(20, 78.0), (0, 79.4)]),
      dailyIntake: intakeForDays(21, 2800),
      asOf: today,
    );
    expect(result, isNotNull);
    expect(result!.estimatedTdee, lessThan(2800));
    expect(result.weightTrendKgPerWeek, greaterThan(0));
  });

  test('only counts days actually within the lookback window', () {
    // 14 recent logged days (enough) plus a bunch of ancient ones that
    // shouldn't count toward the 21-day window's average.
    final recent = intakeForDays(14, 2000);
    final ancient = intakeForDays(10, 5000, end: today.subtract(const Duration(days: 100)));
    final result = calculator.calculate(
      weightEntries: weighIns([(20, 75.0), (0, 75.0)]),
      dailyIntake: {...recent, ...ancient},
      asOf: today,
    );
    expect(result, isNotNull);
    expect(result!.loggedDays, 14);
    expect(result.estimatedTdee, closeTo(2000, 1));
  });
}
