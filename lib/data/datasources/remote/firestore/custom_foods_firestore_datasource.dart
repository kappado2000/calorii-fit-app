import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/custom_food.dart';

/// Firestore-backed replacement for the Phase 1 SharedPreferences store —
/// same shape (`users/{uid}/customFoods`, see project plan's Firestore
/// schema section), now synced across devices.
class CustomFoodsFirestoreDataSource {
  CustomFoodsFirestoreDataSource(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_uid).collection('customFoods');

  Stream<List<CustomFood>> watchAll() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => CustomFood.fromJson({...doc.data(), 'id': doc.id}))
          .toList(growable: false),
    );
  }

  Future<void> upsert(CustomFood food) {
    return _collection.doc(food.id).set(food.toJson());
  }

  Future<void> delete(String id) => _collection.doc(id).delete();
}
