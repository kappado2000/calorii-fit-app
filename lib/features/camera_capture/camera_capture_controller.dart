import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/cloud_functions/analyze_photo_api_client.dart';
import '../../data/models/analyzed_food_item.dart';
import '../../domain/usecases/volume_to_calorie_calculator.dart';
import '../../platform/depth_capture_channel.dart';
import '../auth/auth_providers.dart';
import 'camera_capture_state.dart';

/// Drives the core Phase 1 pipeline end to end: capture (native depth
/// plugin) -> identify (analyzePhoto Cloud Function) -> locally compute
/// grams/calories per item -> hand off to the confirmation screen. Never
/// auto-saves — the confirmation screen owns the final save step.
class CameraCaptureController extends StateNotifier<CameraCaptureState> {
  CameraCaptureController(this._ref) : super(CaptureIdle());

  final Ref _ref;
  final _calculator = const VolumeToCalorieCalculator();

  Future<void> captureAndAnalyze() async {
    state = CaptureInProgress();
    try {
      final capture = await _ref.read(depthCaptureChannelProvider).capturePhotoWithDepth();

      state = AnalyzingPhoto(capture);
      final idToken = await _ref.read(firebaseAuthProvider).currentUser?.getIdToken();
      if (idToken == null) {
        state = CaptureFailed('Trebuie să fii autentificat pentru a analiza o fotografie.');
        return;
      }
      final apiClient = AnalyzePhotoApiClient();
      final AnalyzePhotoResponse analysis;
      try {
        analysis = await apiClient.analyze(File(capture.photoPath), idToken: idToken);
      } finally {
        apiClient.dispose();
      }

      final items = analysis.items.map((item) {
        final estimate = _calculator.estimate(
          capture: capture,
          boundingBox: item.boundingBox,
          densityCategory: item.densityCategory,
        );
        return ConfirmationItem(analyzed: item, baseEstimate: estimate);
      }).toList();

      state = AwaitingConfirmation(
        capture: capture,
        mixedPlateDetected: analysis.mixedPlateDetected,
        items: items,
      );
    } catch (e) {
      state = CaptureFailed(e.toString());
    }
  }

  void reset() => state = CaptureIdle();
}

final cameraCaptureControllerProvider =
    StateNotifierProvider.autoDispose<CameraCaptureController, CameraCaptureState>((ref) {
      return CameraCaptureController(ref);
    });
