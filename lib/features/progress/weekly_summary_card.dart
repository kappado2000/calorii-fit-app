import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/number_format.dart';
import 'weekly_summary_providers.dart';

/// A fixed "last 7 days vs the 7 before" recap — unlike the rest of
/// ProgressScreen, this doesn't depend on the selected [ProgressPeriod]
/// or on a calorie target being set, so it's the one thing on the screen
/// that always has something to show.
class WeeklySummaryCard extends ConsumerWidget {
  const WeeklySummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(weeklySummaryProvider).valueOrNull ?? WeeklySummary.empty;
    final colorScheme = Theme.of(context).colorScheme;

    if (summary.thisWeekDaysLogged == 0) return const SizedBox.shrink();

    final delta = summary.avgCaloriesDelta;
    final hasComparison = summary.lastWeekAvgCalories > 0;

    return Card(
      color: colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rezumatul săptămânii', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatColumn(
                  label: 'Zile logate',
                  value: '${summary.thisWeekDaysLogged}/7',
                ),
                _StatColumn(
                  label: 'Medie kcal/zi',
                  value: formatThousands(summary.thisWeekAvgCalories.round()),
                  trailing: hasComparison ? _DeltaBadge(delta: delta) : null,
                ),
                _StatColumn(
                  label: 'Antrenamente',
                  value: '${summary.thisWeekWorkouts}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.label, required this.value, this.trailing});

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              if (trailing != null) ...[const SizedBox(width: 4), trailing!],
            ],
          ),
        ],
      ),
    );
  }
}

class _DeltaBadge extends StatelessWidget {
  const _DeltaBadge({required this.delta});

  final double delta;

  @override
  Widget build(BuildContext context) {
    // A calorie delta has no inherent good/bad direction (depends on the
    // user's goal), so this stays a neutral gray up/down indicator rather
    // than green/red — same reasoning as leaving goal-aware coloring to
    // the deficit gauge elsewhere, which already knows the target.
    if (delta.abs() < 1) return const SizedBox.shrink();
    final icon = delta > 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;
    return Icon(icon, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant);
  }
}
