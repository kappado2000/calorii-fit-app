// Basic smoke test: verifies the app boots and shows the Phase 0
// device-capability screen without throwing.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/app.dart';

void main() {
  testWidgets('CalorieApp boots and shows the capability screen app bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CalorieApp()));
    await tester.pump();

    expect(find.text('Capabilitate captură adâncime'), findsOneWidget);
  });
}
