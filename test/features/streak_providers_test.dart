import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/data/models/meal_type.dart';
import 'package:calorie_app/features/auth/auth_providers.dart';
import 'package:calorie_app/features/food_log/food_log_providers.dart';
import 'package:calorie_app/features/streaks/streak_providers.dart';

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
  // StreamProviders only subscribe once something listens; without this,
  // the later `container.read` calls below would race the stream's first
  // event instead of reliably observing it.
  container.listen(currentStreakProvider, (_, _) {});
  return container;
}

Future<void> _logDay(ProviderContainer container, DateTime date) {
  return container
      .read(dailyLogProvider(date).notifier)
      .addEntry(mealType: MealType.breakfast, foodName: 'Test', grams: 100, kcalPer100g: 200);
}

void main() {
  test('streak counts consecutive logged days ending today', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();

    final today = normalizeDate(DateTime.now());
    await _logDay(container, today);
    await _logDay(container, today.subtract(const Duration(days: 1)));
    await _logDay(container, today.subtract(const Duration(days: 2)));
    await pumpEventQueue();

    final streak = container.read(currentStreakProvider).valueOrNull;
    expect(streak, 3);
  });

  test('a gap stops the streak from reaching further back', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();

    final today = normalizeDate(DateTime.now());
    await _logDay(container, today);
    // Skip yesterday entirely.
    await _logDay(container, today.subtract(const Duration(days: 2)));
    await pumpEventQueue();

    final streak = container.read(currentStreakProvider).valueOrNull;
    expect(streak, 1);
  });

  test('not logging yet today does not zero out an active streak from yesterday', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();

    final today = normalizeDate(DateTime.now());
    await _logDay(container, today.subtract(const Duration(days: 1)));
    await _logDay(container, today.subtract(const Duration(days: 2)));
    await pumpEventQueue();

    final streak = container.read(currentStreakProvider).valueOrNull;
    expect(streak, 2);
  });

  test('no entries at all is a streak of zero', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();

    final streak = container.read(currentStreakProvider).valueOrNull;
    expect(streak, 0);
  });
}
