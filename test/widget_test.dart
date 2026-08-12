// Basic smoke test: verifies the app boots and shows the food log (home
// screen as of Phase 1) with its three meal sections, without throwing.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:calorie_app/app.dart';

void main() {
  testWidgets('CalorieApp boots and shows the food log with all three meal sections', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const ProviderScope(child: CalorieApp()));
    await tester.pumpAndSettle();

    expect(find.text('Dimineață'), findsOneWidget);
    expect(find.text('Prânz'), findsOneWidget);
    expect(find.text('Seară'), findsOneWidget);
    expect(find.text('Total azi'), findsOneWidget);
  });
}
