import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';

/// Any screen reading this is only ever shown while signed in (see
/// routing/app_router.dart's redirect), so a null uid means this provider
/// was built outside that guarantee — worth failing loudly.
///
/// Watches authStateChangesProvider (for reactive rebuilds on sign-in/out),
/// but falls back to the synchronous `currentUser` getter when that
/// StreamProvider hasn't delivered its first event yet — otherwise there's
/// a real race on cold start: go_router's redirect already used the
/// synchronous `currentUser` to route here, but the stream-based value can
/// still be AsyncLoading on the very first frame.
final currentUidProvider = Provider<String>((ref) {
  final streamUid = ref.watch(authStateChangesProvider).valueOrNull?.uid;
  final uid = streamUid ?? ref.watch(firebaseAuthProvider).currentUser?.uid;
  if (uid == null) {
    throw StateError('currentUidProvider read without an authenticated user');
  }
  return uid;
});
