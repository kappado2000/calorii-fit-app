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

  // Held strongly for the duration of a capture — ARSession/AVCaptureSession
  // report back to their delegate asynchronously, so the session would
  // otherwise be deallocated before that callback fires.
  private var activeLidarSession: LidarCaptureSession?
  private var activePortraitSession: PortraitDepthCaptureSession?
  private var activePlainSession: PlainPhotoCaptureSession?

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getCaptureCapabilities":
      result(["bestAvailableSource": Self.bestAvailableDepthSource()])
    case "capturePhotoWithDepth":
      capturePhotoWithDepth(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func capturePhotoWithDepth(result: @escaping FlutterResult) {
    AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
      DispatchQueue.main.async {
        guard let self = self else { return }
        guard granted else {
          result(
            FlutterError(
              code: "camera_permission_denied", message: "Camera access was denied.", details: nil))
          return
        }
        self.runBestAvailableCapture(result: result)
      }
    }
  }

  private func runBestAvailableCapture(result: @escaping FlutterResult) {
    let completion: (Result<CaptureOutcome, Error>) -> Void = { [weak self] captureResult in
      DispatchQueue.main.async {
        // Release the session now that it has reported back.
        self?.activeLidarSession = nil
        self?.activePortraitSession = nil
        self?.activePlainSession = nil
        switch captureResult {
        case .success(let outcome):
          result(outcome.toFlutterMap())
        case .failure(let error):
          result(FlutterError(code: "capture_failed", message: "\(error)", details: nil))
        }
      }
    }

    if LidarCaptureSession.isSupported() {
      let session = LidarCaptureSession()
      activeLidarSession = session
      session.capture(completion: completion)
    } else if PortraitDepthCaptureSession.isSupported() {
      let session = PortraitDepthCaptureSession()
      activePortraitSession = session
      session.capture(completion: completion)
    } else {
      let session = PlainPhotoCaptureSession()
      activePlainSession = session
      session.capture(completion: completion)
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
