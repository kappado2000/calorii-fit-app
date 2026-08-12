import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'depth_capture_models.dart';
import 'depth_capture_platform_interface.dart';

/// An implementation of [DepthCapturePlatform] that uses method channels.
class MethodChannelDepthCapture extends DepthCapturePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('depth_capture');

  @override
  Future<CaptureCapabilities> getCaptureCapabilities() async {
    final result = await methodChannel.invokeMethod<Map<Object?, Object?>>(
      'getCaptureCapabilities',
    );
    if (result == null) {
      return const CaptureCapabilities(bestAvailableSource: DepthSource.none);
    }
    return CaptureCapabilities.fromMap(result);
  }

  @override
  Future<DepthCaptureResult> capturePhotoWithDepth() async {
    final result = await methodChannel.invokeMethod<Map<Object?, Object?>>(
      'capturePhotoWithDepth',
    );
    if (result == null) {
      throw PlatformException(
        code: 'capture_failed',
        message: 'Native capture returned no result.',
      );
    }
    return DepthCaptureResult.fromMap(result);
  }
}
