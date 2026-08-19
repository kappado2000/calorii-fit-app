import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/firestore/food_log_firestore_datasource.dart';
import '../../data/datasources/remote/firestore/workout_firestore_datasource.dart';
import '../auth/uid_provider.dart';
import '../food_log/food_log_providers.dart';

class WeeklySummary {
  const WeeklySummary({
    required this.thisWeekAvgCalories,
    required this.lastWeekAvgCalories,
    required this.thisWeekDaysLogged,
    required this.thisWeekWorkouts,
    required this.thisWeekBurned,
  });

  final double thisWeekAvgCalories;
  final double lastWeekAvgCalories;
  final int thisWeekDaysLogged;
  final int thisWeekWorkouts;
  final double thisWeekBurned;

  /// Positive means eating more than last week, negative less — the sign
  /// the UI colors and arrows key off.
  double get avgCaloriesDelta => thisWeekAvgCalories - lastWeekAvgCalories;

  static const empty = WeeklySummary(
    thisWeekAvgCalories: 0,
    lastWeekAvgCalories: 0,
    thisWeekDaysLogged: 0,
    thisWeekWorkouts: 0,
    thisWeekBurned: 0,
  );
}

/// Compares the last 7 days against the 7 days before that — a simple,
/// always-available recap that doesn't depend on a calorie target being
/// set (unlike the deficit chart on ProgressScreen), so it still shows
/// something meaningful for a user who hasn't finished onboarding.
final weeklySummaryProvider = StreamProvider<WeeklySummary>((ref) {
  final uid = ref.watch(currentUidProvider);
  final firestore = ref.watch(firestoreProvider);
  final today = normalizeDate(DateTime.now());
  final thisWeekStart = today.subtract(const Duration(days: 6));
  final lastWeekStart = today.subtract(const Duration(days: 13));
  final lastWeekEnd = today.subtract(const Duration(days: 7));

  final foodTotals = FoodLogFirestoreDataSource(firestore, uid).watchDailyTotalsForRange(lastWeekStart, today);
  final workoutTotals = WorkoutFirestoreDataSource(
    firestore,
    uid,
  ).watchDailyTotalsForRange(lastWeekStart, today);

  return foodTotals.asyncMap((foodByDay) async {
    final burnedByDay = await workoutTotals.first;

    double sumBetween(Map<DateTime, double> byDay, DateTime start, DateTime end) {
      var sum = 0.0;
      for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
        sum += byDay[d] ?? 0;
      }
      return sum;
    }

    int countLoggedBetween(Map<DateTime, double> byDay, DateTime start, DateTime end) {
      var count = 0;
      for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
        if ((byDay[d] ?? 0) > 0) count++;
      }
      return count;
    }

    final thisWeekTotal = sumBetween(foodByDay, thisWeekStart, today);
    final lastWeekTotal = sumBetween(foodByDay, lastWeekStart, lastWeekEnd);
    final thisWeekDaysLogged = countLoggedBetween(foodByDay, thisWeekStart, today);
    final lastWeekDaysLogged = countLoggedBetween(foodByDay, lastWeekStart, lastWeekEnd);
    final thisWeekBurned = sumBetween(burnedByDay, thisWeekStart, today);
    final thisWeekWorkoutDays = countLoggedBetween(burnedByDay, thisWeekStart, today);

    return WeeklySummary(
      thisWeekAvgCalories: thisWeekDaysLogged == 0 ? 0 : thisWeekTotal / thisWeekDaysLogged,
      lastWeekAvgCalories: lastWeekDaysLogged == 0 ? 0 : lastWeekTotal / lastWeekDaysLogged,
      thisWeekDaysLogged: thisWeekDaysLogged,
      thisWeekWorkouts: thisWeekWorkoutDays,
      thisWeekBurned: thisWeekBurned,
    );
  });
});
