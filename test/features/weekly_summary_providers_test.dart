import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/data/models/meal_type.dart';
import 'package:calorie_app/features/auth/auth_providers.dart';
import 'package:calorie_app/features/food_log/food_log_providers.dart';
import 'package:calorie_app/features/progress/weekly_summary_providers.dart';

ProviderContainer _buildContainer() {
  final mockUser = MockUser(uid: 'test-uid', email: 'test@example.com');
  final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
  final fakeFirestore = FakeFirebaseFirestore();

  final container = ProviderContainer(
    overrides: [
      firebaseAuthProvider.overrideWithValue(mockAuth),
      firestoreProvider.overrideWithValue(fakeFirestore),
    ],
  );
  container.listen(weeklySummaryProvider, (_, _) {});
  return container;
}

Future<void> _logDay(ProviderContainer container, DateTime date, double kcalPer100g) {
  return container
      .read(dailyLogProvider(date).notifier)
      .addEntry(mealType: MealType.breakfast, foodName: 'Test', grams: 100, kcalPer100g: kcalPer100g);
}

void main() {
  test('averages this week separately from the week before', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();

    final today = normalizeDate(DateTime.now());
    // This week: 2000 kcal on 2 of the last 7 days.
    await _logDay(container, today, 2000);
    await _logDay(container, today.subtract(const Duration(days: 1)), 2000);
    // Last week: 1000 kcal on 1 of the 7 days before that.
    await _logDay(container, today.subtract(const Duration(days: 8)), 1000);
    await pumpEventQueue();

    final summary = container.read(weeklySummaryProvider).valueOrNull!;
    expect(summary.thisWeekDaysLogged, 2);
    expect(summary.thisWeekAvgCalories, closeTo(2000, 0.01));
    expect(summary.lastWeekAvgCalories, closeTo(1000, 0.01));
    expect(summary.avgCaloriesDelta, closeTo(1000, 0.01));
  });

  test('an empty week reports zero averages instead of dividing by zero', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();

    final summary = container.read(weeklySummaryProvider).valueOrNull!;
    expect(summary.thisWeekDaysLogged, 0);
    expect(summary.thisWeekAvgCalories, 0);
    expect(summary.lastWeekAvgCalories, 0);
  });
}
