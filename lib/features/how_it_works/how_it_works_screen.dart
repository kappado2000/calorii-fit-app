import 'package:depth_capture/depth_capture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('Cum calculăm caloriile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Majoritatea aplicațiilor de nutriție ghicesc porția dintr-o '
            'singură fotografie 2D. Calorii Fit măsoară efectiv volumul '
            'mâncării de pe farfurie, folosind harta de adâncime a '
            'telefonului tău — de asta estimarea e mai precisă.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          _StepCard(
            number: 1,
            icon: Icons.camera_alt_rounded,
            title: 'Fotografiezi farfuria',
            description: 'O singură poză, fără poziționare specială.',
          ),
          _StepCard(
            number: 2,
            icon: Icons.threed_rotation_rounded,
            title: 'Telefonul captează adâncimea',
            description: source == null
                ? 'Telefonul tău folosește LiDAR, ARCore Depth sau camera duală, în funcție de model, ca să știe cât de înaltă e mâncarea, nu doar cum arată de sus.'
                : _depthExplanationFor(source),
            highlighted: true,
          ),
          _StepCard(
            number: 3,
            icon: Icons.psychology_alt_rounded,
            title: 'Claude identifică alimentele',
            description:
                'Modelul recunoaște ce e pe farfurie și marchează conturul '
                'aproximativ al fiecărui aliment — nu calculează el caloriile, '
                'doar identifică.',
          ),
          _StepCard(
            number: 4,
            icon: Icons.calculate_rounded,
            title: 'Volumul devine grame, apoi calorii',
            description:
                'Harta de adâncime × conturul fiecărui aliment dă un volum '
                'în cm³. Un tabel de densități (specific fiecărui tip de '
                'aliment) transformă volumul în grame, iar baza de date '
                'nutrițională transformă gramele în calorii și macro-nutrienți.',
          ),
          _StepCard(
            number: 5,
            icon: Icons.fact_check_rounded,
            title: 'Tu confirmi sau corectezi',
            description:
                'Estimarea automată nu se salvează niciodată direct — vezi '
                'mereu un ecran de confirmare unde poți ajusta porția sau '
                'schimba alimentul identificat.',
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DeviceCapabilityScreen()),
              ),
              icon: const Icon(Icons.phone_iphone_rounded, size: 18),
              label: const Text('Vezi ce metodă folosește telefonul tău'),
            ),
          ),
        ],
      ),
    );
  }

  String _depthExplanationFor(DepthSource source) {
    switch (source) {
      case DepthSource.lidar:
        return 'Telefonul tău are LiDAR — cea mai precisă metodă disponibilă azi pe un telefon, cu o eroare tipică de doar 10-15%.';
      case DepthSource.arcoreDepth:
        return 'Telefonul tău folosește ARCore Depth API pentru a estima adâncimea scenei.';
      case DepthSource.portraitDualCamera:
        return 'Telefonul tău estimează adâncimea din camera duală (mod portret) — mai puțin precis decât LiDAR, dar tot mai bun decât o poză simplă.';
      case DepthSource.referenceObjectOnly:
        return 'Telefonul tău nu are senzor de adâncime, așa că folosim diametrul standard al unei farfurii ca referință de scară — cea mai puțin precisă metodă, dar tot mai bună decât o ghicire pur vizuală.';
      case DepthSource.none:
        return 'Nu am putut determina metoda folosită de telefonul tău.';
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
