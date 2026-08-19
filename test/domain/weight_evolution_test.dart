import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/data/models/weight_entry.dart';
import 'package:calorie_app/domain/usecases/weight_evolution.dart';

WeightEntry _entry(String id, DateTime date, double kg) =>
    WeightEntry(id: id, date: date, weightKg: kg, source: WeightSource.manual);

void main() {
  test('returns null with no weight entries at all', () {
    final result = computeWeightEvolution(entries: const [], programStartDate: DateTime(2026, 1, 1));
    expect(result, isNull);
  });

  test('anchors on the first entry logged on/after the program start date', () {
    final entries = [
      _entry('a', DateTime(2025, 12, 20), 90), // before the diet started — shouldn't count
      _entry('b', DateTime(2026, 1, 5), 85),
      _entry('c', DateTime(2026, 1, 20), 80),
    ];
    final result = computeWeightEvolution(entries: entries, programStartDate: DateTime(2026, 1, 1));

    expect(result!.startWeightKg, 85);
    expect(result.latestWeightKg, 80);
    expect(result.differenceKg, -5);
  });

  test('falls back to the onboarding weight when nothing has been logged since the program started', () {
    final entries = [_entry('a', DateTime(2025, 12, 20), 90)];
    final result = computeWeightEvolution(
      entries: entries,
      programStartDate: DateTime(2026, 1, 1),
      onboardingWeightKg: 88,
    );

    expect(result!.startWeightKg, 88);
    expect(result.startDate, DateTime(2026, 1, 1));
    expect(result.latestWeightKg, 90);
    expect(result.differenceKg, 2);
  });

  test('falls back to the very first entry when there is no program start date', () {
    final entries = [_entry('a', DateTime(2026, 1, 1), 90), _entry('b', DateTime(2026, 1, 15), 87)];
    final result = computeWeightEvolution(entries: entries);

    expect(result!.startWeightKg, 90);
    expect(result.latestWeightKg, 87);
    expect(result.differenceKg, -3);
  });

  test('a single entry compares against itself, giving zero difference', () {
    final entries = [_entry('a', DateTime(2026, 1, 1), 90)];
    final result = computeWeightEvolution(entries: entries, programStartDate: DateTime(2026, 1, 1));

    expect(result!.differenceKg, 0);
  });
}
