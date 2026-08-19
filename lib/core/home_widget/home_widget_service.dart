import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

/// Pushes today's calorie summary to the home-screen widget (Android:
/// CalorieWidgetProvider.kt, iOS: the CalorieWidget WidgetKit extension).
/// Keys here are a manually-kept contract with both native sides — there's
/// no shared schema, so a key rename here needs a matching rename on both
/// platforms.
class HomeWidgetService {
  const HomeWidgetService();

  static const _consumedKey = 'consumed_kcal';
  static const _targetKey = 'target_kcal';
  static const _androidProviderName = 'CalorieWidgetProvider';
  static const _iosWidgetName = 'CalorieWidget';

  Future<void> update({required double consumedKcal, required double? targetKcal}) async {
    await HomeWidget.saveWidgetData<int>(_consumedKey, consumedKcal.round());
    await HomeWidget.saveWidgetData<int>(_targetKey, targetKcal?.round() ?? 0);
    await HomeWidget.updateWidget(androidName: _androidProviderName, iOSName: _iosWidgetName);
  }
}

final homeWidgetServiceProvider = Provider<HomeWidgetService>((ref) => const HomeWidgetService());
