import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/data/models/user_profile.dart';
import 'package:calorie_app/data/models/weight_entry.dart';
import 'package:calorie_app/domain/usecases/weight_evolution.dart';

WeightEntry _entry(String id, DateTime date, double kg) =>
    WeightEntry(id: id, date: date, weightKg: kg, source: WeightSource.manual);

UserProfile _profile({required double weightKg, required DateTime programStartDate}) => UserProfile(
  heightCm: 165,
  weightKg: weightKg,
  age: 30,
  sex: Sex.female,
  activityLevel: ActivityLevel.sedentary,
  goal: Goal.lose,
  targetRateKgPerWeek: 0.5,
  programStartDate: programStartDate,
);

void main() {
  group('computeWeightEvolution', () {
    test('returns null with no entries', () {
      expect(computeWeightEvolution(const []), isNull);
    });

    test('compares the first entry against the last', () {
      final entries = [
        _entry('a', DateTime(2026, 1, 5), 90),
        _entry('b', DateTime(2026, 1, 12), 87),
        _entry('c', DateTime(2026, 1, 20), 85),
      ];
      final result = computeWeightEvolution(entries);

      expect(result!.startWeightKg, 90);
      expect(result.latestWeightKg, 85);
      expect(result.differenceKg, -5);
    });

    test('a single entry compares against itself, giving zero difference', () {
      final result = computeWeightEvolution([_entry('a', DateTime(2026, 1, 1), 90)]);
      expect(result!.differenceKg, 0);
    });
  });

  group('effectiveWeightEntries', () {
    test('prepends the onboarding weight as a virtual entry when nothing was logged before program start', () {
      final profile = _profile(weightKg: 102.5, programStartDate: DateTime(2026, 1, 1));
      final entries = [_entry('a', DateTime(2026, 1, 10), 101.5)];

      final result = effectiveWeightEntries(entries, profile);

      expect(result, hasLength(2));
      expect(result.first.weightKg, 102.5);
      expect(result.first.date, DateTime(2026, 1, 1));
      expect(result.last.weightKg, 101.5);
    });

    test('does not add a virtual entry when a real one already covers the program start', () {
      final profile = _profile(weightKg: 102.5, programStartDate: DateTime(2026, 1, 1));
      final entries = [
        _entry('a', DateTime(2026, 1, 1), 102.0),
        _entry('b', DateTime(2026, 1, 10), 101.5),
      ];

      final result = effectiveWeightEntries(entries, profile);

      expect(result, hasLength(2));
      expect(result.first.weightKg, 102.0);
    });

    test('returns the entries unchanged when there is no profile yet', () {
      final entries = [_entry('a', DateTime(2026, 1, 10), 101.5)];
      expect(effectiveWeightEntries(entries, null), same(entries));
    });

    test('an empty entry list still gets the virtual onboarding entry', () {
      final profile = _profile(weightKg: 102.5, programStartDate: DateTime(2026, 1, 1));
      final result = effectiveWeightEntries(const [], profile);

      expect(result, hasLength(1));
      expect(result.single.weightKg, 102.5);
    });
  });
}
