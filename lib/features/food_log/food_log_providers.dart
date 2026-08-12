import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/datasources/local/custom_foods_store.dart';
import '../../data/datasources/local/food_log_store.dart';
import '../../data/models/custom_food.dart';
import '../../data/models/food_log_entry.dart';
import '../../data/models/meal_type.dart';

const _uuid = Uuid();

DateTime normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

class CustomFoodsNotifier extends StateNotifier<List<CustomFood>> {
  CustomFoodsNotifier(this._store) : super([]) {
    _load();
  }

  final CustomFoodsStore _store;

  Future<void> _load() async {
    state = await _store.loadAll();
  }

  /// Remembers a product for reuse next time — if a product with the same
  /// name (case-insensitive) already exists, its calorie index is updated
  /// in place rather than creating a duplicate entry.
  Future<CustomFood> rememberProduct({required String name, required double kcalPer100g}) async {
    final trimmedName = name.trim();
    final existingIndex = state.indexWhere(
      (food) => food.name.toLowerCase() == trimmedName.toLowerCase(),
    );

    final CustomFood food;
    final List<CustomFood> next;
    if (existingIndex >= 0) {
      food = CustomFood(id: state[existingIndex].id, name: trimmedName, kcalPer100g: kcalPer100g);
      next = [...state]..[existingIndex] = food;
    } else {
      food = CustomFood(id: _uuid.v4(), name: trimmedName, kcalPer100g: kcalPer100g);
      next = [food, ...state];
    }

    state = next;
    await _store.saveAll(next);
    return food;
  }

  Future<void> deleteProduct(String id) async {
    final next = state.where((food) => food.id != id).toList();
    state = next;
    await _store.saveAll(next);
  }
}

final customFoodsProvider = StateNotifierProvider<CustomFoodsNotifier, List<CustomFood>>((ref) {
  return CustomFoodsNotifier(CustomFoodsStore());
});

class DailyLogNotifier extends StateNotifier<List<FoodLogEntry>> {
  DailyLogNotifier(this._store, this._date) : super([]) {
    _load();
  }

  final FoodLogStore _store;
  final DateTime _date;

  Future<void> _load() async {
    state = await _store.loadForDate(_date);
  }

  Future<void> addEntry({
    required MealType mealType,
    required String foodName,
    required double grams,
    required double kcalPer100g,
  }) async {
    final entry = FoodLogEntry(
      id: _uuid.v4(),
      mealType: mealType,
      foodName: foodName.trim(),
      grams: grams,
      kcalPer100g: kcalPer100g,
    );
    final next = [...state, entry];
    state = next;
    await _store.saveForDate(_date, next);
  }

  Future<void> removeEntry(String id) async {
    final next = state.where((entry) => entry.id != id).toList();
    state = next;
    await _store.saveForDate(_date, next);
  }
}

final dailyLogProvider =
    StateNotifierProvider.family<DailyLogNotifier, List<FoodLogEntry>, DateTime>((ref, date) {
      return DailyLogNotifier(FoodLogStore(), normalizeDate(date));
    });
