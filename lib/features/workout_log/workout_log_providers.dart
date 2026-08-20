import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/datasources/remote/firestore/workout_firestore_datasource.dart';
import '../../data/models/workout_entry.dart';
import '../../domain/usecases/met_calorie_estimator.dart';
import '../auth/uid_provider.dart';
import '../food_log/food_log_providers.dart';

const _uuid = Uuid();

class WorkoutLogNotifier extends StateNotifier<List<WorkoutEntry>> {
  WorkoutLogNotifier(this._dataSource, this._date) : super([]) {
    _subscription = _dataSource.watchForDate(_date).listen((entries) => state = entries);
  }

  final WorkoutFirestoreDataSource _dataSource;
  final DateTime _date;
  late final StreamSubscription<List<WorkoutEntry>> _subscription;

  Future<void> addWorkout({
    required ActivityType activityType,
    required Duration duration,
    required double weightKg,
  }) async {
    final calories = const MetCalorieEstimator().estimateCalories(
      activityType: activityType,
      weightKg: weightKg,
      duration: duration,
    );
    final entry = WorkoutEntry(
      id: _uuid.v4(),
      activityType: activityType,
      duration: duration,
      caloriesBurned: calories,
    );
    await _dataSource.add(entry, _date);
  }

  /// For activities that don't fit the MET/duration model, or when the
  /// user already knows the number from elsewhere (a watch, a gym
  /// machine's display) and would rather not translate it into a duration.
  /// Duration is kept at zero — the UI hides the "X min" subtitle for
  /// these entries rather than showing a misleading "0 min".
  Future<void> addManualWorkout({required double caloriesBurned, ActivityType activityType = ActivityType.other}) async {
    final entry = WorkoutEntry(
      id: _uuid.v4(),
      activityType: activityType,
      duration: Duration.zero,
      caloriesBurned: caloriesBurned,
    );
    await _dataSource.add(entry, _date);
  }

  /// Imports one workout session read from Apple Health / Health Connect
  /// (see HealthSyncService.todayWorkouts) — skips it if a workout with the
  /// same [healthSourceUuid] was already imported, so re-syncing never
  /// duplicates a session already on the card. Returns whether it was
  /// actually added.
  Future<bool> addSyncedWorkout({
    required ActivityType activityType,
    required Duration duration,
    required double caloriesBurned,
    required String healthSourceUuid,
  }) async {
    if (await _dataSource.existsWithHealthSourceUuid(healthSourceUuid)) return false;
    final entry = WorkoutEntry(
      id: _uuid.v4(),
      activityType: activityType,
      duration: duration,
      caloriesBurned: caloriesBurned,
      healthSourceUuid: healthSourceUuid,
    );
    await _dataSource.add(entry, _date);
    return true;
  }

  Future<void> removeWorkout(String id) => _dataSource.delete(id);

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final workoutLogProvider =
    StateNotifierProvider.family<WorkoutLogNotifier, List<WorkoutEntry>, DateTime>((ref, date) {
      final uid = ref.watch(currentUidProvider);
      return WorkoutLogNotifier(
        WorkoutFirestoreDataSource(ref.watch(firestoreProvider), uid),
        normalizeDate(date),
      );
    });
