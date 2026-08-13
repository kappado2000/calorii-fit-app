import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Drives go_router's redirect logic through three states: signed out,
/// signed in without a saved profile (needs onboarding), signed in with a
/// profile. Wraps the Firebase SDK streams directly (rather than going
/// through Riverpod providers) so the redirect callback can read cached
/// synchronous fields instead of juggling AsyncValue inside a router
/// rebuild — recreating the whole GoRouter on every auth/profile change
/// would drop navigation state.
class AuthAndProfileRefreshListenable extends ChangeNotifier {
  AuthAndProfileRefreshListenable(this._auth, this._firestore) {
    _authSubscription = _auth.authStateChanges().listen(_onAuthChanged);
  }

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  late final StreamSubscription<User?> _authSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _profileSubscription;

  bool profileLoaded = false;
  bool hasProfile = false;

  void _onAuthChanged(User? user) {
    _profileSubscription?.cancel();
    profileLoaded = false;
    hasProfile = false;

    if (user == null) {
      notifyListeners();
      return;
    }

    _profileSubscription = _firestore.collection('users').doc(user.uid).snapshots().listen((snapshot) {
      profileLoaded = true;
      hasProfile = snapshot.data()?.containsKey('heightCm') ?? false;
      notifyListeners();
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _profileSubscription?.cancel();
    super.dispose();
  }
}
