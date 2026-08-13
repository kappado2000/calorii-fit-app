import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/firestore/food_log_firestore_datasource.dart';
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

/// Daily calorie totals for the selected [ProgressPeriod], keyed by
/// normalized date — the data both the intake and deficit charts are
/// derived from (deficit = the profile's current TDEE minus that day's
/// intake; see progress_screen.dart).
final dailyCalorieHistoryProvider = StreamProvider.family<Map<DateTime, double>, ProgressPeriod>((
  ref,
  period,
) {
  final uid = ref.watch(currentUidProvider);
  final profile = ref.watch(userProfileProvider).valueOrNull;
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

  return FoodLogFirestoreDataSource(
    ref.watch(firestoreProvider),
    uid,
  ).watchDailyTotalsForRange(start, end);
});
