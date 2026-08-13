import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/data/models/user_profile.dart';
import 'package:calorie_app/domain/usecases/tdee_calculator.dart';

UserProfile _profile({
  required double heightCm,
  required double weightKg,
  required int age,
  required Sex sex,
  required ActivityLevel activityLevel,
  required Goal goal,
  double targetRateKgPerWeek = 0,
}) {
  return UserProfile(
    heightCm: heightCm,
    weightKg: weightKg,
    age: age,
    sex: sex,
    activityLevel: activityLevel,
    goal: goal,
    targetRateKgPerWeek: targetRateKgPerWeek,
    programStartDate: DateTime(2026, 1, 1),
  );
}

void main() {
  const calculator = TdeeCalculator();

  test('computes BMR/TDEE/target for a male with a moderate weight-loss goal', () {
    final profile = _profile(
      heightCm: 180,
      weightKg: 80,
      age: 30,
      sex: Sex.male,
      activityLevel: ActivityLevel.moderate,
      goal: Goal.lose,
      targetRateKgPerWeek: 0.5,
    );

    final result = calculator.calculate(profile);

    // BMR = 10*80 + 6.25*180 - 5*30 + 5 = 1780
    expect(result.bmr, closeTo(1780, 0.01));
    // TDEE = 1780 * 1.55
    expect(result.tdee, closeTo(2759, 0.01));
    // Daily delta = 0.5 * 7700 / 7 = 550
    expect(result.calorieTarget, closeTo(2209, 0.01));
    expect(result.dailyDeficit, closeTo(550, 0.01));
  });

  test('maintain goal targets TDEE exactly, zero deficit', () {
    final profile = _profile(
      heightCm: 165,
      weightKg: 60,
      age: 25,
      sex: Sex.female,
      activityLevel: ActivityLevel.sedentary,
      goal: Goal.maintain,
    );

    final result = calculator.calculate(profile);

    // BMR = 10*60 + 6.25*165 - 5*25 - 161 = 1345.25
    expect(result.bmr, closeTo(1345.25, 0.01));
    expect(result.calorieTarget, closeTo(result.tdee, 0.001));
    expect(result.dailyDeficit, closeTo(0, 0.001));
  });

  test('gain goal produces a calorie surplus (negative deficit)', () {
    final profile = _profile(
      heightCm: 175,
      weightKg: 70,
      age: 28,
      sex: Sex.male,
      activityLevel: ActivityLevel.active,
      goal: Goal.gain,
      targetRateKgPerWeek: 0.25,
    );

    final result = calculator.calculate(profile);

    expect(result.calorieTarget, greaterThan(result.tdee));
    expect(result.dailyDeficit, lessThan(0));
  });

  test('an aggressive loss rate is clamped to the safety floor, not below it', () {
    final profile = _profile(
      heightCm: 150,
      weightKg: 50,
      age: 20,
      sex: Sex.female,
      activityLevel: ActivityLevel.sedentary,
      goal: Goal.lose,
      targetRateKgPerWeek: 2.0, // unrealistically aggressive on purpose
    );

    final result = calculator.calculate(profile);

    // Raw math would go well below the female safety floor of 1200 kcal —
    // the calculator must clamp instead of returning an unsafe number.
    expect(result.calorieTarget, 1200);
  });

  test('male safety floor is 1500 kcal, distinct from the female floor', () {
    final profile = _profile(
      heightCm: 160,
      weightKg: 55,
      age: 22,
      sex: Sex.male,
      activityLevel: ActivityLevel.sedentary,
      goal: Goal.lose,
      targetRateKgPerWeek: 2.0,
    );

    final result = calculator.calculate(profile);

    expect(result.calorieTarget, 1500);
  });
}
