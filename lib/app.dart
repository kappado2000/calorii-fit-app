import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/version/app_version_gate.dart';
import 'routing/app_router.dart';

class CalorieApp extends ConsumerWidget {
  const CalorieApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Calorii Fit',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
      // AppVersionGate needs to sit *inside* MaterialApp (via builder), not
      // wrap it from outside — it uses a Stack, which needs the
      // Directionality/Theme context MaterialApp itself establishes.
      builder: (context, child) => AppVersionGate(child: child!),
    );
  }
}
