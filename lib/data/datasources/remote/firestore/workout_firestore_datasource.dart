import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/workout_entry.dart';

/// `users/{uid}/workouts` — manually logged exercise sessions (distinct
/// from the passive steps/active-calories pulled from Health Connect /
/// Apple Health), so the user explicitly controls what counts as "extra"
/// burn added on top of their TDEE for the day (see project plan's TDEE
/// section and the deficit calc in food_log_screen.dart).
class WorkoutFirestoreDataSource {
  WorkoutFirestoreDataSource(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_uid).collection('workouts');

  Stream<List<WorkoutEntry>> watchForDate(DateTime date) {
    final start = Timestamp.fromDate(DateTime(date.year, date.month, date.day));
    final end = Timestamp.fromDate(DateTime(date.year, date.month, date.day).add(const Duration(days: 1)));
    return _collection
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => WorkoutEntry.fromJson({...doc.data(), 'id': doc.id}))
              .toList(growable: false),
        );
  }

  Future<void> add(WorkoutEntry entry, DateTime date) {
    return _collection.doc(entry.id).set({...entry.toJson(), 'date': Timestamp.fromDate(date)});
  }

  Future<void> delete(String id) => _collection.doc(id).delete();

  /// Whether a workout previously imported from Apple Health / Health
  /// Connect (see WorkoutEntry.healthSourceUuid) already exists — checked
  /// before importing a health-sourced session, so re-running sync never
  /// creates duplicate entries for the same recorded workout.
  Future<bool> existsWithHealthSourceUuid(String uuid) async {
    final snapshot = await _collection.where('healthSourceUuid', isEqualTo: uuid).limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  /// Total calories burned per day within [start, end] — feeds the
  /// progress screen's deficit chart alongside food intake totals.
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
            final entry = WorkoutEntry.fromJson({...data, 'id': doc.id});
            totals[normalized] = (totals[normalized] ?? 0) + entry.caloriesBurned;
          }
          return totals;
        });
  }
}
