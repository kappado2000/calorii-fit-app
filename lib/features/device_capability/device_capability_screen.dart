import 'package:depth_capture/depth_capture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../platform/depth_capture_channel.dart';

final captureCapabilitiesProvider = FutureProvider<CaptureCapabilities>((ref) {
  return ref.watch(depthCaptureChannelProvider).getCaptureCapabilities();
});

class DeviceCapabilityScreen extends ConsumerWidget {
  const DeviceCapabilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capabilities = ref.watch(captureCapabilitiesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Capabilitate captură adâncime')),
      body: Center(
        child: capabilities.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Eroare la verificarea capabilităților:\n$error',
              textAlign: TextAlign.center,
            ),
          ),
          data: (value) => _CapabilityResult(source: value.bestAvailableSource),
        ),
      ),
    );
  }
}

class _CapabilityResult extends StatelessWidget {
  const _CapabilityResult({required this.source});

  final DepthSource source;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_iconFor(source), size: 64, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        Text(_labelFor(source), style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(_descriptionFor(source), textAlign: TextAlign.center),
      ],
    );
  }

  IconData _iconFor(DepthSource source) {
    switch (source) {
      case DepthSource.lidar:
        return Icons.threed_rotation;
      case DepthSource.arcoreDepth:
        return Icons.threed_rotation;
      case DepthSource.portraitDualCamera:
        return Icons.camera_alt;
      case DepthSource.referenceObjectOnly:
        return Icons.crop_free;
      case DepthSource.none:
        return Icons.error_outline;
    }
  }

  String _labelFor(DepthSource source) {
    switch (source) {
      case DepthSource.lidar:
        return 'LiDAR disponibil';
      case DepthSource.arcoreDepth:
        return 'ARCore Depth disponibil';
      case DepthSource.portraitDualCamera:
        return 'Cameră duală (portrait depth)';
      case DepthSource.referenceObjectOnly:
        return 'Fără senzor de adâncime';
      case DepthSource.none:
        return 'Necunoscut';
    }
  }

  String _descriptionFor(DepthSource source) {
    switch (source) {
      case DepthSource.lidar:
        return 'Estimare volumetrică de înaltă precizie (~10-15% eroare).';
      case DepthSource.arcoreDepth:
        return 'Estimare volumetrică prin ARCore Depth API.';
      case DepthSource.portraitDualCamera:
        return 'Adâncime aproximativă din camera duală, precizie redusă.';
      case DepthSource.referenceObjectOnly:
        return 'Se va folosi diametrul farfuriei ca referință de scară (estimare mai puțin precisă).';
      case DepthSource.none:
        return 'Nu s-a putut determina capabilitatea device-ului.';
    }
  }
}
