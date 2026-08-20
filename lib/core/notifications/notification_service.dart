import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../l10n/app_localizations.dart';

const int _dailyReminderId = 1001;

/// Thin wrapper around flutter_local_notifications — the one daily
/// "don't forget to log" reminder is the only notification this app
/// sends today, so there's no need for a channel/type registry yet.
class NotificationService {
  NotificationService() : _plugin = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _timezoneReady = false;

  Future<void> _ensureTimezone() async {
    if (_timezoneReady) return;
    tz_data.initializeTimeZones();
    final localTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimezone.identifier));
    _timezoneReady = true;
  }

  Future<bool> requestPermission() async {
    final androidGranted = await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    final iosGranted = await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return (androidGranted ?? true) && (iosGranted ?? true);
  }

  Future<void> _init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
  }

  /// Schedules (or reschedules) the daily log reminder for [hour]:[minute]
  /// local time, repeating every day — `matchDateTimeComponents: time` is
  /// what makes it recurring rather than a one-shot. [locale] must be one
  /// of AppLocalizations.supportedLocales (resolve it first — see
  /// reminder_settings_providers.dart) since this runs with no
  /// BuildContext to read the locale from directly.
  Future<void> scheduleDailyReminder({required int hour, required int minute, required Locale locale}) async {
    await _init();
    await _ensureTimezone();
    final l10n = await AppLocalizations.delegate.load(locale);
    await _plugin.zonedSchedule(
      id: _dailyReminderId,
      title: l10n.dailyReminderTitle,
      body: l10n.dailyReminderBody,
      scheduledDate: _nextInstanceOf(hour, minute),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_log_reminder',
          l10n.dailyReminderChannelName,
          channelDescription: l10n.dailyReminderChannelDescription,
          importance: Importance.defaultImportance,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyReminder() async {
    await _init();
    await _plugin.cancel(id: _dailyReminderId);
  }

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
