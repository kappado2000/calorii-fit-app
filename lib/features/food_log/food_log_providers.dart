import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/datasources/remote/firestore/custom_foods_firestore_datasource.dart';
import '../../data/datasources/remote/firestore/food_log_firestore_datasource.dart';
import '../../data/models/custom_food.dart';
import '../../data/models/food_log_entry.dart';
import '../../data/models/meal_type.dart';
import '../auth/uid_provider.dart';

const _uuid = Uuid();

DateTime normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

/// Overridable in tests (e.g. with FakeFirebaseFirestore) rather than
/// reaching for FirebaseFirestore.instance directly in the providers below.
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

class CustomFoodsNotifier extends StateNotifier<List<CustomFood>> {
  CustomFoodsNotifier(this._dataSource) : super([]) {
    _subscription = _dataSource.watchAll().listen((foods) => state = foods);
  }

  final CustomFoodsFirestoreDataSource _dataSource;
  late final StreamSubscription<List<CustomFood>> _subscription;

  /// Remembers a product for reuse next time — if a product with the same
  /// name (case-insensitive) already exists, its calorie index is updated
  /// in place rather than creating a duplicate entry.
  Future<CustomFood> rememberProduct({required String name, required double kcalPer100g}) async {
    final trimmedName = name.trim();
    final existing = state
        .where((food) => food.name.toLowerCase() == trimmedName.toLowerCase())
        .firstOrNull;
    final food = CustomFood(id: existing?.id ?? _uuid.v4(), name: trimmedName, kcalPer100g: kcalPer100g);
    await _dataSource.upsert(food);
    return food;
  }

  Future<void> deleteProduct(String id) => _dataSource.delete(id);

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final customFoodsProvider = StateNotifierProvider<CustomFoodsNotifier, List<CustomFood>>((ref) {
  final uid = ref.watch(currentUidProvider);
  return CustomFoodsNotifier(CustomFoodsFirestoreDataSource(ref.watch(firestoreProvider), uid));
});

class DailyLogNotifier extends StateNotifier<List<FoodLogEntry>> {
  DailyLogNotifier(this._dataSource, this._date) : super([]) {
    _subscription = _dataSource.watchForDate(_date).listen((entries) => state = entries);
  }

  final FoodLogFirestoreDataSource _dataSource;
  final DateTime _date;
  late final StreamSubscription<List<FoodLogEntry>> _subscription;

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
    await _dataSource.add(entry, _date);
  }

  Future<void> removeEntry(String id) => _dataSource.delete(id);

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final dailyLogProvider =
    StateNotifierProvider.family<DailyLogNotifier, List<FoodLogEntry>, DateTime>((ref, date) {
      final uid = ref.watch(currentUidProvider);
      return DailyLogNotifier(
        FoodLogFirestoreDataSource(ref.watch(firestoreProvider), uid),
        normalizeDate(date),
      );
    });
