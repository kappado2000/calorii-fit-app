import Foundation

enum CaptureError: Error {
  case noCameraAvailable
  case imageConversionFailed
  case timedOut
}

/// Shared result shape produced by each capture strategy (LiDAR / portrait
/// dual-camera / plain fallback), converted to the Flutter method-channel
/// map in DepthCapturePlugin.
struct CaptureOutcome {
  let photoPath: String
  let depthSource: String
  let depthWidth: Int
  let depthHeight: Int
  let depthValuesMeters: [Double]
  let focalLengthXPx: Double
  let focalLengthYPx: Double
  let principalPointXPx: Double
  let principalPointYPx: Double
  var referenceObjectScaleHint: Double? = nil

  func toFlutterMap() -> [String: Any?] {
    var map: [String: Any?] = [
      "photoPath": photoPath,
      "depthSource": depthSource,
    ]
    if depthWidth > 0 && depthHeight > 0 {
      map["depthMap"] = [
        "widthPx": depthWidth,
        "heightPx": depthHeight,
        "depthValuesMeters": depthValuesMeters,
        "filePath": photoPath,
      ]
      map["intrinsics"] = [
        "focalLengthXPx": focalLengthXPx,
        "focalLengthYPx": focalLengthYPx,
        "principalPointXPx": principalPointXPx,
        "principalPointYPx": principalPointYPx,
      ]
    }
    if let hint = referenceObjectScaleHint {
      map["referenceObjectScaleHint"] = hint
    }
    return map
  }
}
