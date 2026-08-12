import 'package:depth_capture/depth_capture.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Thin Dart-side wrapper around the native [DepthCapture] plugin, kept
/// separate so features depend on this interface rather than the plugin
/// package directly (matches the boundary described in the project plan —
/// if the native-dual checkpoint decision requires rewriting capture, this
/// is the file features are shielded behind).
class DepthCaptureChannel {
  DepthCaptureChannel(this._plugin);

  final DepthCapture _plugin;

  Future<CaptureCapabilities> getCaptureCapabilities() {
    return _plugin.getCaptureCapabilities();
  }

  Future<DepthCaptureResult> capturePhotoWithDepth() {
    return _plugin.capturePhotoWithDepth();
  }
}

final depthCaptureChannelProvider = Provider<DepthCaptureChannel>((ref) {
  return DepthCaptureChannel(DepthCapture());
});
