import 'package:depth_capture/depth_capture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../platform/depth_capture_channel.dart';

final captureCapabilitiesProvider = FutureProvider<CaptureCapabilities>((ref) {
  return ref.watch(depthCaptureChannelProvider).getCaptureCapabilities();
});

class DeviceCapabilityScreen extends ConsumerWidget {
  const DeviceCapabilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capabilities = ref.watch(captureCapabilitiesProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.deviceCapabilityTitle)),
      body: Center(
        child: capabilities.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              l10n.deviceCapabilityError(error.toString()),
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
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(color: colorScheme.primaryContainer, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(_iconFor(source), size: 44, color: colorScheme.onPrimaryContainer),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 20),
          Text(_labelFor(l10n, source), style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            _descriptionFor(l10n, source),
            textAlign: TextAlign.center,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(DepthSource source) {
    switch (source) {
      case DepthSource.lidar:
        return Icons.threed_rotation_rounded;
      case DepthSource.arcoreDepth:
        return Icons.threed_rotation_rounded;
      case DepthSource.portraitDualCamera:
        return Icons.camera_alt_rounded;
      case DepthSource.referenceObjectOnly:
        return Icons.crop_free_rounded;
      case DepthSource.none:
        return Icons.error_outline_rounded;
    }
  }

  String _labelFor(AppLocalizations l10n, DepthSource source) {
    switch (source) {
      case DepthSource.lidar:
        return l10n.depthSourceLidarLabel;
      case DepthSource.arcoreDepth:
        return l10n.depthSourceArcoreLabel;
      case DepthSource.portraitDualCamera:
        return l10n.depthSourcePortraitLabel;
      case DepthSource.referenceObjectOnly:
        return l10n.depthSourceReferenceLabel;
      case DepthSource.none:
        return l10n.depthSourceUnknownLabel;
    }
  }

  String _descriptionFor(AppLocalizations l10n, DepthSource source) {
    switch (source) {
      case DepthSource.lidar:
        return l10n.depthSourceLidarDescription;
      case DepthSource.arcoreDepth:
        return l10n.depthSourceArcoreDescription;
      case DepthSource.portraitDualCamera:
        return l10n.depthSourcePortraitDescription;
      case DepthSource.referenceObjectOnly:
        return l10n.depthSourceReferenceDescription;
      case DepthSource.none:
        return l10n.depthSourceUnknownDescription;
    }
  }
}
