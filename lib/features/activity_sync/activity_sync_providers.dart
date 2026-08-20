import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/weight_entry.dart';
import '../../domain/usecases/met_calorie_estimator.dart';
import '../../services/health_sync_service.dart';
import '../food_log/food_log_providers.dart';
import '../profile/profile_providers.dart';
import '../workout_log/workout_log_providers.dart';
import 'activity_sync_state.dart';

final healthSyncServiceProvider = Provider<HealthSyncService>((ref) => HealthSyncService());

class ActivitySyncController extends StateNotifier<ActivitySyncState> {
  ActivitySyncController(this._ref) : super(ActivitySyncIdle());

  final Ref _ref;

  Future<void> sync() async {
    state = ActivitySyncInProgress();
    final service = _ref.read(healthSyncServiceProvider);
    try {
      await service.configure();
      final granted = await service.requestPermissions();
      if (!granted) {
        state = ActivitySyncFailed(
          'Permisiunile pentru Health Connect / Apple Health nu au fost acordate.',
        );
        return;
      }

      final summary = await service.todaySummary();
      final latestWeight = await service.latestWeight();

      double? savedWeightKg;
      if (latestWeight != null) {
        final existingEntries = _ref.read(weightEntriesProvider).valueOrNull ?? [];
        final alreadyLogged = existingEntries.any(
          (entry) => _isSameDay(entry.date, latestWeight.date) && entry.source != WeightSource.manual,
        );
        if (!alreadyLogged) {
          await _ref
              .read(profileControllerProvider)
              .logWeight(
                latestWeight.weightKg,
                date: latestWeight.date,
                source: Platform.isIOS ? WeightSource.appleHealth : WeightSource.healthConnect,
              );
          savedWeightKg = latestWeight.weightKg;
        }
      }

      final newWorkoutsCount = await _importTodayWorkouts(service);

      state = ActivitySyncSuccess(summary: summary, newWeightKg: savedWeightKg, newWorkoutsCount: newWorkoutsCount);
    } catch (e) {
      state = ActivitySyncFailed(e.toString());
    }
  }

  /// Imports today's watch/app-recorded workout sessions into the
  /// sport-activity card — each one deduplicated by its health-platform id
  /// (see WorkoutLogNotifier.addSyncedWorkout), so re-running sync never
  /// creates duplicates. Returns how many were newly added.
  Future<int> _importTodayWorkouts(HealthSyncService service) async {
    final workouts = await service.todayWorkouts();
    if (workouts.isEmpty) return 0;

    final today = normalizeDate(DateTime.now());
    final notifier = _ref.read(workoutLogProvider(today).notifier);
    final profileWeightKg = _ref.read(userProfileProvider).valueOrNull?.weightKg ?? 70;

    var addedCount = 0;
    for (final workout in workouts) {
      final calories =
          workout.caloriesBurned ??
          const MetCalorieEstimator().estimateCalories(
            activityType: workout.activityType,
            weightKg: profileWeightKg,
            duration: workout.duration,
          );
      final added = await notifier.addSyncedWorkout(
        activityType: workout.activityType,
        duration: workout.duration,
        caloriesBurned: calories,
        healthSourceUuid: workout.healthSourceUuid,
      );
      if (added) addedCount++;
    }
    return addedCount;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

final activitySyncControllerProvider =
    StateNotifierProvider.autoDispose<ActivitySyncController, ActivitySyncState>((ref) {
      return ActivitySyncController(ref);
    });
