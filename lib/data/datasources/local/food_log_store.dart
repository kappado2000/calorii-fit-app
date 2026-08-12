import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/food_log_entry.dart';

/// Persists each day's food log locally (SharedPreferences, one JSON list
/// per date key). Replaced by Firestore's `foodLogs` subcollection in
/// Phase 2 (see project plan) — same load/save shape so the swap is a
/// datasource change, not a feature rewrite.
class FoodLogStore {
  String _keyFor(DateTime date) => 'food_log_${date.year}-${date.month}-${date.day}';

  Future<List<FoodLogEntry>> loadForDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFor(date));
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((item) => FoodLogEntry.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> saveForDate(DateTime date, List<FoodLogEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(entries.map((entry) => entry.toJson()).toList());
    await prefs.setString(_keyFor(date), encoded);
  }
}
