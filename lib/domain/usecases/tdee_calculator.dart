import '../../data/models/user_profile.dart';

/// 1 kg of body fat is conventionally treated as ~7700 kcal for the purpose
/// of translating a target weekly rate of change into a daily calorie
/// delta — the standard approximation used across mainstream nutrition
/// apps (see project plan's TDEE section).
const double kcalPerKgBodyFat = 7700;

/// Never recommend below these floors regardless of inputs — a basic
/// safety guard on top of the raw math, independent of how aggressive the
/// user's requested weekly rate is.
const double _minSafeCaloriesMale = 1500;
const double _minSafeCaloriesFemale = 1200;

class TdeeResult {
  const TdeeResult({
    required this.bmr,
    required this.tdee,
    required this.calorieTarget,
    this.isAdaptive = false,
  });

  final double bmr;
  final double tdee;
  final double calorieTarget;

  /// True when [tdee] came from AdaptiveTdeeCalculator (the user's own
  /// logged energy balance) rather than the static Mifflin-St Jeor
  /// formula — the UI badges this distinctly since it's a different kind
  /// of number (a measurement, not a population-average prediction).
  final bool isAdaptive;

  /// Positive = calorie deficit (weight loss), negative = surplus (weight gain).
  double get dailyDeficit => tdee - calorieTarget;
}

/// Mifflin-St Jeor BMR formula (the industry-standard default — see
/// project plan) x an activity multiplier = TDEE, then TDEE adjusted by
/// the goal + target weekly rate = the daily calorie target.
class TdeeCalculator {
  const TdeeCalculator();

  TdeeResult calculate(UserProfile profile) {
    final bmr = _bmr(profile);
    final tdee = bmr * profile.activityLevel.factor;
    final target = _calorieTarget(tdee: tdee, profile: profile);
    return TdeeResult(bmr: bmr, tdee: tdee, calorieTarget: target);
  }

  /// Re-derives the calorie target for a different [tdee] value (e.g. an
  /// adaptive estimate) while keeping the same goal/rate/safety-floor
  /// logic — [bmr] stays the formula's own value for reference, since an
  /// adaptive TDEE doesn't have its own BMR component.
  TdeeResult withTdeeOverride(double tdee, UserProfile profile) {
    final bmr = _bmr(profile);
    final target = _calorieTarget(tdee: tdee, profile: profile);
    return TdeeResult(bmr: bmr, tdee: tdee, calorieTarget: target, isAdaptive: true);
  }

  double _bmr(UserProfile p) {
    final base = 10 * p.weightKg + 6.25 * p.heightCm - 5 * p.age;
    return p.sex == Sex.male ? base + 5 : base - 161;
  }

  double _calorieTarget({required double tdee, required UserProfile profile}) {
    if (profile.goal == Goal.maintain) return tdee;

    final dailyDelta = profile.targetRateKgPerWeek * kcalPerKgBodyFat / 7;
    final minSafe = profile.sex == Sex.male ? _minSafeCaloriesMale : _minSafeCaloriesFemale;

    if (profile.goal == Goal.lose) {
      final target = tdee - dailyDelta;
      return target < minSafe ? minSafe : target;
    }
    return tdee + dailyDelta;
  }
}
