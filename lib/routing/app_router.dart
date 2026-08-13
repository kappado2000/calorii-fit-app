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
      if (isOnLogin) return '/';

      if (refreshListenable.profileLoaded) {
        if (!refreshListenable.hasProfile && !isOnOnboarding) return '/onboarding';
        if (refreshListenable.hasProfile && isOnOnboarding) return '/';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const FoodLogScreen()),
      GoRoute(path: '/login', builder: (context, state) => const AuthScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
    ],
  );
});
