import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:calorie_app/core/notifications/notification_service.dart';
import 'package:calorie_app/features/reminders/reminder_settings_providers.dart';

class _FakeNotificationService extends NotificationService {
  _FakeNotificationService({this.permissionGranted = true});

  final bool permissionGranted;
  int scheduleCallCount = 0;
  int cancelCallCount = 0;
  int? lastScheduledHour;
  int? lastScheduledMinute;

  @override
  Future<bool> requestPermission() async => permissionGranted;

  @override
  Future<void> scheduleDailyReminder({required int hour, required int minute, required Locale locale}) async {
    scheduleCallCount++;
    lastScheduledHour = hour;
    lastScheduledMinute = minute;
  }

  @override
  Future<void> cancelDailyReminder() async {
    cancelCallCount++;
  }
}

ProviderContainer _buildContainer(_FakeNotificationService service) {
  return ProviderContainer(
    overrides: [notificationServiceProvider.overrideWithValue(service)],
  );
}

void main() {
  // ReminderSettingsNotifier reads SharedPreferences.getInstance(), which
  // needs ServicesBinding initialized — not automatic for a plain test(),
  // only for testWidgets() — plus a mock store, reset before each test so
  // one test's persisted values can't leak into the next.
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('setEnabled(true) requests permission and schedules the reminder', () async {
    final service = _FakeNotificationService();
    final container = _buildContainer(service);
    addTearDown(container.dispose);
    await pumpEventQueue();

    final granted = await container.read(reminderSettingsProvider.notifier).setEnabled(true);

    expect(granted, isTrue);
    expect(container.read(reminderSettingsProvider).enabled, isTrue);
    expect(service.scheduleCallCount, 1);
  });

  test('setEnabled(true) returns false and does not persist when permission is denied', () async {
    final service = _FakeNotificationService(permissionGranted: false);
    final container = _buildContainer(service);
    addTearDown(container.dispose);
    await pumpEventQueue();

    final granted = await container.read(reminderSettingsProvider.notifier).setEnabled(true);

    expect(granted, isFalse);
    expect(container.read(reminderSettingsProvider).enabled, isFalse);
    expect(service.scheduleCallCount, 0);
  });

  test('setEnabled(false) cancels the scheduled reminder', () async {
    final service = _FakeNotificationService();
    final container = _buildContainer(service);
    addTearDown(container.dispose);
    await pumpEventQueue();
    await container.read(reminderSettingsProvider.notifier).setEnabled(true);

    await container.read(reminderSettingsProvider.notifier).setEnabled(false);

    expect(container.read(reminderSettingsProvider).enabled, isFalse);
    expect(service.cancelCallCount, 1);
  });

  test('setTime reschedules with the new time only while enabled', () async {
    final service = _FakeNotificationService();
    final container = _buildContainer(service);
    addTearDown(container.dispose);
    await pumpEventQueue();

    // Disabled: setTime persists the time but must not schedule anything.
    await container.read(reminderSettingsProvider.notifier).setTime(7, 30);
    expect(service.scheduleCallCount, 0);
    expect(container.read(reminderSettingsProvider).hour, 7);

    // Enabled: now setTime should reschedule with the new time.
    await container.read(reminderSettingsProvider.notifier).setEnabled(true);
    final countAfterEnable = service.scheduleCallCount;
    await container.read(reminderSettingsProvider.notifier).setTime(21, 15);

    expect(service.scheduleCallCount, countAfterEnable + 1);
    expect(service.lastScheduledHour, 21);
    expect(service.lastScheduledMinute, 15);
  });
}
