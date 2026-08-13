import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/domain/usecases/met_calorie_estimator.dart';

void main() {
  const estimator = MetCalorieEstimator();

  test('running for 30 minutes at 70kg burns MET x weight x hours', () {
    final calories = estimator.estimateCalories(
      activityType: ActivityType.running,
      weightKg: 70,
      duration: const Duration(minutes: 30),
    );
    // 7.0 MET * 70kg * 0.5h = 245
    expect(calories, closeTo(245, 0.01));
  });

  test('casual walking for 60 minutes at 80kg', () {
    final calories = estimator.estimateCalories(
      activityType: ActivityType.walkingCasual,
      weightKg: 80,
      duration: const Duration(hours: 1),
    );
    // 3.0 MET * 80kg * 1h = 240
    expect(calories, closeTo(240, 0.01));
  });

  test('zero duration burns zero calories', () {
    final calories = estimator.estimateCalories(
      activityType: ActivityType.cycling,
      weightKg: 70,
      duration: Duration.zero,
    );
    expect(calories, 0);
  });

  test('more intense activity types have a higher MET value', () {
    expect(estimator.metValueFor(ActivityType.runningFast), greaterThan(estimator.metValueFor(ActivityType.walkingCasual)));
  });
}
