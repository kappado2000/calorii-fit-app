import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/custom_food.dart';

/// Firestore-backed replacement for the Phase 1 SharedPreferences store —
/// same shape (`users/{uid}/customFoods`, see project plan's Firestore
/// schema section), now synced across devices.
class CustomFoodsFirestoreDataSource {
  CustomFoodsFirestoreDataSource(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  /// Generous ceiling on a real-time listener that would otherwise grow
  /// unbounded over a multi-year account lifetime. Deliberately *not*
  /// `orderBy('updatedAt')` — that would silently exclude every document
  /// written before this field existed (Firestore drops docs missing an
  /// ordered field from the result set entirely), which would make
  /// existing users' remembered foods vanish until re-used. `updatedAt` is
  /// still recorded on every write so a true recency ordering becomes safe
  /// to add later, once it's had time to backfill.
  static const _maxWatched = 400;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_uid).collection('customFoods');

  Stream<List<CustomFood>> watchAll() {
    return _collection.limit(_maxWatched).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => CustomFood.fromJson({...doc.data(), 'id': doc.id}))
          .toList(growable: false),
    );
  }

  Future<void> upsert(CustomFood food) {
    return _collection.doc(food.id).set({...food.toJson(), 'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<void> delete(String id) => _collection.doc(id).delete();
}
