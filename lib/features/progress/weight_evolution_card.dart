import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/weight_entry.dart';
import '../../domain/usecases/weight_evolution.dart';
import '../../shared_widgets/gradient_border_frame.dart';
import '../profile/profile_providers.dart';

/// The actual weight trend from real weigh-ins (manual, Bluetooth scale,
/// or Health sync — all land in the same weightEntriesProvider table),
/// plotted alongside the measured change since the diet started. Distinct
/// from _PeriodStatsRow's "Scădere estimată" elsewhere, which projects a
/// change from calorie math rather than showing what was actually
/// recorded on a scale.
class WeightEvolutionCard extends ConsumerWidget {
  const WeightEvolutionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rawEntries = ref.watch(weightEntriesProvider).valueOrNull ?? const [];
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final entries = effectiveWeightEntries(rawEntries, profile);
    if (entries.length < 2) return const SizedBox.shrink();

    final summary = computeWeightEvolution(entries)!;

    final colorScheme = Theme.of(context).colorScheme;
    final isLoss = summary.differenceKg <= 0;
    final statusColor = isLoss ? const Color(0xFF2FA84F) : const Color(0xFFEF9B3D);

    final card = Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart_rounded, size: 18, color: statusColor),
                const SizedBox(width: 8),
                Expanded(child: Text('Evoluția greutății', style: Theme.of(context).textTheme.titleMedium)),
                Text(
                  '${summary.differenceKg > 0 ? '+' : ''}${summary.differenceKg.toStringAsFixed(1)} kg',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: statusColor),
                ),
              ],
            ),
            Text(
              'De la ${_formatDate(summary.startDate)} (${summary.startWeightKg.toStringAsFixed(1)} kg) '
              'până azi (${summary.latestWeightKg.toStringAsFixed(1)} kg)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            SizedBox(height: 180, child: _WeightLineChart(entries: entries, lineColor: statusColor)),
          ],
        ),
      ),
    );

    return gradientBorderFrame(context, statusColor: statusColor, radius: 20, child: card);
  }

  String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}';
}

class _WeightLineChart extends StatelessWidget {
  const _WeightLineChart({required this.entries, required this.lineColor});

  final List<WeightEntry> entries;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final firstDate = entries.first.date;
    final points = [
      for (final entry in entries) FlSpot(entry.date.difference(firstDate).inHours / 24, entry.weightKg),
    ];
    final weights = points.map((p) => p.y);
    final minWeight = weights.reduce((a, b) => a < b ? a : b);
    final maxWeight = weights.reduce((a, b) => a > b ? a : b);
    // A little headroom above/below the real range so the line never
    // touches the chart's edges.
    final padding = ((maxWeight - minWeight) * 0.2).clamp(0.5, double.infinity);

    return LineChart(
      LineChartData(
        minY: minWeight - padding,
        maxY: maxWeight + padding,
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: colorScheme.outlineVariant.withValues(alpha: 0.25), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: _niceWeightInterval((maxWeight + padding) - (minWeight - padding)),
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  value.round().toString(),
                  style: TextStyle(fontSize: 10.5, color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => colorScheme.inverseSurface,
            getTooltipItems: (spots) => spots
                .map(
                  (s) => LineTooltipItem(
                    '${s.y.toStringAsFixed(1)} kg',
                    TextStyle(color: colorScheme.onInverseSurface, fontWeight: FontWeight.w700),
                  ),
                )
                .toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: points,
            isCurved: true,
            color: lineColor,
            barWidth: 2.5,
            dotData: FlDotData(show: points.length <= 30),
            belowBarData: BarAreaData(show: true, color: lineColor.withValues(alpha: 0.12)),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  /// A round step (1/2/5/10 kg) for the axis labels, roughly quartering
  /// the visible range — avoids fl_chart's default of crowded, decimal
  /// tick values on a narrow weight range.
  double _niceWeightInterval(double range) {
    final rawStep = range / 4;
    for (final step in [1, 2, 5, 10, 20]) {
      if (rawStep <= step) return step.toDouble();
    }
    return 50;
  }
}
