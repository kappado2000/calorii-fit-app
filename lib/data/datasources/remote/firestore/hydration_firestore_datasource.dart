import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/hydration_entry.dart';

/// `users/{uid}/hydrationEntries`, one document per "add water" tap,
/// queried by the `date` field — mirrors FoodLogFirestoreDataSource.
class HydrationFirestoreDataSource {
  HydrationFirestoreDataSource(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_uid).collection('hydrationEntries');

  Stream<List<HydrationEntry>> watchForDate(DateTime date) {
    final start = Timestamp.fromDate(date);
    final end = Timestamp.fromDate(date.add(const Duration(days: 1)));
    return _collection
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => HydrationEntry.fromJson({...doc.data(), 'id': doc.id}))
              .toList(growable: false),
        );
  }

  Future<void> add(HydrationEntry entry, DateTime date) {
    return _collection.doc(entry.id).set({...entry.toJson(), 'date': Timestamp.fromDate(date)});
  }

  Future<void> delete(String id) => _collection.doc(id).delete();
}
