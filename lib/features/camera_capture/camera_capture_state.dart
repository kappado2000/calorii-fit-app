import 'package:depth_capture/depth_capture.dart';

import '../../data/models/analyzed_food_item.dart';
import '../../domain/usecases/volume_to_calorie_calculator.dart';

/// One analyzed item paired with its locally-computed grams/calories —
/// what the confirmation screen actually edits (see project plan: Claude
/// identifies, the app computes numbers, the user corrects both).
class ConfirmationItem {
  ConfirmationItem({required this.analyzed, required this.baseEstimate, this.portionFactor = 1.0});

  final AnalyzedFoodItem analyzed;
  final FoodEstimate baseEstimate;
  final double portionFactor;

  FoodEstimate get estimate => baseEstimate.scaledByPortionFactor(portionFactor);

  ConfirmationItem copyWithPortionFactor(double factor) {
    return ConfirmationItem(analyzed: analyzed, baseEstimate: baseEstimate, portionFactor: factor);
  }
}

sealed class CameraCaptureState {}

class CaptureIdle extends CameraCaptureState {}

class CaptureInProgress extends CameraCaptureState {}

class AnalyzingPhoto extends CameraCaptureState {
  AnalyzingPhoto(this.capture);
  final DepthCaptureResult capture;
}

class AwaitingConfirmation extends CameraCaptureState {
  AwaitingConfirmation({required this.capture, required this.mixedPlateDetected, required this.items});

  final DepthCaptureResult capture;
  final bool mixedPlateDetected;
  final List<ConfirmationItem> items;
}

/// Distinguishes *why* capture/analysis failed so the UI can show a
/// friendly, correctly-localized message instead of a raw exception
/// string — [quotaExceeded] and [unauthenticated] in particular used to
/// leak the Cloud Function's hardcoded Romanian error text verbatim to
/// users of every other locale.
enum CaptureFailureReason { quotaExceeded, unauthenticated, network, unknown }

class CaptureFailed extends CameraCaptureState {
  CaptureFailed(this.message, {this.reason = CaptureFailureReason.unknown});

  /// Raw technical detail — only ever shown to the user when [reason] is
  /// [CaptureFailureReason.unknown], as a last-resort fallback.
  final String message;
  final CaptureFailureReason reason;
}
