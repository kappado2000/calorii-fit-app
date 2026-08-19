import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/weight_entry.dart';

class WeightEntriesFirestoreDataSource {
  WeightEntriesFirestoreDataSource(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_uid).collection('weightEntries');

  /// All entries ordered oldest-first — convenient both for "most recent
  /// weight" (`.last`) and for feeding a chart directly.
  Stream<List<WeightEntry>> watchAll() {
    return _collection.orderBy('date').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        final date = (data['date'] as Timestamp).toDate();
        return WeightEntry.fromJson({...data, 'id': doc.id}, date: date);
      }).toList(growable: false),
    );
  }

  /// [date] keeps its full time-of-day (not truncated to midnight) — the
  /// user can log a weigh-in whenever they want during the day, and
  /// multiple entries on the same calendar day need their times to stay
  /// meaningfully ordered.
  Future<void> add(DateTime date, double weightKg, WeightSource source) {
    return _collection.add({
      'date': Timestamp.fromDate(date),
      'weightKg': weightKg,
      'source': source.name,
    });
  }

  Future<void> update(String id, {required DateTime date, required double weightKg}) {
    return _collection.doc(id).update({
      'date': Timestamp.fromDate(date),
      'weightKg': weightKg,
    });
  }

  Future<void> delete(String id) => _collection.doc(id).delete();
}
