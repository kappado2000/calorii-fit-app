import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/custom_food.dart';

/// Persists the user's remembered products locally (SharedPreferences,
/// JSON-encoded). Replaced by a Firestore-backed repository in Phase 2 —
/// kept behind this same load/save shape so that swap is a datasource
/// change, not a feature rewrite.
class CustomFoodsStore {
  static const _key = 'custom_foods';

  Future<List<CustomFood>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((item) => CustomFood.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> saveAll(List<CustomFood> foods) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(foods.map((food) => food.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}
