import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/user_profile.dart';

/// The profile lives directly on `users/{uid}` (the top-level user
/// document), per the project plan's Firestore schema — not a
/// sub-collection, since there's exactly one per user.
class UserProfileFirestoreDataSource {
  UserProfileFirestoreDataSource(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  DocumentReference<Map<String, dynamic>> get _doc => _firestore.collection('users').doc(_uid);

  Stream<UserProfile?> watch() {
    return _doc.snapshots().map((snap) {
      final data = snap.data();
      if (data == null || !data.containsKey('heightCm')) return null;
      return UserProfile.fromJson(data);
    });
  }

  Future<void> save(UserProfile profile) {
    return _doc.set(profile.toJson(), SetOptions(merge: true));
  }
}
