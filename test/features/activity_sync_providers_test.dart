import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/data/models/weight_entry.dart';
import 'package:calorie_app/features/activity_sync/activity_sync_providers.dart';
import 'package:calorie_app/features/activity_sync/activity_sync_state.dart';
import 'package:calorie_app/features/auth/auth_providers.dart';
import 'package:calorie_app/features/food_log/food_log_providers.dart';
import 'package:calorie_app/features/profile/profile_providers.dart';
import 'package:calorie_app/services/health_sync_service.dart';

class _FakeHealthSyncService extends HealthSyncService {
  _FakeHealthSyncService({this.permissionsGranted = true, this.weight});

  final bool permissionsGranted;
  final ({double weightKg, DateTime date})? weight;
  static const summary = DailyActivitySummary(steps: 4200, activeCaloriesBurned: 180);

  @override
  Future<void> configure() async {}

  @override
  Future<bool> requestPermissions() async => permissionsGranted;

  @override
  Future<DailyActivitySummary> todaySummary() async => summary;

  @override
  Future<({double weightKg, DateTime date})?> latestWeight() async => weight;
}

ProviderContainer _buildContainer(HealthSyncService healthSyncService) {
  final mockAuth = MockFirebaseAuth(mockUser: MockUser(uid: 'test-uid', email: 't@e.com'), signedIn: true);
  final fakeFirestore = FakeFirebaseFirestore();

  final container = ProviderContainer(
    overrides: [
      firebaseAuthProvider.overrideWithValue(mockAuth),
      firestoreProvider.overrideWithValue(fakeFirestore),
      healthSyncServiceProvider.overrideWithValue(healthSyncService),
    ],
  );
  // ActivitySyncController reads weightEntriesProvider synchronously
  // (ref.read, not watch) inside sync() — without an active listener
  // already primed, that first read can race the underlying Firestore
  // stream's first snapshot and see stale/empty data.
  container.listen(weightEntriesProvider, (_, _) {});
  return container;
}

void main() {
  test('permission denied ends in ActivitySyncFailed without saving anything', () async {
    final container = _buildContainer(_FakeHealthSyncService(permissionsGranted: false));
    addTearDown(container.dispose);
    container.listen(activitySyncControllerProvider, (_, _) {});
    await pumpEventQueue();

    await container.read(activitySyncControllerProvider.notifier).sync();

    expect(container.read(activitySyncControllerProvider), isA<ActivitySyncFailed>());
  });

  test('a new weight reading is saved and reported in ActivitySyncSuccess', () async {
    final readingDate = DateTime(2026, 5, 10);
    final container = _buildContainer(
      _FakeHealthSyncService(weight: (weightKg: 71.5, date: readingDate)),
    );
    addTearDown(container.dispose);
    container.listen(activitySyncControllerProvider, (_, _) {});
    await pumpEventQueue();

    await container.read(activitySyncControllerProvider.notifier).sync();
    await pumpEventQueue();

    final state = container.read(activitySyncControllerProvider);
    expect(state, isA<ActivitySyncSuccess>());
    expect((state as ActivitySyncSuccess).newWeightKg, 71.5);
    expect(state.summary.steps, 4200);

    final saved = container.read(weightEntriesProvider).valueOrNull ?? [];
    expect(saved, hasLength(1));
    expect(saved.single.weightKg, 71.5);
  });

  test('a weight already logged for that day (non-manual) is not saved again', () async {
    final readingDate = DateTime(2026, 5, 10);
    final container = _buildContainer(
      _FakeHealthSyncService(weight: (weightKg: 71.5, date: readingDate)),
    );
    addTearDown(container.dispose);
    container.listen(activitySyncControllerProvider, (_, _) {});
    await pumpEventQueue();

    await container
        .read(profileControllerProvider)
        .logWeight(71.5, date: readingDate, source: WeightSource.healthConnect);
    await pumpEventQueue();

    await container.read(activitySyncControllerProvider.notifier).sync();
    await pumpEventQueue();

    final state = container.read(activitySyncControllerProvider);
    expect(state, isA<ActivitySyncSuccess>());
    expect((state as ActivitySyncSuccess).newWeightKg, isNull);

    final saved = container.read(weightEntriesProvider).valueOrNull ?? [];
    expect(saved, hasLength(1));
  });
}
