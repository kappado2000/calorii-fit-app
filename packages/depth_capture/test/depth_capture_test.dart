import 'package:flutter_test/flutter_test.dart';
import 'package:depth_capture/depth_capture.dart';
import 'package:depth_capture/depth_capture_platform_interface.dart';
import 'package:depth_capture/depth_capture_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDepthCapturePlatform
    with MockPlatformInterfaceMixin
    implements DepthCapturePlatform {
  @override
  Future<CaptureCapabilities> getCaptureCapabilities() =>
      Future.value(const CaptureCapabilities(bestAvailableSource: DepthSource.lidar));

  @override
  Future<DepthCaptureResult> capturePhotoWithDepth() => Future.value(
    const DepthCaptureResult(photoPath: '/tmp/photo.jpg', depthSource: DepthSource.lidar),
  );
}

void main() {
  final DepthCapturePlatform initialPlatform = DepthCapturePlatform.instance;

  test('$MethodChannelDepthCapture is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDepthCapture>());
  });

  test('getCaptureCapabilities', () async {
    DepthCapture depthCapturePlugin = DepthCapture();
    MockDepthCapturePlatform fakePlatform = MockDepthCapturePlatform();
    DepthCapturePlatform.instance = fakePlatform;

    final capabilities = await depthCapturePlugin.getCaptureCapabilities();
    expect(capabilities.bestAvailableSource, DepthSource.lidar);
  });

  test('capturePhotoWithDepth', () async {
    DepthCapture depthCapturePlugin = DepthCapture();
    MockDepthCapturePlatform fakePlatform = MockDepthCapturePlatform();
    DepthCapturePlatform.instance = fakePlatform;

    final result = await depthCapturePlugin.capturePhotoWithDepth();
    expect(result.photoPath, '/tmp/photo.jpg');
  });
}
