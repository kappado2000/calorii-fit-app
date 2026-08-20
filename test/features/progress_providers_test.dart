import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/core/constants/micronutrient_reference.dart';
import 'package:calorie_app/data/models/meal_type.dart';
import 'package:calorie_app/data/models/user_profile.dart';
import 'package:calorie_app/features/auth/auth_providers.dart';
import 'package:calorie_app/features/food_log/food_log_providers.dart';
import 'package:calorie_app/features/profile/profile_providers.dart';
import 'package:calorie_app/features/progress/progress_providers.dart';

ProviderContainer _buildContainer() {
  final mockAuth = MockFirebaseAuth(mockUser: MockUser(uid: 'test-uid', email: 't@e.com'), signedIn: true);
  final fakeFirestore = FakeFirebaseFirestore();

  return ProviderContainer(
    overrides: [
      firebaseAuthProvider.overrideWithValue(mockAuth),
      firestoreProvider.overrideWithValue(fakeFirestore),
    ],
  );
}

DateTime _daysAgo(int days) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day).subtract(Duration(days: days));
}

void main() {
  test('dailyCalorieHistoryProvider(last7Days) includes today, excludes 10 days ago', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    container.listen(dailyCalorieHistoryProvider(ProgressPeriod.last7Days), (_, _) {});
    await pumpEventQueue();

    await container
        .read(dailyLogProvider(_daysAgo(0)).notifier)
        .addEntry(mealType: MealType.lunch, foodName: 'Today food', grams: 100, kcalPer100g: 200);
    await container
        .read(dailyLogProvider(_daysAgo(10)).notifier)
        .addEntry(mealType: MealType.lunch, foodName: 'Old food', grams: 100, kcalPer100g: 500);
    await pumpEventQueue();

    final history = container.read(dailyCalorieHistoryProvider(ProgressPeriod.last7Days)).valueOrNull ?? {};
    expect(history[_daysAgo(0)], 200);
    expect(history.containsKey(_daysAgo(10)), isFalse);
  });

  test('periodNutritionSummaryProvider sums macros and tracks partial micronutrient coverage', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    container.listen(periodNutritionSummaryProvider(ProgressPeriod.last7Days), (_, _) {});
    await pumpEventQueue();

    await container
        .read(dailyLogProvider(_daysAgo(0)).notifier)
        .addEntry(
          mealType: MealType.breakfast,
          foodName: 'With micronutrients',
          grams: 100,
          kcalPer100g: 150,
          proteinPer100g: 10,
          carbsPer100g: 20,
          fatPer100g: 5,
          micronutrients: const MicronutrientProfile(vitaminCMg: 30),
        );
    await container
        .read(dailyLogProvider(_daysAgo(1)).notifier)
        .addEntry(
          mealType: MealType.dinner,
          foodName: 'No micronutrient data',
          grams: 100,
          kcalPer100g: 250,
          proteinPer100g: 15,
        );
    await pumpEventQueue();

    final summary = container.read(periodNutritionSummaryProvider(ProgressPeriod.last7Days)).valueOrNull;
    expect(summary, isNotNull);
    expect(summary!.totalCalories, 400);
    expect(summary.totalProtein, 25);
    expect(summary.totalEntries, 2);
    expect(summary.entriesWithMicronutrientData, 1);
    expect(summary.micronutrientTotals[Micronutrient.vitaminC], 30);
  });

  test('sinceProgramStart uses the profile programStartDate as the window start', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    container.listen(dailyCalorieHistoryProvider(ProgressPeriod.sinceProgramStart), (_, _) {});
    container.listen(userProfileProvider, (_, _) {});
    await pumpEventQueue();

    await container
        .read(profileControllerProvider)
        .saveProfile(
          UserProfile(
            heightCm: 170,
            weightKg: 70,
            age: 30,
            sex: Sex.female,
            activityLevel: ActivityLevel.moderate,
            goal: Goal.lose,
            targetRateKgPerWeek: 0.5,
            programStartDate: _daysAgo(60),
          ),
        );
    await container
        .read(dailyLogProvider(_daysAgo(45)).notifier)
        .addEntry(mealType: MealType.lunch, foodName: 'Within program', grams: 100, kcalPer100g: 300);
    await pumpEventQueue();

    final history = container.read(dailyCalorieHistoryProvider(ProgressPeriod.sinceProgramStart)).valueOrNull ?? {};
    expect(history[_daysAgo(45)], 300);
  });
}
