import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/l10n/locale_provider.dart';
import '../../core/notifications/notification_service.dart';
import '../../l10n/app_localizations.dart';

const _enabledKey = 'reminder_enabled';
const _hourKey = 'reminder_hour';
const _minuteKey = 'reminder_minute';

class ReminderSettings {
  const ReminderSettings({required this.enabled, required this.hour, required this.minute});

  final bool enabled;
  final int hour;
  final int minute;

  static const defaults = ReminderSettings(enabled: false, hour: 20, minute: 0);
}

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

/// Local-only (SharedPreferences, not Firestore) — a reminder time is a
/// per-device setting, not something that needs to sync across a user's
/// devices the way their profile/log data does.
class ReminderSettingsNotifier extends StateNotifier<ReminderSettings> {
  ReminderSettingsNotifier(this._notificationService, this._ref) : super(ReminderSettings.defaults) {
    _load();
  }

  final NotificationService _notificationService;
  final Ref _ref;

  /// The device's chosen in-app language if the user picked one, else the
  /// system language — narrowed to one AppLocalizations actually ships,
  /// since scheduleDailyReminder has no BuildContext to resolve this from.
  Locale _resolveLocale() {
    final requested = _ref.read(localeProvider) ?? WidgetsBinding.instance.platformDispatcher.locale;
    for (final supported in AppLocalizations.supportedLocales) {
      if (supported.languageCode == requested.languageCode) return supported;
    }
    return AppLocalizations.supportedLocales.first;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final loaded = ReminderSettings(
      enabled: prefs.getBool(_enabledKey) ?? false,
      hour: prefs.getInt(_hourKey) ?? ReminderSettings.defaults.hour,
      minute: prefs.getInt(_minuteKey) ?? ReminderSettings.defaults.minute,
    );
    state = loaded;
    if (loaded.enabled) {
      await _notificationService.scheduleDailyReminder(
        hour: loaded.hour,
        minute: loaded.minute,
        locale: _resolveLocale(),
      );
    }
  }

  /// Returns false (without enabling) if the OS notification permission
  /// was denied — the UI should tell the user why nothing changed.
  Future<bool> setEnabled(bool enabled) async {
    if (enabled) {
      final granted = await _notificationService.requestPermission();
      if (!granted) return false;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);
    state = ReminderSettings(enabled: enabled, hour: state.hour, minute: state.minute);
    if (enabled) {
      await _notificationService.scheduleDailyReminder(
        hour: state.hour,
        minute: state.minute,
        locale: _resolveLocale(),
      );
    } else {
      await _notificationService.cancelDailyReminder();
    }
    return true;
  }

  Future<void> setTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hourKey, hour);
    await prefs.setInt(_minuteKey, minute);
    state = ReminderSettings(enabled: state.enabled, hour: hour, minute: minute);
    if (state.enabled) {
      await _notificationService.scheduleDailyReminder(hour: hour, minute: minute, locale: _resolveLocale());
    }
  }
}

final reminderSettingsProvider = StateNotifierProvider<ReminderSettingsNotifier, ReminderSettings>((ref) {
  return ReminderSettingsNotifier(ref.watch(notificationServiceProvider), ref);
});
