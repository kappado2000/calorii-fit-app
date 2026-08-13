import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/data/models/meal_type.dart';
import 'package:calorie_app/features/auth/auth_providers.dart';
import 'package:calorie_app/features/food_log/food_log_providers.dart';

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
  test('rememberProduct adds a new product, then updates it in place on re-save', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue(); // let authStateChangesProvider emit before reading _uidProvider
    final notifier = container.read(customFoodsProvider.notifier);

    await notifier.rememberProduct(name: 'Iaurt grecesc', kcalPer100g: 120);
    await pumpEventQueue();
    expect(container.read(customFoodsProvider), hasLength(1));
    expect(container.read(customFoodsProvider).first.kcalPer100g, 120);

    // Same name (case-insensitive) should update, not duplicate.
    await notifier.rememberProduct(name: 'iaurt grecesc', kcalPer100g: 130);
    await pumpEventQueue();
    final foods = container.read(customFoodsProvider);
    expect(foods, hasLength(1));
    expect(foods.first.kcalPer100g, 130);
  });

  test('rememberProduct persists across a fresh provider read (same backing store)', () async {
    final mockUser = MockUser(uid: 'test-uid', email: 'test@example.com');
    final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
    final fakeFirestore = FakeFirebaseFirestore();
    final overrides = [
      firebaseAuthProvider.overrideWithValue(mockAuth),
      firestoreProvider.overrideWithValue(fakeFirestore),
    ];

    final container1 = ProviderContainer(overrides: overrides);
    await pumpEventQueue();
    await container1.read(customFoodsProvider.notifier).rememberProduct(name: 'Orez', kcalPer100g: 130);
    await pumpEventQueue();
    container1.dispose();

    final container2 = ProviderContainer(overrides: overrides);
    addTearDown(container2.dispose);
    await pumpEventQueue();
    container2.read(customFoodsProvider.notifier);
    await pumpEventQueue();
    final foods = container2.read(customFoodsProvider);
    expect(foods.any((food) => food.name == 'Orez'), isTrue);
  });

  test('dailyLogProvider addEntry/removeEntry updates state and computed calories', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();
    final date = DateTime(2026, 1, 15);
    final notifier = container.read(dailyLogProvider(date).notifier);

    await notifier.addEntry(
      mealType: MealType.breakfast,
      foodName: 'Ou fiert',
      grams: 50,
      kcalPer100g: 150,
    );
    await pumpEventQueue();

    final entries = container.read(dailyLogProvider(date));
    expect(entries, hasLength(1));
    expect(entries.first.calories, closeTo(75, 0.001)); // 50g * 150kcal/100g

    await notifier.removeEntry(entries.first.id);
    await pumpEventQueue();
    expect(container.read(dailyLogProvider(date)), isEmpty);
  });

  test('dailyLogProvider only returns entries for the requested date', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();
    final day1 = DateTime(2026, 2, 1);
    final day2 = DateTime(2026, 2, 2);

    await container
        .read(dailyLogProvider(day1).notifier)
        .addEntry(mealType: MealType.lunch, foodName: 'Supă', grams: 300, kcalPer100g: 40);
    await container
        .read(dailyLogProvider(day2).notifier)
        .addEntry(mealType: MealType.dinner, foodName: 'Pește', grams: 150, kcalPer100g: 180);
    await pumpEventQueue();

    expect(container.read(dailyLogProvider(day1)), hasLength(1));
    expect(container.read(dailyLogProvider(day1)).first.foodName, 'Supă');
    expect(container.read(dailyLogProvider(day2)), hasLength(1));
    expect(container.read(dailyLogProvider(day2)).first.foodName, 'Pește');
  });

  test('normalizeDate strips the time-of-day component', () {
    final withTime = DateTime(2026, 3, 4, 18, 30);
    expect(normalizeDate(withTime), DateTime(2026, 3, 4));
  });
}
