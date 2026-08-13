import '../../services/health_sync_service.dart';

sealed class ActivitySyncState {}

class ActivitySyncIdle extends ActivitySyncState {}

class ActivitySyncInProgress extends ActivitySyncState {}

class ActivitySyncSuccess extends ActivitySyncState {
  ActivitySyncSuccess({required this.summary, this.newWeightKg});

  final DailyActivitySummary summary;

  /// Non-null only when a new weight reading was found and saved during
  /// this sync (vs. one that was already logged for that day).
  final double? newWeightKg;
}

class ActivitySyncFailed extends ActivitySyncState {
  ActivitySyncFailed(this.message);
  final String message;
}
