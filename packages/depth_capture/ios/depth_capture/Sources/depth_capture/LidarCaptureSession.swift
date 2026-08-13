import ARKit
import CoreImage
import UIKit

/// Primary capture path on LiDAR-equipped iPhones (Pro models). Runs a
/// short-lived ARKit session with `.sceneDepth` frame semantics, waits a
/// handful of frames for auto-exposure/the depth estimator to settle (the
/// same warm-up approach used on the Android ARCore side, for symmetry),
/// then captures both the camera image and the per-pixel depth map from a
/// single ARFrame so they're perfectly aligned.
///
/// NOT validated on real hardware yet — this was written on a Windows dev
/// machine with no Mac/iOS device available locally. Needs real-device
/// validation (via the team's cloud iOS build/test service) as called out
/// in the project plan's Phase 1 exit criterion.
final class LidarCaptureSession: NSObject, ARSessionDelegate {
  private let session = ARSession()
  private var completion: ((Result<CaptureOutcome, Error>) -> Void)?
  private var frameCount = 0
  private let warmupFrameCount = 10

  static func isSupported() -> Bool {
    ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth)
  }

  func capture(completion: @escaping (Result<CaptureOutcome, Error>) -> Void) {
    self.completion = completion
    self.frameCount = 0
    let configuration = ARWorldTrackingConfiguration()
    configuration.frameSemantics = .sceneDepth
    session.delegate = self
    session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
  }

  func session(_ session: ARSession, didUpdate frame: ARFrame) {
    frameCount += 1
    guard frameCount >= warmupFrameCount else { return }
    guard let sceneDepth = frame.sceneDepth else { return }
    guard let handler = completion else { return }
    completion = nil

    session.pause()
    do {
      let outcome = try Self.buildOutcome(frame: frame, depthMap: sceneDepth.depthMap)
      handler(.success(outcome))
    } catch {
      handler(.failure(error))
    }
  }

  func session(_ session: ARSession, didFailWithError error: Error) {
    completion?(.failure(error))
    completion = nil
  }

  static func buildOutcome(frame: ARFrame, depthMap: CVPixelBuffer) throws -> CaptureOutcome {
    let photoPath = try savePhoto(pixelBuffer: frame.capturedImage)
    let depthValues = extractDepthValuesMeters(depthMap)
    let depthWidth = CVPixelBufferGetWidth(depthMap)
    let depthHeight = CVPixelBufferGetHeight(depthMap)

    // frame.camera.intrinsics is reported relative to frame.camera.imageResolution
    // (the captured photo's resolution, e.g. 1920x1440) — NOT sceneDepth.depthMap's
    // resolution (e.g. 256x192, same aspect ratio but far fewer pixels). The volume
    // calculator on the Dart side indexes depth values by depth-map pixel coordinates,
    // so the intrinsics must be rescaled into that pixel space; otherwise every
    // real-world-size-per-pixel computation downstream comes out wrong by the
    // resolution ratio (squared, once for each spatial dimension), which is exactly
    // what produced near-zero volume estimates on real hardware.
    // frame.camera.intrinsics is a simd_float3x3 in column-major order:
    // columns.0 = [fx, 0, 0], columns.1 = [0, fy, 0], columns.2 = [cx, cy, 1]
    let intrinsics = frame.camera.intrinsics
    let referenceResolution = frame.camera.imageResolution
    let scaleX = referenceResolution.width > 0 ? Double(depthWidth) / Double(referenceResolution.width) : 1
    let scaleY = referenceResolution.height > 0 ? Double(depthHeight) / Double(referenceResolution.height) : 1

    return CaptureOutcome(
      photoPath: photoPath,
      depthSource: "lidar",
      depthWidth: depthWidth,
      depthHeight: depthHeight,
      depthValuesMeters: depthValues,
      focalLengthXPx: Double(intrinsics.columns.0.x) * scaleX,
      focalLengthYPx: Double(intrinsics.columns.1.y) * scaleY,
      principalPointXPx: Double(intrinsics.columns.2.x) * scaleX,
      principalPointYPx: Double(intrinsics.columns.2.y) * scaleY
    )
  }

  /// `sceneDepth.depthMap` uses kCVPixelFormatType_DepthFloat32 — one
  /// 32-bit float (meters) per pixel.
  static func extractDepthValuesMeters(_ pixelBuffer: CVPixelBuffer) -> [Double] {
    CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
    defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }

    let width = CVPixelBufferGetWidth(pixelBuffer)
    let height = CVPixelBufferGetHeight(pixelBuffer)
    let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
    guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else { return [] }

    var values = [Double](repeating: 0, count: width * height)
    for y in 0..<height {
      let rowPtr = baseAddress.advanced(by: y * bytesPerRow).assumingMemoryBound(to: Float32.self)
      for x in 0..<width {
        values[y * width + x] = Double(rowPtr[x])
      }
    }
    return values
  }

  static func savePhoto(pixelBuffer: CVPixelBuffer) throws -> String {
    let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
    let context = CIContext()
    guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
      throw CaptureError.imageConversionFailed
    }
    let uiImage = UIImage(cgImage: cgImage)
    guard let jpegData = uiImage.jpegData(compressionQuality: 0.9) else {
      throw CaptureError.imageConversionFailed
    }
    let path = NSTemporaryDirectory() + "capture_\(Int(Date().timeIntervalSince1970 * 1000)).jpg"
    try jpegData.write(to: URL(fileURLWithPath: path))
    return path
  }
}
