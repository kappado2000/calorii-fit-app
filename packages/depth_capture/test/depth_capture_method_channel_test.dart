import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:depth_capture/depth_capture_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDepthCapture platform = MethodChannelDepthCapture();
  const MethodChannel channel = MethodChannel('depth_capture');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'getCaptureCapabilities':
              return {'bestAvailableSource': 'lidar'};
            case 'capturePhotoWithDepth':
              return {'photoPath': '/tmp/photo.jpg', 'depthSource': 'lidar'};
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getCaptureCapabilities', () async {
    final capabilities = await platform.getCaptureCapabilities();
    expect(capabilities.bestAvailableSource.name, 'lidar');
  });

  test('capturePhotoWithDepth', () async {
    final result = await platform.capturePhotoWithDepth();
    expect(result.photoPath, '/tmp/photo.jpg');
  });
}
