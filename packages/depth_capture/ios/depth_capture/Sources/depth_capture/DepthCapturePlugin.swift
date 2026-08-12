import ARKit
import AVFoundation
import Flutter
import UIKit

public class DepthCapturePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "depth_capture", binaryMessenger: registrar.messenger())
    let instance = DepthCapturePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getCaptureCapabilities":
      result(["bestAvailableSource": Self.bestAvailableDepthSource()])
    case "capturePhotoWithDepth":
      // Phase 1: implement LiDAR sceneDepth / AVDepthData capture.
      // Phase 0 only wires the capability check end-to-end.
      result(
        FlutterError(
          code: "not_implemented",
          message: "capturePhotoWithDepth is implemented in Phase 1",
          details: nil
        ))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Fallback order: LiDAR sceneDepth -> portrait-mode dual-camera depth -> none.
  private static func bestAvailableDepthSource() -> String {
    if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
      return "lidar"
    }
    if AVCaptureDevice.DiscoverySession(
      deviceTypes: [.builtInDualCamera, .builtInDualWideCamera],
      mediaType: .video,
      position: .back
    ).devices.first != nil {
      return "portraitDualCamera"
    }
    return "referenceObjectOnly"
  }
}
