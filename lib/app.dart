import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/food_log/food_log_screen.dart';

class CalorieApp extends StatelessWidget {
  const CalorieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorii Fit',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      // Faza 1: jurnalul alimentar (introducere manuală) e ecranul principal;
      // ecranul de capabilități device rămâne accesibil din AppBar.
      // Routing complet (go_router) vine odată cu Faza 2 (auth + onboarding).
      home: const FoodLogScreen(),
    );
  }
}
