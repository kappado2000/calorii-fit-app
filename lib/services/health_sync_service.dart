import 'package:health/health.dart';

import '../domain/usecases/met_calorie_estimator.dart';

class DailyActivitySummary {
  const DailyActivitySummary({required this.steps, required this.activeCaloriesBurned});

  final int steps;
  final double activeCaloriesBurned;
}

/// One workout session read from Apple Health / Health Connect — this
/// app's own shape (not the raw `health` package type), so the rest of
/// the codebase never depends on that package directly, matching
/// [DailyActivitySummary] above.
class SyncedWorkout {
  const SyncedWorkout({
    required this.healthSourceUuid,
    required this.activityType,
    required this.duration,
    this.caloriesBurned,
  });

  final String healthSourceUuid;
  final ActivityType activityType;
  final Duration duration;

  /// Null when the health platform didn't report energy for this session
  /// (common for some Health Connect workout types) — the caller estimates
  /// it via MetCalorieEstimator + the user's own weight instead.
  final double? caloriesBurned;
}

/// Best-effort mapping onto this app's own, much smaller [ActivityType] —
/// deliberately approximate (e.g. every dance-like HealthKit/Health
/// Connect type collapses onto [ActivityType.dancing]) since the MET
/// table behind ActivityType only has that resolution to begin with.
ActivityType _mapWorkoutActivityType(HealthWorkoutActivityType type) {
  switch (type) {
    case HealthWorkoutActivityType.WALKING:
    case HealthWorkoutActivityType.WALKING_TREADMILL:
      return ActivityType.walkingCasual;
    case HealthWorkoutActivityType.HIKING:
      return ActivityType.hiking;
    case HealthWorkoutActivityType.RUNNING:
    case HealthWorkoutActivityType.RUNNING_TREADMILL:
    case HealthWorkoutActivityType.TRACK_AND_FIELD:
      return ActivityType.running;
    case HealthWorkoutActivityType.BIKING:
    case HealthWorkoutActivityType.BIKING_STATIONARY:
    case HealthWorkoutActivityType.HAND_CYCLING:
      return ActivityType.cycling;
    case HealthWorkoutActivityType.SWIMMING:
    case HealthWorkoutActivityType.SWIMMING_POOL:
    case HealthWorkoutActivityType.SWIMMING_OPEN_WATER:
    case HealthWorkoutActivityType.WATER_FITNESS:
      return ActivityType.swimming;
    case HealthWorkoutActivityType.STRENGTH_TRAINING:
    case HealthWorkoutActivityType.TRADITIONAL_STRENGTH_TRAINING:
    case HealthWorkoutActivityType.FUNCTIONAL_STRENGTH_TRAINING:
    case HealthWorkoutActivityType.WEIGHTLIFTING:
    case HealthWorkoutActivityType.CALISTHENICS:
    case HealthWorkoutActivityType.CORE_TRAINING:
    case HealthWorkoutActivityType.CROSS_TRAINING:
    case HealthWorkoutActivityType.HIGH_INTENSITY_INTERVAL_TRAINING:
      return ActivityType.strengthTraining;
    case HealthWorkoutActivityType.YOGA:
    case HealthWorkoutActivityType.PILATES:
    case HealthWorkoutActivityType.FLEXIBILITY:
    case HealthWorkoutActivityType.MIND_AND_BODY:
    case HealthWorkoutActivityType.BARRE:
    case HealthWorkoutActivityType.TAI_CHI:
      return ActivityType.yoga;
    case HealthWorkoutActivityType.CARDIO_DANCE:
    case HealthWorkoutActivityType.DANCING:
    case HealthWorkoutActivityType.SOCIAL_DANCE:
      return ActivityType.dancing;
    case HealthWorkoutActivityType.JUMP_ROPE:
      return ActivityType.jumpRope;
    case HealthWorkoutActivityType.SOCCER:
      return ActivityType.football;
    case HealthWorkoutActivityType.BASKETBALL:
      return ActivityType.basketball;
    case HealthWorkoutActivityType.TENNIS:
      return ActivityType.tennis;
    default:
      return ActivityType.other;
  }
}

/// Reads (never writes) weight and activity data from Health Connect
/// (Android) / Apple Health (iOS) via the `health` plugin, which wraps
/// both platforms behind one API — see project plan: this replaces raw
/// per-vendor Bluetooth pairing with watches, since every major
/// smartwatch brand already syncs into one of these two platforms.
class HealthSyncService {
  HealthSyncService() : _health = Health();

  final Health _health;

  static const _types = [
    HealthDataType.WEIGHT,
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.WORKOUT,
  ];

  Future<void> configure() => _health.configure();

  Future<bool> requestPermissions() async {
    final hasPermissions = await _health.hasPermissions(_types) ?? false;
    if (hasPermissions) return true;
    return _health.requestAuthorization(_types);
  }

  /// Most recent weight reading within the last 30 days, or null if none.
  Future<({double weightKg, DateTime date})?> latestWeight() async {
    final now = DateTime.now();
    final points = await _health.getHealthDataFromTypes(
      startTime: now.subtract(const Duration(days: 30)),
      endTime: now,
      types: const [HealthDataType.WEIGHT],
    );
    if (points.isEmpty) return null;

    points.sort((a, b) => b.dateTo.compareTo(a.dateTo));
    final latest = points.first;
    final value = latest.value;
    if (value is! NumericHealthValue) return null;
    return (weightKg: value.numericValue.toDouble(), date: latest.dateTo);
  }

  Future<DailyActivitySummary> todaySummary() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    final steps = await _health.getTotalStepsInInterval(midnight, now) ?? 0;

    final energyPoints = await _health.getHealthDataFromTypes(
      startTime: midnight,
      endTime: now,
      types: const [HealthDataType.ACTIVE_ENERGY_BURNED],
    );
    final activeCalories = energyPoints.fold<double>(0, (sum, point) {
      final value = point.value;
      return value is NumericHealthValue ? sum + value.numericValue.toDouble() : sum;
    });

    return DailyActivitySummary(steps: steps, activeCaloriesBurned: activeCalories);
  }

  /// Workout sessions (runs, rides, gym sessions, etc.) recorded by a
  /// connected watch/app today — distinct from [todaySummary]'s passive
  /// steps/energy totals, this is what feeds the sport-activity card
  /// (see ActivitySyncController.sync / workout_log_providers.dart).
  Future<List<SyncedWorkout>> todayWorkouts() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    final points = await _health.getHealthDataFromTypes(
      startTime: midnight,
      endTime: now,
      types: const [HealthDataType.WORKOUT],
    );

    final workouts = <SyncedWorkout>[];
    for (final point in points) {
      final value = point.value;
      if (value is! WorkoutHealthValue) continue;
      if (point.uuid.isEmpty) continue;
      workouts.add(
        SyncedWorkout(
          healthSourceUuid: point.uuid,
          activityType: _mapWorkoutActivityType(value.workoutActivityType),
          duration: point.dateTo.difference(point.dateFrom),
          caloriesBurned: value.totalEnergyBurned?.toDouble(),
        ),
      );
    }
    return workouts;
  }
}
