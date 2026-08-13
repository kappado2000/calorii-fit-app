import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../profile/profile_providers.dart';
import 'progress_providers.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  ProgressPeriod _period = ProgressPeriod.last7Days;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(dailyCalorieHistoryProvider(_period));
    final tdee = ref.watch(tdeeResultProvider);
    final profile = ref.watch(userProfileProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Progres')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<ProgressPeriod>(
              segments: ProgressPeriod.values
                  .map((p) => ButtonSegment(value: p, label: Text(p.label)))
                  .toList(),
              selected: {_period},
              onSelectionChanged: (selection) => setState(() => _period = selection.first),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: historyAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(child: Text('Eroare: $error')),
                data: (history) {
                  if (profile == null) {
                    return const Center(
                      child: Text('Setează-ți mai întâi profilul și obiectivul din meniu.'),
                    );
                  }
                  final start = _period == ProgressPeriod.sinceProgramStart
                      ? _normalize(profile.programStartDate)
                      : _normalize(DateTime.now()).subtract(
                          Duration(days: _period == ProgressPeriod.last7Days ? 6 : 29),
                        );
                  final end = _normalize(DateTime.now());
                  final days = _dateRange(start, end);
                  final target = tdee?.calorieTarget;
                  final tdeeValue = tdee?.tdee;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Aport caloric', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 220,
                          child: _IntakeChart(days: days, history: history, target: target),
                        ),
                        const SizedBox(height: 28),
                        Text('Deficit caloric zilnic', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 220,
                          child: _DeficitChart(days: days, history: history, tdee: tdeeValue),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime _normalize(DateTime date) => DateTime(date.year, date.month, date.day);

  List<DateTime> _dateRange(DateTime start, DateTime end) {
    final days = <DateTime>[];
    var current = start;
    while (!current.isAfter(end)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }
    return days;
  }
}

class _IntakeChart extends StatelessWidget {
  const _IntakeChart({required this.days, required this.history, required this.target});

  final List<DateTime> days;
  final Map<DateTime, double> history;
  final double? target;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final maxIntake = days.map((d) => history[d] ?? 0).fold<double>(0, (a, b) => a > b ? a : b);
    final maxY = [maxIntake, target ?? 0, 100].reduce((a, b) => a > b ? a : b) * 1.2;

    return BarChart(
      BarChartData(
        maxY: maxY,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: _bottomTitles(days)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
        ),
        gridData: const FlGridData(drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        extraLinesData: target != null
            ? ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: target!,
                    color: Theme.of(context).colorScheme.tertiary,
                    strokeWidth: 2,
                    dashArray: [6, 4],
                  ),
                ],
              )
            : const ExtraLinesData(),
        barGroups: [
          for (var i = 0; i < days.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(toY: history[days[i]] ?? 0, color: color, width: _barWidth(days.length)),
              ],
            ),
        ],
      ),
    );
  }
}

class _DeficitChart extends StatelessWidget {
  const _DeficitChart({required this.days, required this.history, required this.tdee});

  final List<DateTime> days;
  final Map<DateTime, double> history;
  final double? tdee;

  @override
  Widget build(BuildContext context) {
    final positiveColor = Colors.green;
    final negativeColor = Theme.of(context).colorScheme.error;

    final deficits = days.map((d) => (tdee ?? 0) - (history[d] ?? 0)).toList();
    final maxAbs = deficits.map((v) => v.abs()).fold<double>(100, (a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        maxY: maxAbs * 1.2,
        minY: -maxAbs * 1.2,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: _bottomTitles(days)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
        ),
        gridData: const FlGridData(drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          for (var i = 0; i < days.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: deficits[i],
                  color: deficits[i] >= 0 ? positiveColor : negativeColor,
                  width: _barWidth(days.length),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

double _barWidth(int dayCount) {
  if (dayCount <= 7) return 18;
  if (dayCount <= 14) return 10;
  return 5;
}

SideTitles _bottomTitles(List<DateTime> days) {
  final labelEvery = (days.length / 6).ceil().clamp(1, days.length);
  return SideTitles(
    showTitles: true,
    reservedSize: 28,
    getTitlesWidget: (value, meta) {
      final index = value.toInt();
      if (index < 0 || index >= days.length || index % labelEvery != 0) {
        return const SizedBox.shrink();
      }
      final date = days[index];
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text('${date.day}/${date.month}', style: const TextStyle(fontSize: 10)),
      );
    },
  );
}
