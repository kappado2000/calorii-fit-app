import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeCodeKey = 'locale_code';

/// null = follow the device's system language, falling back to Romanian
/// (the app's default) if the system language isn't one of
/// AppLocalizations.supportedLocales. An explicit pick persists locally,
/// per device — this is a device setting, not something synced to Firestore.
class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeCodeKey);
    if (code != null) state = Locale(code);
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_localeCodeKey);
    } else {
      await prefs.setString(_localeCodeKey, locale.languageCode);
    }
    state = locale;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) => LocaleNotifier());
