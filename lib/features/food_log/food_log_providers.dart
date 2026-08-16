import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/micronutrient_reference.dart';
import '../../data/datasources/remote/cloud_functions/search_foods_api_client.dart';
import '../../data/datasources/remote/firestore/custom_foods_firestore_datasource.dart';
import '../../data/datasources/remote/firestore/food_log_firestore_datasource.dart';
import '../../data/models/custom_food.dart';
import '../../data/models/food_log_entry.dart';
import '../../data/models/food_product.dart';
import '../../data/models/meal_type.dart';
import '../auth/uid_provider.dart';

const _uuid = Uuid();

DateTime normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

/// Overridable in tests (e.g. with FakeFirebaseFirestore) rather than
/// reaching for FirebaseFirestore.instance directly in the providers below.
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

/// Overridable in tests with a fake client instead of hitting the network.
final searchFoodsApiClientProvider = Provider<SearchFoodsApiClient>((ref) {
  final client = SearchFoodsApiClient();
  ref.onDispose(client.dispose);
  return client;
});

class CustomFoodsNotifier extends StateNotifier<List<CustomFood>> {
  CustomFoodsNotifier(this._dataSource) : super([]) {
    _subscription = _dataSource.watchAll().listen((foods) => state = foods);
  }

  final CustomFoodsFirestoreDataSource _dataSource;
  late final StreamSubscription<List<CustomFood>> _subscription;

  /// Remembers a product for reuse next time — if a product with the same
  /// name (case-insensitive) already exists, it's updated in place rather
  /// than creating a duplicate entry. [gramsUsed], when given, becomes the
  /// portion the quick-add checklist pre-fills next time.
  Future<CustomFood> rememberProduct({
    required String name,
    required double kcalPer100g,
    double? proteinPer100g,
    double? carbsPer100g,
    double? fatPer100g,
    double? gramsUsed,
    MicronutrientProfile? micronutrients,
  }) async {
    final trimmedName = name.trim();
    final existing = state
        .where((food) => food.name.toLowerCase() == trimmedName.toLowerCase())
        .firstOrNull;
    final food = CustomFood(
      id: existing?.id ?? _uuid.v4(),
      name: trimmedName,
      kcalPer100g: kcalPer100g,
      proteinPer100g: proteinPer100g,
      carbsPer100g: carbsPer100g,
      fatPer100g: fatPer100g,
      lastGramsUsed: gramsUsed ?? existing?.lastGramsUsed,
      micronutrients: micronutrients ?? existing?.micronutrients,
    );
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

/// Result of a product search: remembered-product matches are shown
/// immediately (no network round trip), then merged with the Open Food
/// Facts results once the debounced remote call resolves. [hadRemoteError]
/// lets the UI show a small "search unavailable" hint without blocking the
/// remembered-product matches that are still perfectly usable offline.
class FoodSearchState {
  const FoodSearchState({this.results = const [], this.isSearchingRemote = false, this.hadRemoteError = false});

  final List<FoodProduct> results;
  final bool isSearchingRemote;
  final bool hadRemoteError;
}

/// Debounced live search against the commercial-product database
/// (searchFoods Cloud Function → Open Food Facts), merged with the user's
/// own remembered products (which match instantly and are listed first,
/// since they're what the user has actually eaten before).
class FoodSearchNotifier extends StateNotifier<FoodSearchState> {
  FoodSearchNotifier(this._apiClient, this._customFoods) : super(const FoodSearchState());

  final SearchFoodsApiClient _apiClient;
  final List<CustomFood> _customFoods;
  Timer? _debounce;
  int _requestId = 0;

  void search(String query) {
    _debounce?.cancel();
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      state = const FoodSearchState();
      return;
    }

    final remembered = _customFoods
        .where((food) => food.name.toLowerCase().contains(trimmed.toLowerCase()))
        .map(
          (food) => FoodProduct(
            name: food.name,
            kcalPer100g: food.kcalPer100g,
            proteinPer100g: food.proteinPer100g,
            carbsPer100g: food.carbsPer100g,
            fatPer100g: food.fatPer100g,
            micronutrients: food.micronutrients,
          ),
        )
        .toList();
    state = FoodSearchState(results: remembered, isSearchingRemote: true);

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final requestId = ++_requestId;
      try {
        final remote = await _apiClient.search(trimmed);
        if (requestId != _requestId) return; // a newer query has since started

        final rememberedNames = remembered.map((f) => f.name.toLowerCase()).toSet();
        final merged = [
          ...remembered,
          ...remote.where((product) => !rememberedNames.contains(product.name.toLowerCase())),
        ];
        state = FoodSearchState(results: merged);
      } catch (_) {
        if (requestId != _requestId) return;
        state = FoodSearchState(results: remembered, hadRemoteError: true);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final foodSearchProvider = StateNotifierProvider.autoDispose<FoodSearchNotifier, FoodSearchState>((ref) {
  return FoodSearchNotifier(ref.watch(searchFoodsApiClientProvider), ref.watch(customFoodsProvider));
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
    double? proteinPer100g,
    double? carbsPer100g,
    double? fatPer100g,
    MicronutrientProfile? micronutrients,
  }) async {
    final entry = FoodLogEntry(
      id: _uuid.v4(),
      mealType: mealType,
      foodName: foodName.trim(),
      grams: grams,
      kcalPer100g: kcalPer100g,
      proteinPer100g: proteinPer100g,
      carbsPer100g: carbsPer100g,
      fatPer100g: fatPer100g,
      micronutrients: micronutrients,
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
