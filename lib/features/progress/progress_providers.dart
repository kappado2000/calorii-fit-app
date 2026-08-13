import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/firestore/food_log_firestore_datasource.dart';
import '../../data/datasources/remote/firestore/workout_firestore_datasource.dart';
import '../../data/models/user_profile.dart';
import '../auth/uid_provider.dart';
import '../food_log/food_log_providers.dart';
import '../profile/profile_providers.dart';

enum ProgressPeriod { last7Days, last30Days, sinceProgramStart }

extension ProgressPeriodLabel on ProgressPeriod {
  String get label {
    switch (this) {
      case ProgressPeriod.last7Days:
        return '7 zile';
      case ProgressPeriod.last30Days:
        return '30 zile';
      case ProgressPeriod.sinceProgramStart:
        return 'Tot programul';
    }
  }
}

(DateTime start, DateTime end) _dateRangeForPeriod(ProgressPeriod period, UserProfile? profile) {
  final end = normalizeDate(DateTime.now());
  final DateTime start;
  switch (period) {
    case ProgressPeriod.last7Days:
      start = end.subtract(const Duration(days: 6));
    case ProgressPeriod.last30Days:
      start = end.subtract(const Duration(days: 29));
    case ProgressPeriod.sinceProgramStart:
      start = profile != null ? normalizeDate(profile.programStartDate) : end;
  }
  return (start, end);
}

/// Daily calorie-intake totals for the selected [ProgressPeriod], keyed by
/// normalized date — feeds the intake chart in progress_screen.dart.
final dailyCalorieHistoryProvider = StreamProvider.family<Map<DateTime, double>, ProgressPeriod>((
  ref,
  period,
) {
  final uid = ref.watch(currentUidProvider);
  final profile = ref.watch(userProfileProvider).valueOrNull;
  final (start, end) = _dateRangeForPeriod(period, profile);

  return FoodLogFirestoreDataSource(
    ref.watch(firestoreProvider),
    uid,
  ).watchDailyTotalsForRange(start, end);
});

/// Daily exercise-calories-burned totals for the selected [ProgressPeriod]
/// — combined with intake in the deficit chart (deficit = TDEE + burned -
/// intake, matching the "eat back exercise calories" model used on the
/// food log screen).
final dailyBurnedHistoryProvider = StreamProvider.family<Map<DateTime, double>, ProgressPeriod>((
  ref,
  period,
) {
  final uid = ref.watch(currentUidProvider);
  final profile = ref.watch(userProfileProvider).valueOrNull;
  final (start, end) = _dateRangeForPeriod(period, profile);

  return WorkoutFirestoreDataSource(
    ref.watch(firestoreProvider),
    uid,
  ).watchDailyTotalsForRange(start, end);
});
