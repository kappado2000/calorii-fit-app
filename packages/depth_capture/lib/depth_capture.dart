import 'depth_capture_models.dart';
import 'depth_capture_platform_interface.dart';

export 'depth_capture_models.dart';

class DepthCapture {
  /// Reports the best depth-capture source available on this device.
  Future<CaptureCapabilities> getCaptureCapabilities() {
    return DepthCapturePlatform.instance.getCaptureCapabilities();
  }

  /// Captures a photo along with depth data, following the native fallback
  /// order (see [DepthCapturePlatform.capturePhotoWithDepth]).
  Future<DepthCaptureResult> capturePhotoWithDepth() {
    return DepthCapturePlatform.instance.capturePhotoWithDepth();
  }
}
