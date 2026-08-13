import AVFoundation
import UIKit

/// Fallback path for non-Pro iPhones without LiDAR: uses the dual/dual-wide
/// back camera's portrait-mode depth data delivery via AVCapturePhotoOutput.
/// Materially noisier than LiDAR — see project plan Risk #3 (iOS accuracy
/// is itself bimodal; the depth-source badge must stay visible on iOS too).
///
/// NOT validated on real hardware yet — written without Mac/iOS access; the
/// intrinsic-matrix reference-dimensions scaling below is a known open
/// nuance that needs checking against `AVCameraCalibrationData` behavior on
/// a real device before this path is trusted (see inline TODO).
final class PortraitDepthCaptureSession: NSObject, AVCapturePhotoCaptureDelegate {
  private let captureSession = AVCaptureSession()
  private let photoOutput = AVCapturePhotoOutput()
  private var completion: ((Result<CaptureOutcome, Error>) -> Void)?

  static func isSupported() -> Bool {
    AVCaptureDevice.DiscoverySession(
      deviceTypes: [.builtInDualCamera, .builtInDualWideCamera],
      mediaType: .video,
      position: .back
    ).devices.first != nil
  }

  func capture(completion: @escaping (Result<CaptureOutcome, Error>) -> Void) {
    self.completion = completion

    captureSession.beginConfiguration()
    captureSession.sessionPreset = .photo

    guard
      let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
        ?? AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back),
      let input = try? AVCaptureDeviceInput(device: device),
      captureSession.canAddInput(input)
    else {
      captureSession.commitConfiguration()
      completion(.failure(CaptureError.noCameraAvailable))
      return
    }
    captureSession.addInput(input)

    guard captureSession.canAddOutput(photoOutput) else {
      captureSession.commitConfiguration()
      completion(.failure(CaptureError.noCameraAvailable))
      return
    }
    captureSession.addOutput(photoOutput)
    photoOutput.isDepthDataDeliveryEnabled = photoOutput.isDepthDataDeliverySupported
    captureSession.commitConfiguration()

    captureSession.startRunning()

    let settings = AVCapturePhotoSettings()
    settings.isDepthDataDeliveryEnabled = photoOutput.isDepthDataDeliveryEnabled
    photoOutput.capturePhoto(with: settings, delegate: self)
  }

  func photoOutput(
    _ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?
  ) {
    captureSession.stopRunning()
    guard let handler = completion else { return }
    completion = nil

    if let error = error {
      handler(.failure(error))
      return
    }

    do {
      guard let photoData = photo.fileDataRepresentation() else {
        throw CaptureError.imageConversionFailed
      }
      let path = NSTemporaryDirectory() + "capture_\(Int(Date().timeIntervalSince1970 * 1000)).jpg"
      try photoData.write(to: URL(fileURLWithPath: path))

      guard let depthData = photo.depthData else {
        handler(.success(Self.plainOutcome(photoPath: path)))
        return
      }

      let converted = depthData.converting(toDepthDataType: kCVPixelFormatType_DepthFloat32)
      let depthMap = converted.depthDataMap
      let depthValues = LidarCaptureSession.extractDepthValuesMeters(depthMap)
      let depthWidth = CVPixelBufferGetWidth(depthMap)
      let depthHeight = CVPixelBufferGetHeight(depthMap)

      // Confirmed on real hardware (same bug as the LiDAR path, see its
      // comment): AVCameraCalibrationData's intrinsicMatrix is referenced
      // against intrinsicMatrixReferenceDimensions (the photo's resolution),
      // not the depth map's own — must be rescaled into depth-map pixel
      // space or the volume estimate comes out near-zero.
      let intrinsicMatrix = depthData.cameraCalibrationData?.intrinsicMatrix
      let referenceDimensions = depthData.cameraCalibrationData?.intrinsicMatrixReferenceDimensions
      let scaleX =
        (referenceDimensions?.width ?? 0) > 0
        ? Double(depthWidth) / Double(referenceDimensions!.width) : 1
      let scaleY =
        (referenceDimensions?.height ?? 0) > 0
        ? Double(depthHeight) / Double(referenceDimensions!.height) : 1
      let outcome = CaptureOutcome(
        photoPath: path,
        depthSource: "portraitDualCamera",
        depthWidth: depthWidth,
        depthHeight: depthHeight,
        depthValuesMeters: depthValues,
        focalLengthXPx: intrinsicMatrix.map { Double($0.columns.0.x) * scaleX } ?? 0,
        focalLengthYPx: intrinsicMatrix.map { Double($0.columns.1.y) * scaleY } ?? 0,
        principalPointXPx: intrinsicMatrix.map { Double($0.columns.2.x) * scaleX } ?? 0,
        principalPointYPx: intrinsicMatrix.map { Double($0.columns.2.y) * scaleY } ?? 0
      )
      handler(.success(outcome))
    } catch {
      handler(.failure(error))
    }
  }

  private static func plainOutcome(photoPath: String) -> CaptureOutcome {
    CaptureOutcome(
      photoPath: photoPath,
      depthSource: "referenceObjectOnly",
      depthWidth: 0,
      depthHeight: 0,
      depthValuesMeters: [],
      focalLengthXPx: 0,
      focalLengthYPx: 0,
      principalPointXPx: 0,
      principalPointYPx: 0,
      referenceObjectScaleHint: 30
    )
  }
}
