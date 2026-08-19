import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_profile.dart';
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
                Expanded(child: Text('TDEE adaptiv', style: Theme.of(context).textTheme.titleMedium)),
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
                'Încă nu ai suficiente date: îți trebuie cel puțin 14 zile '
                'logate și 2 cântăriri la minim 10 zile distanță, în '
                'ultimele 3 săptămâni. Până atunci se folosește formula '
                'standard (Mifflin-St Jeor).',
                style: Theme.of(context).textTheme.bodySmall,
              )
            else ...[
              Text(
                'Calculat din propriul tău echilibru caloric (${adaptive.loggedDays}/${adaptive.windowDays} '
                'zile logate în ultimele 3 săptămâni), nu doar din formula standard.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _Metric(
                      label: 'TDEE estimat',
                      value: '${adaptive.estimatedTdee.round()} kcal',
                    ),
                  ),
                  Expanded(
                    child: _Metric(
                      label: 'Trend greutate',
                      value: '${adaptive.weightTrendKgPerWeek >= 0 ? '+' : ''}${adaptive.weightTrendKgPerWeek.toStringAsFixed(2)} kg/săpt.',
                    ),
                  ),
                ],
              ),
              if (profile.useAdaptiveTdee && applied?.isAdaptive != true) ...[
                const SizedBox(height: 8),
                Text(
                  'Estimarea diferă prea mult de formula standard ca să fie '
                  'de încredere încă — se folosește în continuare formula '
                  'standard, până se adună mai multe date consistente.',
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
