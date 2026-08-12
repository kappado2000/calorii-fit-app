enum MealType { breakfast, lunch, dinner }

extension MealTypeLabel on MealType {
  String get label {
    switch (this) {
      case MealType.breakfast:
        return 'Dimineață';
      case MealType.lunch:
        return 'Prânz';
      case MealType.dinner:
        return 'Seară';
    }
  }
}
