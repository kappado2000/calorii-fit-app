import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/food_log/food_log_providers.dart';
import '../../features/profile/profile_providers.dart';
import 'home_widget_service.dart';

/// Kept alive by a `ref.watch` in FoodLogScreen (always mounted while
/// signed in) — every time today's logged calories or target changes,
/// pushes the new numbers to the home-screen widget. This is a "sync to
/// an external system" provider: its return value (void) is never read,
/// only its side effect matters.
final homeWidgetSyncProvider = Provider<void>((ref) {
  final today = normalizeDate(DateTime.now());
  final entries = ref.watch(dailyLogProvider(today));
  final consumed = entries.fold<double>(0, (sum, entry) => sum + entry.calories);
  final target = ref.watch(tdeeResultProvider)?.calorieTarget;

  // A device without the plugin's platform channel registered (desktop/web
  // dev runs) would throw here — the widget sync is a nice-to-have, never
  // worth crashing the food log screen over.
  ref
      .watch(homeWidgetServiceProvider)
      .update(consumedKcal: consumed, targetKcal: target)
      .catchError((Object error) => debugPrint('Home widget sync failed: $error'));
});
