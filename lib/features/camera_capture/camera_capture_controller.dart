import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/cloud_functions/analyze_photo_api_client.dart';
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
        state = CaptureFailed('Not authenticated', reason: CaptureFailureReason.unauthenticated);
        return;
      }
      // Read from the provider, not instantiated here directly — lets
      // tests substitute a fake HTTP client via ProviderScope overrides
      // (see camera_capture_controller_test.dart), and means the client
      // (and its underlying http.Client) is shared/reused across calls
      // rather than a fresh one per capture, so it must never be disposed
      // here — analyzePhotoApiClientProvider owns its lifecycle.
      final apiClient = _ref.read(analyzePhotoApiClientProvider);
      final analysis = await apiClient.analyze(File(capture.photoPath), idToken: idToken);

      final items = analysis.items.map((item) {
        final estimate = _calculator.estimate(
          capture: capture,
          boundingBox: item.boundingBox,
          densityCategory: item.densityCategory,
          nutritionMatch: item.nutritionMatch,
        );
        return ConfirmationItem(analyzed: item, baseEstimate: estimate);
      }).toList();

      state = AwaitingConfirmation(
        capture: capture,
        mixedPlateDetected: analysis.mixedPlateDetected,
        items: items,
      );
    } on AnalyzePhotoException catch (e) {
      if (e.isQuotaExceeded) {
        state = CaptureFailed(e.message, reason: CaptureFailureReason.quotaExceeded);
      } else if (e.isUnauthenticated) {
        state = CaptureFailed(e.message, reason: CaptureFailureReason.unauthenticated);
      } else {
        state = CaptureFailed(e.message);
      }
    } on SocketException catch (e) {
      state = CaptureFailed(e.toString(), reason: CaptureFailureReason.network);
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
