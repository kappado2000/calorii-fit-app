import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/locale_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/version/app_version_gate.dart';
import 'l10n/app_localizations.dart';
import 'routing/app_router.dart';

class CalorieApp extends ConsumerWidget {
  const CalorieApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      // AppVersionGate needs to sit *inside* MaterialApp (via builder), not
      // wrap it from outside — it uses a Stack, which needs the
      // Directionality/Theme context MaterialApp itself establishes.
      builder: (context, child) => AppVersionGate(child: child!),
    );
  }
}
