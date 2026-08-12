// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:depth_capture/depth_capture.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getCaptureCapabilities test', (WidgetTester tester) async {
    final DepthCapture plugin = DepthCapture();
    final capabilities = await plugin.getCaptureCapabilities();
    // The result depends on the host device running the test, so just assert
    // that a valid enum value came back over the channel.
    expect(DepthSource.values.contains(capabilities.bestAvailableSource), true);
  });
}
