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
