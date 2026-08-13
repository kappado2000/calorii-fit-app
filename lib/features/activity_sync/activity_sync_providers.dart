import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/weight_entry.dart';
import '../../services/health_sync_service.dart';
import '../profile/profile_providers.dart';
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

      state = ActivitySyncSuccess(summary: summary, newWeightKg: savedWeightKg);
    } catch (e) {
      state = ActivitySyncFailed(e.toString());
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

final activitySyncControllerProvider =
    StateNotifierProvider.autoDispose<ActivitySyncController, ActivitySyncState>((ref) {
      return ActivitySyncController(ref);
    });
