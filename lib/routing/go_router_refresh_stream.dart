import 'dart:async';

import 'package:flutter/foundation.dart';

/// Bridges a Stream (Firebase's authStateChanges()) into a Listenable that
/// go_router's `refreshListenable` can consume, so route redirects
/// re-evaluate whenever auth state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
