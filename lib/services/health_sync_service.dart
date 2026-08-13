import 'package:health/health.dart';

class DailyActivitySummary {
  const DailyActivitySummary({required this.steps, required this.activeCaloriesBurned});

  final int steps;
  final double activeCaloriesBurned;
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
}
