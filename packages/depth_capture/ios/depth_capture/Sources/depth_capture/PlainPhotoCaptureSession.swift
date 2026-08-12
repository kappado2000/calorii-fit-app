import AVFoundation

/// Last-resort fallback: a plain photo capture with no depth data at all,
/// for the rare iOS device with neither LiDAR nor a dual/dual-wide back
/// camera. Reports referenceObjectOnly, same as the Android fallback tier.
final class PlainPhotoCaptureSession: NSObject, AVCapturePhotoCaptureDelegate {
  private let captureSession = AVCaptureSession()
  private let photoOutput = AVCapturePhotoOutput()
  private var completion: ((Result<CaptureOutcome, Error>) -> Void)?

  func capture(completion: @escaping (Result<CaptureOutcome, Error>) -> Void) {
    self.completion = completion

    captureSession.beginConfiguration()
    captureSession.sessionPreset = .photo

    guard
      let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
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
    captureSession.commitConfiguration()
    captureSession.startRunning()

    photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
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
    guard let photoData = photo.fileDataRepresentation() else {
      handler(.failure(CaptureError.imageConversionFailed))
      return
    }
    do {
      let path = NSTemporaryDirectory() + "capture_\(Int(Date().timeIntervalSince1970 * 1000)).jpg"
      try photoData.write(to: URL(fileURLWithPath: path))
      handler(
        .success(
          CaptureOutcome(
            photoPath: path,
            depthSource: "referenceObjectOnly",
            depthWidth: 0,
            depthHeight: 0,
            depthValuesMeters: [],
            focalLengthXPx: 0,
            focalLengthYPx: 0,
            principalPointXPx: 0,
            principalPointYPx: 0,
            referenceObjectScaleHint: 30
          )))
    } catch {
      handler(.failure(error))
    }
  }
}
