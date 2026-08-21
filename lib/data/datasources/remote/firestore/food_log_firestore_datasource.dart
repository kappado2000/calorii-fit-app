import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/micronutrient_reference.dart';
import '../../../models/food_log_entry.dart';

/// Firestore-backed replacement for the Phase 1 SharedPreferences store —
/// `users/{uid}/foodLogs`, one document per logged item, queried by the
/// `date` field (start-of-day, matching normalizeDate) rather than one
/// sub-collection per date.
class FoodLogFirestoreDataSource {
  FoodLogFirestoreDataSource(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_uid).collection('foodLogs');

  Stream<List<FoodLogEntry>> watchForDate(DateTime date) {
    final start = Timestamp.fromDate(date);
    final end = Timestamp.fromDate(date.add(const Duration(days: 1)));
    return _collection
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FoodLogEntry.fromJson({...doc.data(), 'id': doc.id}))
              .toList(growable: false),
        );
  }

  Future<void> add(FoodLogEntry entry, DateTime date) {
    return _collection.doc(entry.id).set({...entry.toJson(), 'date': Timestamp.fromDate(date)});
  }

  Future<void> delete(String id) => _collection.doc(id).delete();

  /// Fills in macro/micronutrient data for an entry that was logged without
  /// it (see DailyLogNotifier.completeNutritionWithAi) — a partial update,
  /// unlike [add]'s full overwrite, so it never touches `date`, `grams`, or
  /// the calorie index the user already confirmed when they logged it.
  Future<void> updateNutrition(
    String id, {
    required double? proteinPer100g,
    required double? carbsPer100g,
    required double? fatPer100g,
    required MicronutrientProfile? micronutrients,
  }) {
    return _collection.doc(id).update({
      'proteinPer100g': proteinPer100g,
      'carbsPer100g': carbsPer100g,
      'fatPer100g': fatPer100g,
      'micronutrients': micronutrients?.toJson(),
    });
  }

  /// Every logged entry within [start, end] (inclusive of both ends'
  /// calendar days), unaggregated — what the macro/micronutrient analysis
  /// needs, since summing those requires each entry's own per-100g values,
  /// not just a calorie total per day.
  Stream<List<FoodLogEntry>> watchEntriesForRange(DateTime start, DateTime end) {
    final rangeStart = Timestamp.fromDate(DateTime(start.year, start.month, start.day));
    final rangeEnd = Timestamp.fromDate(DateTime(end.year, end.month, end.day).add(const Duration(days: 1)));
    return _collection
        .where('date', isGreaterThanOrEqualTo: rangeStart)
        .where('date', isLessThan: rangeEnd)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FoodLogEntry.fromJson({...doc.data(), 'id': doc.id}))
              .toList(growable: false),
        );
  }

  /// Total calories per day within [start, end] (inclusive of both ends'
  /// calendar days) — the aggregation the progress chart needs, computed
  /// client-side since Firestore has no server-side GROUP BY.
  Stream<Map<DateTime, double>> watchDailyTotalsForRange(DateTime start, DateTime end) {
    final rangeStart = Timestamp.fromDate(DateTime(start.year, start.month, start.day));
    final rangeEnd = Timestamp.fromDate(DateTime(end.year, end.month, end.day).add(const Duration(days: 1)));
    return _collection
        .where('date', isGreaterThanOrEqualTo: rangeStart)
        .where('date', isLessThan: rangeEnd)
        .snapshots()
        .map((snapshot) {
          final totals = <DateTime, double>{};
          for (final doc in snapshot.docs) {
            final data = doc.data();
            final date = (data['date'] as Timestamp).toDate();
            final normalized = DateTime(date.year, date.month, date.day);
            final entry = FoodLogEntry.fromJson({...data, 'id': doc.id});
            totals[normalized] = (totals[normalized] ?? 0) + entry.calories;
          }
          return totals;
        });
  }
}
