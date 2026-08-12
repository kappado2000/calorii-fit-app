import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/device_capability/device_capability_screen.dart';

class CalorieApp extends StatelessWidget {
  const CalorieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorii Fit',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      // Faza 0: singurul ecran e testul de capabilități device.
      // Routing complet (go_router) vine odată cu Faza 2 (auth + onboarding).
      home: const DeviceCapabilityScreen(),
    );
  }
}
