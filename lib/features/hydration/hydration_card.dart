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

  static const _cardColorLight = Color(0xFFCFE8F3);
  static const _cardColorDark = Color(0xFF17323F);
  static const _borderColorLight = Color(0xFF1B6FA8);
  static const _borderColorDark = Color(0xFF6BC0EE);
  // Explicit text color rather than the theme default — this card's fill
  // is a fixed light/dark blue, not the theme surface color, so the
  // default onSurface text (near-white in dark mode) went invisible
  // against the light-blue fill still used in light mode, and vice versa.
  static const _onCardLight = Color(0xFF0D2B38);
  static const _onCardDark = Color(0xFFE3F3FB);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final totalMl = ref.watch(dailyHydrationTotalProvider(date));
    final progress = (totalMl / dailyHydrationTargetMl).clamp(0.0, 1.0);
    final notifier = ref.read(hydrationLogProvider(date).notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? _cardColorDark : _cardColorLight;
    final borderColor = isDark ? _borderColorDark : _borderColorLight;
    final onCard = isDark ? _onCardDark : _onCardLight;

    return gradientBorderFrame(
      context,
      statusColor: borderColor,
      outerColor: borderColor,
      innerColor: cardColor,
      child: Card(
        color: cardColor,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: borderColor, shape: BoxShape.circle),
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
                        Text(
                          l10n.hydrationTitle,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: onCard, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Text(
                          '${totalMl.round()} / ${dailyHydrationTargetMl.round()} ml',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: onCard),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: onCard.withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation(borderColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: notifier.removeLastGlass,
                icon: const Icon(Icons.remove_circle_outline_rounded),
                color: borderColor,
                tooltip: l10n.hydrationUndoLastGlass,
              ),
              IconButton(
                onPressed: notifier.addGlass,
                icon: const Icon(Icons.add_circle_rounded),
                color: borderColor,
                tooltip: l10n.hydrationAddGlass(hydrationGlassMl.round()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
