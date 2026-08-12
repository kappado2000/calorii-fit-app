/// Normalized (0-1) bounding box within the captured photo, top-left origin.
/// Matches the shape returned by the analyzePhoto Cloud Function.
class BoundingBox {
  const BoundingBox({required this.xMin, required this.yMin, required this.xMax, required this.yMax});

  final double xMin;
  final double yMin;
  final double xMax;
  final double yMax;

  double get width => (xMax - xMin).clamp(0, 1);
  double get height => (yMax - yMin).clamp(0, 1);

  factory BoundingBox.fromJson(Map<String, dynamic> json) {
    return BoundingBox(
      xMin: (json['xMin'] as num).toDouble(),
      yMin: (json['yMin'] as num).toDouble(),
      xMax: (json['xMax'] as num).toDouble(),
      yMax: (json['yMax'] as num).toDouble(),
    );
  }
}
