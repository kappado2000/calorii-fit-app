import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../shared_widgets/gradient_border_frame.dart';
import 'hydration_providers.dart';

/// Daily water intake — a running total built from individual "add a
/// glass" taps (see HydrationLogNotifier), not a single editable number,
/// so a mistaken tap undoes cleanly via the same +/- pair used to add it.
class HydrationSection extends ConsumerWidget {
  const HydrationSection({super.key, required this.date});

  final DateTime date;

  static const _cardColor = Color(0xFFCFE8F3);
  static const _borderColor = Color(0xFF1B6FA8);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final totalMl = ref.watch(dailyHydrationTotalProvider(date));
    final progress = (totalMl / dailyHydrationTargetMl).clamp(0.0, 1.0);
    final notifier = ref.read(hydrationLogProvider(date).notifier);

    return gradientBorderFrame(
      context,
      statusColor: _borderColor,
      outerColor: _borderColor,
      innerColor: _cardColor,
      child: Card(
        color: _cardColor,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: _borderColor, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(l10n.hydrationTitle, style: Theme.of(context).textTheme.titleMedium),
                        const Spacer(),
                        Text(
                          '${totalMl.round()} / ${dailyHydrationTargetMl.round()} ml',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.white.withValues(alpha: 0.6),
                        valueColor: const AlwaysStoppedAnimation(_borderColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: notifier.removeLastGlass,
                icon: const Icon(Icons.remove_circle_outline_rounded),
                color: _borderColor,
                tooltip: l10n.hydrationUndoLastGlass,
              ),
              IconButton(
                onPressed: notifier.addGlass,
                icon: const Icon(Icons.add_circle_rounded),
                color: _borderColor,
                tooltip: l10n.hydrationAddGlass(hydrationGlassMl.round()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
