import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:calorie_app/data/models/meal_type.dart';
import 'package:calorie_app/features/food_log/food_log_providers.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('rememberProduct adds a new product, then updates it in place on re-save', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(customFoodsProvider.notifier);

    await notifier.rememberProduct(name: 'Iaurt grecesc', kcalPer100g: 120);
    expect(container.read(customFoodsProvider), hasLength(1));
    expect(container.read(customFoodsProvider).first.kcalPer100g, 120);

    // Same name (case-insensitive) should update, not duplicate.
    await notifier.rememberProduct(name: 'iaurt grecesc', kcalPer100g: 130);
    final foods = container.read(customFoodsProvider);
    expect(foods, hasLength(1));
    expect(foods.first.kcalPer100g, 130);
  });

  test('rememberProduct persists across a fresh provider load', () async {
    final container1 = ProviderContainer();
    await container1.read(customFoodsProvider.notifier).rememberProduct(name: 'Orez', kcalPer100g: 130);
    container1.dispose();

    final container2 = ProviderContainer();
    addTearDown(container2.dispose);
    // Force the async load in the new notifier's constructor to complete.
    container2.read(customFoodsProvider.notifier);
    await pumpEventQueue();
    final foods = container2.read(customFoodsProvider);
    expect(foods.any((food) => food.name == 'Orez'), isTrue);
  });

  test('dailyLogProvider addEntry/removeEntry updates state and computed calories', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final date = DateTime(2026, 1, 15);
    final notifier = container.read(dailyLogProvider(date).notifier);

    await notifier.addEntry(
      mealType: MealType.breakfast,
      foodName: 'Ou fiert',
      grams: 50,
      kcalPer100g: 150,
    );

    final entries = container.read(dailyLogProvider(date));
    expect(entries, hasLength(1));
    expect(entries.first.calories, closeTo(75, 0.001)); // 50g * 150kcal/100g

    await notifier.removeEntry(entries.first.id);
    expect(container.read(dailyLogProvider(date)), isEmpty);
  });

  test('normalizeDate strips the time-of-day component', () {
    final withTime = DateTime(2026, 3, 4, 18, 30);
    expect(normalizeDate(withTime), DateTime(2026, 3, 4));
  });
}
