import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../food_confirmation/food_confirmation_screen.dart';
import 'camera_capture_controller.dart';
import 'camera_capture_state.dart';

/// Shows a live camera preview (via the `camera` package) so the user can
/// actually frame the plate before capturing — the native depth_capture
/// plugin itself has no preview surface of its own, it only exposes a
/// single blocking "capture now" call. So the hand-off on shutter press is:
/// dispose this preview's CameraController (release the camera hardware)
/// -> only then invoke depth_capture's capturePhotoWithDepth, which opens
/// its own capture session (ARKit/AVFoundation or ARCore) to do the actual
/// depth-aware capture. Two camera sessions can't run at once, hence the
/// brief hand-off gap covered by a loading state.
class CameraCaptureScreen extends ConsumerStatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  ConsumerState<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends ConsumerState<CameraCaptureScreen> {
  CameraController? _previewController;
  bool _initializingPreview = false;
  String? _previewError;

  @override
  void initState() {
    super.initState();
    _initPreview();
  }

  Future<void> _initPreview() async {
    setState(() {
      _initializingPreview = true;
      _previewError = null;
    });
    try {
      final cameras = await availableCameras();
      if (!mounted) return;
      if (cameras.isEmpty) {
        throw StateError(AppLocalizations.of(context).cameraNoneAvailable);
      }
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _previewController = controller;
        _initializingPreview = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _previewError = e.toString();
        _initializingPreview = false;
      });
    }
  }

  Future<void> _onShutterPressed() async {
    final controller = _previewController;
    setState(() => _previewController = null);
    await controller?.dispose();
    if (!mounted) return;
    await ref.read(cameraCaptureControllerProvider.notifier).captureAndAnalyze();
  }

  Future<void> _retry() async {
    ref.read(cameraCaptureControllerProvider.notifier).reset();
    await _initPreview();
  }

  @override
  void dispose() {
    _previewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CameraCaptureState>(cameraCaptureControllerProvider, (previous, next) {
      if (next is AwaitingConfirmation) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => FoodConfirmationScreen(result: next)))
            .then((_) => _retry());
      }
    });

    final state = ref.watch(cameraCaptureControllerProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cameraCaptureTitle)),
      body: _buildBody(context, state, l10n),
    );
  }

  Widget _buildBody(BuildContext context, CameraCaptureState state, AppLocalizations l10n) {
    if (state is! CaptureIdle) {
      return Center(
        child: switch (state) {
          CaptureInProgress() => _StatusMessage(message: l10n.cameraCapturingStatus),
          AnalyzingPhoto() => _StatusMessage(message: l10n.cameraAnalyzingStatus),
          AwaitingConfirmation() => _StatusMessage(message: l10n.cameraConfirmationOpeningStatus),
          CaptureFailed(:final message) => _ErrorPrompt(message: message, onRetry: _retry),
          CaptureIdle() => const SizedBox.shrink(),
        },
      );
    }

    if (_previewError != null) {
      return Center(
        child: _ErrorPrompt(message: _previewError!, onRetry: _retry),
      );
    }
    final controller = _previewController;
    if (_initializingPreview || controller == null || !controller.value.isInitialized) {
      return Center(child: _StatusMessage(message: l10n.cameraStartingStatus));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(controller),
        Positioned(
          left: 0,
          right: 0,
          bottom: 32,
          child: Center(
            child: FloatingActionButton.large(
              onPressed: _onShutterPressed,
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 16,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l10n.cameraFrameHint,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(message, textAlign: TextAlign.center),
      ],
    );
  }
}

class _ErrorPrompt extends StatelessWidget {
  const _ErrorPrompt({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 56, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 12),
          Text(l10n.cameraErrorPrefixed(message), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
