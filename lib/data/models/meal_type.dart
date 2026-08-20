import '../../l10n/app_localizations.dart';

enum MealType { breakfast, lunch, dinner, snack }

extension MealTypeLabel on MealType {
  String label(AppLocalizations l10n) {
    switch (this) {
      case MealType.breakfast:
        return l10n.mealBreakfast;
      case MealType.lunch:
        return l10n.mealLunch;
      case MealType.dinner:
        return l10n.mealDinner;
      case MealType.snack:
        return l10n.mealSnack;
    }
  }

  /// Rough proportional share of the daily calorie target — gives each
  /// meal's gauge a meaningful fill percentage instead of an arbitrary
  /// max, without the app prescribing rigid per-meal targets.
  double get dailyShare {
    switch (this) {
      case MealType.breakfast:
        return 0.25;
      case MealType.lunch:
        return 0.35;
      case MealType.dinner:
        return 0.30;
      case MealType.snack:
        return 0.10;
    }
  }
}
