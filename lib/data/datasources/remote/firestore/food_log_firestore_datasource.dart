import 'package:cloud_firestore/cloud_firestore.dart';

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
}
