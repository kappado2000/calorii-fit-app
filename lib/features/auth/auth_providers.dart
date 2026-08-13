import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// Email/password only for now — Google/Apple Sign-In are noted in the
/// project plan but need extra platform setup (OAuth client propagation on
/// Android, Sign in with Apple entitlements on iOS, which needs Xcode) not
/// available yet on this dev machine.
class AuthController {
  AuthController(this._auth);

  final FirebaseAuth _auth;

  Future<void> signInWithEmail({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
  }

  Future<void> registerWithEmail({required String email, required String password}) {
    return _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() => _auth.signOut();
}

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref.watch(firebaseAuthProvider));
});
