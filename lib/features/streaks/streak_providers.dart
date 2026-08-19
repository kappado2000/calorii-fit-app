import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/firestore/food_log_firestore_datasource.dart';
import '../auth/uid_provider.dart';
import '../food_log/food_log_providers.dart';

/// How far back streak calculation looks — generous enough that it never
/// visibly caps a real streak, without querying the user's entire history
/// on every app open.
const _streakLookbackDays = 400;

/// Consecutive days (ending today, or yesterday if today isn't logged
/// yet) with at least one food log entry — the same "streak persists
/// until the day is over" rule Duolingo-style trackers use, so logging
/// nothing *yet* today doesn't zero out a streak that's still alive.
final currentStreakProvider = StreamProvider<int>((ref) {
  final uid = ref.watch(currentUidProvider);
  final today = normalizeDate(DateTime.now());
  final start = today.subtract(const Duration(days: _streakLookbackDays));

  return FoodLogFirestoreDataSource(ref.watch(firestoreProvider), uid)
      .watchDailyTotalsForRange(start, today)
      .map((totals) => _computeStreak(totals, today));
});

int _computeStreak(Map<DateTime, double> dailyTotals, DateTime today) {
  bool loggedOn(DateTime day) => (dailyTotals[day] ?? 0) > 0;

  var cursor = loggedOn(today) ? today : today.subtract(const Duration(days: 1));
  var streak = 0;
  while (loggedOn(cursor)) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return streak;
}
