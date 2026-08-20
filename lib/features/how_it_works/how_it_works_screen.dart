import 'package:depth_capture/depth_capture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../device_capability/device_capability_screen.dart';

/// The trust/differentiation screen: most competitor apps guess calories
/// from a flat 2D photo. This walks through why Calorii Fit's estimate is
/// different — actual depth-sensed volume, not just a visual guess — using
/// the same DepthSource capability check the device-capability screen
/// already exposes, so the step that applies to *this* device is
/// highlighted rather than shown as one of several generic possibilities.
class HowItWorksScreen extends ConsumerWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capabilities = ref.watch(captureCapabilitiesProvider).valueOrNull;
    final source = capabilities?.bestAvailableSource;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.howItWorksTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            l10n.howItWorksIntro,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          _StepCard(
            number: 1,
            icon: Icons.camera_alt_rounded,
            title: l10n.howItWorksStep1Title,
            description: l10n.howItWorksStep1Description,
          ),
          _StepCard(
            number: 2,
            icon: Icons.threed_rotation_rounded,
            title: l10n.howItWorksStep2Title,
            description: source == null ? l10n.howItWorksStep2GenericDescription : _depthExplanationFor(l10n, source),
            highlighted: true,
          ),
          _StepCard(
            number: 3,
            icon: Icons.psychology_alt_rounded,
            title: l10n.howItWorksStep3Title,
            description: l10n.howItWorksStep3Description,
          ),
          _StepCard(
            number: 4,
            icon: Icons.calculate_rounded,
            title: l10n.howItWorksStep4Title,
            description: l10n.howItWorksStep4Description,
          ),
          _StepCard(
            number: 5,
            icon: Icons.fact_check_rounded,
            title: l10n.howItWorksStep5Title,
            description: l10n.howItWorksStep5Description,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DeviceCapabilityScreen()),
              ),
              icon: const Icon(Icons.phone_iphone_rounded, size: 18),
              label: Text(l10n.howItWorksSeeDeviceMethod),
            ),
          ),
        ],
      ),
    );
  }

  String _depthExplanationFor(AppLocalizations l10n, DepthSource source) {
    switch (source) {
      case DepthSource.lidar:
        return l10n.howItWorksDepthLidar;
      case DepthSource.arcoreDepth:
        return l10n.howItWorksDepthArcore;
      case DepthSource.portraitDualCamera:
        return l10n.howItWorksDepthPortrait;
      case DepthSource.referenceObjectOnly:
        return l10n.howItWorksDepthReference;
      case DepthSource.none:
        return l10n.howItWorksDepthUnknown;
    }
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
    this.highlighted = false,
  });

  final int number;
  final IconData icon;
  final String title;
  final String description;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: highlighted ? colorScheme.primaryContainer.withValues(alpha: 0.5) : null,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(icon, color: colorScheme.onPrimary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$number. $title',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
