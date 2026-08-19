import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

/// Pushes today's calorie summary to the home-screen widget (Android:
/// CalorieWidgetProvider.kt, iOS: the CalorieWidget WidgetKit extension).
/// Keys here are a manually-kept contract with both native sides — there's
/// no shared schema, so a key rename here needs a matching rename on both
/// platforms.
class HomeWidgetService {
  const HomeWidgetService();

  // Must match ios/CalorieWidgetExtension's App Group entitlement and
  // ios/Runner/Runner.entitlements exactly, or the widget extension reads
  // an empty container and always shows "0 / 0 kcal".
  static const _iosAppGroupId = 'group.com.kappa.calorieapp.calorie_app.widget';
  static const _consumedKey = 'consumed_kcal';
  static const _targetKey = 'target_kcal';
  static const _androidProviderName = 'CalorieWidgetProvider';
  static const _iosWidgetName = 'CalorieWidget';

  Future<void> update({required double consumedKcal, required double? targetKcal}) async {
    // Idempotent and cheap — setting it on every update (rather than once
    // at app startup) means there's no separate init step to forget to
    // wire up, and no-op on Android beyond one extra platform call.
    await HomeWidget.setAppGroupId(_iosAppGroupId);
    await HomeWidget.saveWidgetData<int>(_consumedKey, consumedKcal.round());
    await HomeWidget.saveWidgetData<int>(_targetKey, targetKcal?.round() ?? 0);
    await HomeWidget.updateWidget(androidName: _androidProviderName, iOSName: _iosWidgetName);
  }
}

final homeWidgetServiceProvider = Provider<HomeWidgetService>((ref) => const HomeWidgetService());
