import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeModeKey = 'theme_mode';

/// Persists the user's explicit light/dark choice, per device — mirrors
/// [LocaleNotifier]'s pattern. Defaults to [ThemeMode.system] (follow the
/// phone's setting) until the user picks something else from the menu.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_themeModeKey);
    for (final mode in ThemeMode.values) {
      if (mode.name == name) {
        state = mode;
        return;
      }
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
    state = mode;
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) => ThemeModeNotifier());
