enum DepthSource { lidar, portraitDualCamera, arcoreDepth, referenceObjectOnly, none }

DepthSource depthSourceFromWire(String value) {
  return DepthSource.values.firstWhere(
    (source) => source.name == value,
    orElse: () => DepthSource.none,
  );
}

class CameraIntrinsics {
  const CameraIntrinsics({
    required this.focalLengthXPx,
    required this.focalLengthYPx,
    required this.principalPointXPx,
    required this.principalPointYPx,
  });

  final double focalLengthXPx;
  final double focalLengthYPx;
  final double principalPointXPx;
  final double principalPointYPx;

  factory CameraIntrinsics.fromMap(Map<Object?, Object?> map) {
    return CameraIntrinsics(
      focalLengthXPx: (map['focalLengthXPx'] as num).toDouble(),
      focalLengthYPx: (map['focalLengthYPx'] as num).toDouble(),
      principalPointXPx: (map['principalPointXPx'] as num).toDouble(),
      principalPointYPx: (map['principalPointYPx'] as num).toDouble(),
    );
  }
}

class CaptureCapabilities {
  const CaptureCapabilities({required this.bestAvailableSource});

  final DepthSource bestAvailableSource;

  factory CaptureCapabilities.fromMap(Map<Object?, Object?> map) {
    return CaptureCapabilities(
      bestAvailableSource: depthSourceFromWire(map['bestAvailableSource'] as String),
    );
  }
}

class DepthMapData {
  const DepthMapData({
    required this.widthPx,
    required this.heightPx,
    required this.depthValuesMeters,
    required this.filePath,
  });

  final int widthPx;
  final int heightPx;

  /// Row-major depth values in meters, one per pixel of the depth map
  /// (not necessarily the same resolution as the photo).
  final List<double> depthValuesMeters;

  /// Path to the raw depth map file on disk, for archival/debugging.
  final String filePath;

  factory DepthMapData.fromMap(Map<Object?, Object?> map) {
    return DepthMapData(
      widthPx: map['widthPx'] as int,
      heightPx: map['heightPx'] as int,
      depthValuesMeters: (map['depthValuesMeters'] as List)
          .map((value) => (value as num).toDouble())
          .toList(growable: false),
      filePath: map['filePath'] as String,
    );
  }
}

class DepthCaptureResult {
  const DepthCaptureResult({
    required this.photoPath,
    required this.depthSource,
    this.depthMap,
    this.intrinsics,
    this.referenceObjectScaleHint,
  });

  final String photoPath;
  final DepthSource depthSource;

  /// Null when falling back to the reference-object (plate-diameter) method.
  final DepthMapData? depthMap;

  /// Needed to convert a depth map + bounding box into a real-world volume.
  final CameraIntrinsics? intrinsics;

  /// Set only in reference-object fallback mode: an assumed real-world scale
  /// (e.g. standard plate diameter in cm) used to derive a pixel-to-cm ratio.
  final double? referenceObjectScaleHint;

  factory DepthCaptureResult.fromMap(Map<Object?, Object?> map) {
    final depthMapMap = map['depthMap'] as Map<Object?, Object?>?;
    final intrinsicsMap = map['intrinsics'] as Map<Object?, Object?>?;
    return DepthCaptureResult(
      photoPath: map['photoPath'] as String,
      depthSource: depthSourceFromWire(map['depthSource'] as String),
      depthMap: depthMapMap == null ? null : DepthMapData.fromMap(depthMapMap),
      intrinsics: intrinsicsMap == null ? null : CameraIntrinsics.fromMap(intrinsicsMap),
      referenceObjectScaleHint: (map['referenceObjectScaleHint'] as num?)?.toDouble(),
    );
  }
}
