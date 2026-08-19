import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Every per-user Firestore sub-collection that needs to be wiped before
/// the account itself can go — see firestore.rules, which grants the owner
/// read/write over the whole `users/{uid}` subtree via a single wildcard
/// rule, so nothing here is enforced server-side; this list is the actual
/// source of truth for what "delete my data" means. Kept in sync manually
/// with the datasource files under data/datasources/remote/firestore/.
const _userSubcollections = ['customFoods', 'foodLogs', 'weightEntries', 'workouts', 'hydrationEntries'];

/// Deletes a signed-in user's account and every byte of their data —
/// required by both the App Store and Google Play for any app that lets
/// people create an account (Google Play Console Help, "Understanding
/// account deletion requirements"). No photos are stored server-side (they
/// go straight from the device to the analyzePhoto Cloud Function and are
/// never persisted), so Firestore + the Auth user are the whole surface.
class AccountDeletionService {
  const AccountDeletionService(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// Throws [FirebaseAuthException] with code `wrong-password` (bad
  /// password) or `requires-recent-login` (shouldn't happen here, since
  /// this always reauthenticates first) — the caller shows those as a
  /// plain "parolă greșită" message.
  Future<void> deleteAccountWithPassword(String password) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final email = user.email;
    if (email == null) {
      throw StateError('deleteAccountWithPassword requires an email/password account');
    }

    // Firebase requires a *recent* sign-in before it will allow deleting
    // the account or any other sensitive operation — re-entering the
    // password here both proves intent (this is destructive and
    // irreversible) and satisfies that requirement in the same step.
    await user.reauthenticateWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );

    final uid = user.uid;
    await _deleteAllUserData(uid);
    await user.delete();
  }

  Future<void> _deleteAllUserData(String uid) async {
    final userDoc = _firestore.collection('users').doc(uid);
    for (final name in _userSubcollections) {
      await _deleteCollection(userDoc.collection(name));
    }
    await userDoc.delete();
  }

  /// Firestore has no server-side "delete this collection" call from the
  /// client SDK — fetch and batch-delete in pages, since a food log
  /// history can easily exceed a single batch's 500-write limit.
  Future<void> _deleteCollection(CollectionReference<Map<String, dynamic>> collection) async {
    const pageSize = 300;
    while (true) {
      final snapshot = await collection.limit(pageSize).get();
      if (snapshot.docs.isEmpty) return;
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      if (snapshot.docs.length < pageSize) return;
    }
  }
}
