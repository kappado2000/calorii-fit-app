import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../food_confirmation/food_confirmation_screen.dart';
import 'camera_capture_controller.dart';
import 'camera_capture_state.dart';

class CameraCaptureScreen extends ConsumerStatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  ConsumerState<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends ConsumerState<CameraCaptureScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen<CameraCaptureState>(cameraCaptureControllerProvider, (previous, next) {
      if (next is AwaitingConfirmation) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => FoodConfirmationScreen(result: next)))
            .then((_) => ref.read(cameraCaptureControllerProvider.notifier).reset());
      }
    });

    final state = ref.watch(cameraCaptureControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fotografiază farfuria')),
      body: Center(child: _buildBody(context, state)),
    );
  }

  Widget _buildBody(BuildContext context, CameraCaptureState state) {
    return switch (state) {
      CaptureIdle() => _IdlePrompt(
        onCapture: () => ref.read(cameraCaptureControllerProvider.notifier).captureAndAnalyze(),
      ),
      CaptureInProgress() => const _StatusMessage(message: 'Se capturează fotografia și adâncimea…'),
      AnalyzingPhoto() => const _StatusMessage(message: 'Se identifică alimentele…'),
      AwaitingConfirmation() => const _StatusMessage(message: 'Gata — se deschide confirmarea…'),
      CaptureFailed(:final message) => _ErrorPrompt(
        message: message,
        onRetry: () => ref.read(cameraCaptureControllerProvider.notifier).captureAndAnalyze(),
      ),
    };
  }
}

class _IdlePrompt extends StatelessWidget {
  const _IdlePrompt({required this.onCapture});

  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.restaurant, size: 72, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        const Text('Fotografiază farfuria pentru o estimare automată a caloriilor'),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: onCapture,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Fotografiază'),
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 56, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 12),
          Text('Nu am putut analiza fotografia:\n$message', textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton(onPressed: onRetry, child: const Text('Încearcă din nou')),
        ],
      ),
    );
  }
}
