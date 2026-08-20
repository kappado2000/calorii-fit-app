import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_profile.dart';
import '../../l10n/app_localizations.dart';
import '../profile/profile_providers.dart';

/// Status + opt-in toggle for adaptive TDEE (see AdaptiveTdeeCalculator).
/// Hidden entirely when there's nothing to show and the user hasn't
/// opted in — advertising a feature with no data yet would just be
/// clutter, same reasoning as WeeklySummaryCard/StreakBadge.
class AdaptiveTdeeCard extends ConsumerWidget {
  const AdaptiveTdeeCard({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final adaptive = ref.watch(adaptiveTdeeEstimateProvider);
    final applied = ref.watch(tdeeResultProvider);

    if (adaptive == null && !profile.useAdaptiveTdee) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainerHigh,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(l10n.adaptiveTdeeTitle, style: Theme.of(context).textTheme.titleMedium)),
                Switch(
                  value: profile.useAdaptiveTdee,
                  onChanged: (value) => ref
                      .read(profileControllerProvider)
                      .saveProfile(profile.copyWithUseAdaptiveTdee(value)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (adaptive == null)
              Text(
                l10n.adaptiveTdeeNotEnoughData,
                style: Theme.of(context).textTheme.bodySmall,
              )
            else ...[
              Text(
                l10n.adaptiveTdeeExplanation(adaptive.loggedDays, adaptive.windowDays),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _Metric(
                      label: l10n.adaptiveTdeeEstimatedLabel,
                      value: '${adaptive.estimatedTdee.round()} kcal',
                    ),
                  ),
                  Expanded(
                    child: _Metric(
                      label: l10n.adaptiveTdeeWeightTrendLabel,
                      value: l10n.weightTrendValue(adaptive.weightTrendKgPerWeek >= 0 ? '+' : '', adaptive.weightTrendKgPerWeek.toStringAsFixed(2)),
                    ),
                  ),
                ],
              ),
              if (profile.useAdaptiveTdee && applied?.isAdaptive != true) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.adaptiveTdeeRejected,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.error),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
