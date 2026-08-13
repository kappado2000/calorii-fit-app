import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_providers.dart';
import '../features/auth/auth_screen.dart';
import '../features/food_log/food_log_providers.dart';
import '../features/food_log/food_log_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import 'auth_and_profile_refresh_listenable.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firestoreProvider);
  final refreshListenable = AuthAndProfileRefreshListenable(auth, firestore);
  ref.onDispose(refreshListenable.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final isSignedIn = auth.currentUser != null;
      final isOnLogin = state.matchedLocation == '/login';
      final isOnOnboarding = state.matchedLocation == '/onboarding';

      if (!isSignedIn) return isOnLogin ? null : '/login';

      // Signed in from here on. Don't special-case "just left /login" —
      // that previously short-circuited straight to '/' before the
      // profile check ever ran, so a brand-new signup could get stranded
      // on the food log screen instead of being sent to onboarding.
      if (!refreshListenable.profileLoaded) {
        // Profile existence not known yet — park on '/' rather than
        // leaving the user on the login screen once they're signed in;
        // the food log screen already handles "no profile yet" gracefully.
        return isOnLogin ? '/' : null;
      }

      if (isOnLogin) return '/';
      if (!refreshListenable.hasProfile && !isOnOnboarding) return '/onboarding';
      // A profile existing doesn't make onboarding off-limits — the user
      // must be able to navigate there deliberately (via "Editează profil/
      // obiectiv") to change it, not just on first-time setup.
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const FoodLogScreen()),
      GoRoute(path: '/login', builder: (context, state) => const AuthScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
    ],
  );
});
