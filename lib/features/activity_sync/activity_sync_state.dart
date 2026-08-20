import '../../services/health_sync_service.dart';

sealed class ActivitySyncState {}

class ActivitySyncIdle extends ActivitySyncState {}

class ActivitySyncInProgress extends ActivitySyncState {}

class ActivitySyncSuccess extends ActivitySyncState {
  ActivitySyncSuccess({required this.summary, this.newWeightKg, this.newWorkoutsCount = 0});

  final DailyActivitySummary summary;

  /// Non-null only when a new weight reading was found and saved during
  /// this sync (vs. one that was already logged for that day).
  final double? newWeightKg;

  /// How many of today's health-platform workout sessions were newly
  /// imported into the sport-activity card during this sync (0 when there
  /// were none, or all of them were already imported earlier).
  final int newWorkoutsCount;
}

class ActivitySyncFailed extends ActivitySyncState {
  ActivitySyncFailed(this.message);
  final String message;
}
