import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_providers.dart';
import '../features/auth/auth_screen.dart';
import '../features/food_log/food_log_screen.dart';
import 'go_router_refresh_stream.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(firebaseAuthProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(auth.authStateChanges()),
    redirect: (context, state) {
      final isSignedIn = auth.currentUser != null;
      final isOnLogin = state.matchedLocation == '/login';

      if (!isSignedIn && !isOnLogin) return '/login';
      if (isSignedIn && isOnLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const FoodLogScreen()),
      GoRoute(path: '/login', builder: (context, state) => const AuthScreen()),
    ],
  );
});
