import 'dart:convert';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:calorie_app/data/datasources/remote/cloud_functions/search_foods_api_client.dart';
import 'package:calorie_app/data/models/custom_food.dart';
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

  test('rememberProduct with a mealType bumps that meal\'s use count', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();
    final notifier = container.read(customFoodsProvider.notifier);

    await notifier.rememberProduct(name: 'Ovăz', kcalPer100g: 380, mealType: MealType.breakfast);
    await pumpEventQueue();
    var food = container.read(customFoodsProvider).first;
    expect(food.mealTypeUseCounts[MealType.breakfast.name], 1);
    expect(food.mealTypeUseCounts[MealType.dinner.name], isNull);

    // Logged again for breakfast, then once for dinner too (e.g. a leftover
    // bowl) — each meal's own count moves independently.
    await notifier.rememberProduct(name: 'Ovăz', kcalPer100g: 380, mealType: MealType.breakfast);
    await notifier.rememberProduct(name: 'Ovăz', kcalPer100g: 380, mealType: MealType.dinner);
    await pumpEventQueue();
    food = container.read(customFoodsProvider).first;
    expect(food.mealTypeUseCounts[MealType.breakfast.name], 2);
    expect(food.mealTypeUseCounts[MealType.dinner.name], 1);
  });

  test('incrementMealTypeUsage bumps an existing food\'s count without touching its other fields', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();
    final notifier = container.read(customFoodsProvider.notifier);

    final saved = await notifier.rememberProduct(name: 'Banană', kcalPer100g: 89, gramsUsed: 120);
    await pumpEventQueue();

    await notifier.incrementMealTypeUsage(saved.id, MealType.snack);
    await notifier.incrementMealTypeUsage(saved.id, MealType.snack);
    await pumpEventQueue();

    final food = container.read(customFoodsProvider).first;
    expect(food.mealTypeUseCounts[MealType.snack.name], 2);
    expect(food.lastGramsUsed, 120); // untouched
    expect(food.kcalPer100g, 89); // untouched
  });

  test('foodsRankedForMeal sorts by that meal\'s own use count, without hiding zero-count foods', () {
    const foods = [
      CustomFood(id: '1', name: 'A', kcalPer100g: 100, mealTypeUseCounts: {'breakfast': 1, 'dinner': 5}),
      CustomFood(id: '2', name: 'B', kcalPer100g: 100, mealTypeUseCounts: {'breakfast': 3}),
      CustomFood(id: '3', name: 'C', kcalPer100g: 100), // never logged for any meal
    ];

    final forBreakfast = foodsRankedForMeal(foods, MealType.breakfast);
    expect(forBreakfast.map((f) => f.id), ['2', '1', '3']); // 3 > 1 > 0(unset)

    final forDinner = foodsRankedForMeal(foods, MealType.dinner);
    expect(forDinner.first.id, '1'); // the only one with a dinner count wins the top spot
    expect(forDinner.map((f) => f.id).toSet(), {'1', '2', '3'}); // nothing dropped
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

  test('updateGrams corrects the portion of an existing entry, keeping its per-100g values', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();
    final date = DateTime(2026, 1, 20);
    final notifier = container.read(dailyLogProvider(date).notifier);

    await notifier.addEntry(
      mealType: MealType.dinner,
      foodName: 'Piept de pui la grătar',
      grams: 100,
      kcalPer100g: 165,
      proteinPer100g: 31,
      fatPer100g: 3.6,
    );
    await pumpEventQueue();
    final original = container.read(dailyLogProvider(date)).single;
    expect(original.calories, closeTo(165, 0.001));

    await notifier.updateGrams(original, 250);
    await pumpEventQueue();

    final updated = container.read(dailyLogProvider(date)).single;
    expect(updated.id, original.id); // same entry, corrected in place, not duplicated
    expect(container.read(dailyLogProvider(date)), hasLength(1));
    expect(updated.grams, 250);
    expect(updated.foodName, 'Piept de pui la grătar');
    expect(updated.kcalPer100g, 165); // per-100g values untouched
    expect(updated.calories, closeTo(412.5, 0.001));
    expect(updated.protein, closeTo(77.5, 0.001));
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

  test('addEntry persists macro fields and DailyLogNotifier round-trips them', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await pumpEventQueue();
    final date = DateTime(2026, 4, 1);
    final notifier = container.read(dailyLogProvider(date).notifier);

    await notifier.addEntry(
      mealType: MealType.dinner,
      foodName: 'Piept de pui',
      grams: 150,
      kcalPer100g: 165,
      proteinPer100g: 31,
      carbsPer100g: 0,
      fatPer100g: 3.6,
    );
    await pumpEventQueue();

    final entry = container.read(dailyLogProvider(date)).single;
    expect(entry.protein, closeTo(46.5, 0.001));
    expect(entry.carbs, 0);
    expect(entry.fat, closeTo(5.4, 0.001));
  });

  group('FoodSearchNotifier', () {
    test('shows remembered-product matches immediately, then merges remote results', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'result': {
              'products': [
                {
                  'barcode': '123',
                  'name': 'Iaurt grecesc Zuzu',
                  'brand': null,
                  'kcalPer100g': 97,
                  'proteinPer100g': 9.0,
                  'carbsPer100g': 4.0,
                  'fatPer100g': 5.0,
                  'imageUrl': null,
                },
              ],
            },
          }),
          200,
        );
      });
      final apiClient = SearchFoodsApiClient(httpClient: mockClient);
      addTearDown(apiClient.dispose);
      const remembered = CustomFood(id: '1', name: 'Iaurt grecesc', kcalPer100g: 120);
      final notifier = FoodSearchNotifier(apiClient, [remembered]);
      addTearDown(notifier.dispose);

      notifier.search('iaurt');
      expect(notifier.state.results, hasLength(1));
      expect(notifier.state.results.first.name, 'Iaurt grecesc');
      expect(notifier.state.isSearchingRemote, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 500));
      expect(notifier.state.results, hasLength(2));
      expect(notifier.state.results.last.name, 'Iaurt grecesc Zuzu');
      expect(notifier.state.isSearchingRemote, isFalse);
    });

    test('a query under 2 characters clears results without calling the API', () {
      final apiClient = SearchFoodsApiClient(
        httpClient: MockClient((request) async => fail('should not be called')),
      );
      addTearDown(apiClient.dispose);
      final notifier = FoodSearchNotifier(apiClient, const []);
      addTearDown(notifier.dispose);

      notifier.search('a');
      expect(notifier.state.results, isEmpty);
    });

    test('keeps remembered matches visible and flags the error on a failed remote search', () async {
      final apiClient = SearchFoodsApiClient(
        httpClient: MockClient((request) async => http.Response('boom', 500)),
      );
      addTearDown(apiClient.dispose);
      const remembered = CustomFood(id: '1', name: 'Orez brun', kcalPer100g: 111);
      final notifier = FoodSearchNotifier(apiClient, [remembered]);
      addTearDown(notifier.dispose);

      notifier.search('orez');
      await Future<void>.delayed(const Duration(milliseconds: 500));

      expect(notifier.state.results, hasLength(1));
      expect(notifier.state.results.first.name, 'Orez brun');
      expect(notifier.state.hadRemoteError, isTrue);
    });
  });
}
