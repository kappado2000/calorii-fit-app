import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/features/auth/auth_providers.dart';
import 'package:calorie_app/features/food_log/food_log_providers.dart';
import 'package:calorie_app/features/hydration/hydration_providers.dart';

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
  test('addGlass accumulates into the daily total', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();
    final date = DateTime(2026, 4, 1);
    final notifier = container.read(hydrationLogProvider(date).notifier);

    await notifier.addGlass();
    await notifier.addGlass();
    await pumpEventQueue();

    expect(container.read(hydrationLogProvider(date)), hasLength(2));
    expect(container.read(dailyHydrationTotalProvider(date)), closeTo(2 * hydrationGlassMl, 0.01));
  });

  test('removeLastGlass undoes exactly one tap, not the whole day', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();
    final date = DateTime(2026, 4, 2);
    final notifier = container.read(hydrationLogProvider(date).notifier);

    await notifier.addGlass();
    await notifier.addGlass();
    await notifier.addGlass();
    await pumpEventQueue();
    await notifier.removeLastGlass();
    await pumpEventQueue();

    expect(container.read(hydrationLogProvider(date)), hasLength(2));
    expect(container.read(dailyHydrationTotalProvider(date)), closeTo(2 * hydrationGlassMl, 0.01));
  });

  test('removeLastGlass on an empty day is a no-op, not an error', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();
    final date = DateTime(2026, 4, 3);
    final notifier = container.read(hydrationLogProvider(date).notifier);

    await notifier.removeLastGlass();
    await pumpEventQueue();

    expect(container.read(hydrationLogProvider(date)), isEmpty);
  });

  test('totals are isolated per day', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();
    final day1 = DateTime(2026, 4, 4);
    final day2 = DateTime(2026, 4, 5);

    await container.read(hydrationLogProvider(day1).notifier).addGlass();
    await pumpEventQueue();

    expect(container.read(dailyHydrationTotalProvider(day1)), closeTo(hydrationGlassMl, 0.01));
    expect(container.read(dailyHydrationTotalProvider(day2)), 0);
  });
}
