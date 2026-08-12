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

      // TODO(Phase 1 real-device validation): AVCameraCalibrationData's
      // intrinsicMatrix is referenced against
      // intrinsicMatrixReferenceDimensions, which may differ from the
      // depth map's own pixel dimensions — needs a scale-factor correction
      // (referenceDims -> depthMap dims) verified on real hardware before
      // this path's volume math can be trusted at the same tier as LiDAR.
      let intrinsicMatrix = depthData.cameraCalibrationData?.intrinsicMatrix
      let outcome = CaptureOutcome(
        photoPath: path,
        depthSource: "portraitDualCamera",
        depthWidth: CVPixelBufferGetWidth(depthMap),
        depthHeight: CVPixelBufferGetHeight(depthMap),
        depthValuesMeters: depthValues,
        focalLengthXPx: intrinsicMatrix.map { Double($0.columns.0.x) } ?? 0,
        focalLengthYPx: intrinsicMatrix.map { Double($0.columns.1.y) } ?? 0,
        principalPointXPx: intrinsicMatrix.map { Double($0.columns.2.x) } ?? 0,
        principalPointYPx: intrinsicMatrix.map { Double($0.columns.2.y) } ?? 0
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
