import '../../l10n/app_localizations.dart';

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
  /// Takes AppLocalizations directly (not a BuildContext) so call sites
  /// that already resolved `l10n` once (e.g. mapping a whole list) don't
  /// re-resolve it per item.
  String label(AppLocalizations l10n) {
    switch (this) {
      case ActivityType.walkingCasual:
        return l10n.activityWalkingCasual;
      case ActivityType.walkingBrisk:
        return l10n.activityWalkingBrisk;
      case ActivityType.running:
        return l10n.activityRunning;
      case ActivityType.runningFast:
        return l10n.activityRunningFast;
      case ActivityType.cycling:
        return l10n.activityCycling;
      case ActivityType.cyclingIntense:
        return l10n.activityCyclingIntense;
      case ActivityType.swimming:
        return l10n.activitySwimming;
      case ActivityType.strengthTraining:
        return l10n.activityStrengthTraining;
      case ActivityType.yoga:
        return l10n.activityYoga;
      case ActivityType.dancing:
        return l10n.activityDancing;
      case ActivityType.hiking:
        return l10n.activityHiking;
      case ActivityType.jumpRope:
        return l10n.activityJumpRope;
      case ActivityType.football:
        return l10n.activityFootball;
      case ActivityType.basketball:
        return l10n.activityBasketball;
      case ActivityType.tennis:
        return l10n.activityTennis;
      case ActivityType.other:
        return l10n.activityOther;
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
