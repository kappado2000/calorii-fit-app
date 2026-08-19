import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/domain/usecases/met_calorie_estimator.dart';
import 'package:calorie_app/features/auth/auth_providers.dart';
import 'package:calorie_app/features/food_log/food_log_providers.dart';
import 'package:calorie_app/features/workout_log/workout_log_providers.dart';

ProviderContainer _buildContainer() {
  final mockUser = MockUser(uid: 'test-uid', email: 'test@example.com');
  final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
  final fakeFirestore = FakeFirebaseFirestore();

  return ProviderContainer(
    overrides: [
      firebaseAuthProvider.overrideWithValue(mockAuth),
      firestoreProvider.overrideWithValue(fakeFirestore),
    ],
  );
}

void main() {
  test('addWorkout computes calories via MET formula and persists the entry', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();
    final date = DateTime(2026, 4, 1);
    final notifier = container.read(workoutLogProvider(date).notifier);

    await notifier.addWorkout(
      activityType: ActivityType.running,
      duration: const Duration(minutes: 30),
      weightKg: 70,
    );
    await pumpEventQueue();

    final entries = container.read(workoutLogProvider(date));
    expect(entries, hasLength(1));
    // 7.0 MET * 70kg * 0.5h = 245
    expect(entries.first.caloriesBurned, closeTo(245, 0.01));
    expect(entries.first.activityType, ActivityType.running);
  });

  test('addManualWorkout stores the given calories directly, bypassing the MET formula', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();
    final date = DateTime(2026, 4, 3);
    final notifier = container.read(workoutLogProvider(date).notifier);

    await notifier.addManualWorkout(caloriesBurned: 180);
    await pumpEventQueue();

    final entry = container.read(workoutLogProvider(date)).single;
    expect(entry.caloriesBurned, 180);
    expect(entry.duration, Duration.zero);
    expect(entry.activityType, ActivityType.other);
  });

  test('removeWorkout deletes the entry', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();
    final date = DateTime(2026, 4, 2);
    final notifier = container.read(workoutLogProvider(date).notifier);

    await notifier.addWorkout(
      activityType: ActivityType.yoga,
      duration: const Duration(minutes: 45),
      weightKg: 65,
    );
    await pumpEventQueue();
    final id = container.read(workoutLogProvider(date)).first.id;

    await notifier.removeWorkout(id);
    await pumpEventQueue();

    expect(container.read(workoutLogProvider(date)), isEmpty);
  });
}
