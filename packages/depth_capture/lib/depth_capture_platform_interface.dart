import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'depth_capture_method_channel.dart';
import 'depth_capture_models.dart';

abstract class DepthCapturePlatform extends PlatformInterface {
  /// Constructs a DepthCapturePlatform.
  DepthCapturePlatform() : super(token: _token);

  static final Object _token = Object();

  static DepthCapturePlatform _instance = MethodChannelDepthCapture();

  /// The default instance of [DepthCapturePlatform] to use.
  ///
  /// Defaults to [MethodChannelDepthCapture].
  static DepthCapturePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DepthCapturePlatform] when
  /// they register themselves.
  static set instance(DepthCapturePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Reports the best depth-capture source available on this device
  /// (LiDAR / ARCore depth / portrait dual-camera / reference-object only).
  Future<CaptureCapabilities> getCaptureCapabilities() {
    throw UnimplementedError('getCaptureCapabilities() has not been implemented.');
  }

  /// Captures a photo along with a depth map when the device supports it,
  /// following the fallback order: LiDAR/ARCore depth -> portrait dual-camera
  /// depth (iOS non-Pro only) -> reference-object (plate diameter) 2D fallback.
  Future<DepthCaptureResult> capturePhotoWithDepth() {
    throw UnimplementedError('capturePhotoWithDepth() has not been implemented.');
  }
}
