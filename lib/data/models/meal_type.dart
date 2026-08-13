enum MealType { breakfast, lunch, dinner, snack }

extension MealTypeLabel on MealType {
  String get label {
    switch (this) {
      case MealType.breakfast:
        return 'Dimineață';
      case MealType.lunch:
        return 'Prânz';
      case MealType.dinner:
        return 'Seară';
      case MealType.snack:
        return 'Gustare';
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
