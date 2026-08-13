enum ActivityType {
  walkingCasual,
  walkingBrisk,
  running,
  runningFast,
  cycling,
  cyclingIntense,
  swimming,
  strengthTraining,
  yoga,
  dancing,
  hiking,
  jumpRope,
  football,
  basketball,
  tennis,
  other,
}

extension ActivityTypeLabel on ActivityType {
  String get label {
    switch (this) {
      case ActivityType.walkingCasual:
        return 'Mers pe jos (lejer)';
      case ActivityType.walkingBrisk:
        return 'Mers pe jos (alert)';
      case ActivityType.running:
        return 'Alergare';
      case ActivityType.runningFast:
        return 'Alergare rapidă';
      case ActivityType.cycling:
        return 'Ciclism (moderat)';
      case ActivityType.cyclingIntense:
        return 'Ciclism (intens)';
      case ActivityType.swimming:
        return 'Înot';
      case ActivityType.strengthTraining:
        return 'Antrenament de forță';
      case ActivityType.yoga:
        return 'Yoga';
      case ActivityType.dancing:
        return 'Dans';
      case ActivityType.hiking:
        return 'Drumeție';
      case ActivityType.jumpRope:
        return 'Sărit coarda';
      case ActivityType.football:
        return 'Fotbal';
      case ActivityType.basketball:
        return 'Baschet';
      case ActivityType.tennis:
        return 'Tenis';
      case ActivityType.other:
        return 'Altă activitate';
    }
  }
}

/// MET (Metabolic Equivalent of Task) values from the widely-used
/// Compendium of Physical Activities — the standard reference for
/// estimating exercise calorie burn without a wearable.
const Map<ActivityType, double> _metValues = {
  ActivityType.walkingCasual: 3.0,
  ActivityType.walkingBrisk: 4.3,
  ActivityType.running: 7.0,
  ActivityType.runningFast: 10.0,
  ActivityType.cycling: 6.8,
  ActivityType.cyclingIntense: 10.0,
  ActivityType.swimming: 6.0,
  ActivityType.strengthTraining: 5.0,
  ActivityType.yoga: 2.5,
  ActivityType.dancing: 4.8,
  ActivityType.hiking: 6.0,
  ActivityType.jumpRope: 10.0,
  ActivityType.football: 7.0,
  ActivityType.basketball: 6.5,
  ActivityType.tennis: 7.3,
  ActivityType.other: 4.0,
};

/// kcal = MET x weight(kg) x duration(hours) — the standard formula for
/// estimating energy expenditure of an activity from its MET value.
class MetCalorieEstimator {
  const MetCalorieEstimator();

  double estimateCalories({
    required ActivityType activityType,
    required double weightKg,
    required Duration duration,
  }) {
    final met = _metValues[activityType] ?? _metValues[ActivityType.other]!;
    final hours = duration.inMinutes / 60.0;
    return met * weightKg * hours;
  }

  double metValueFor(ActivityType activityType) => _metValues[activityType] ?? _metValues[ActivityType.other]!;
}
