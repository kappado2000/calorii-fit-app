import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/micronutrient_reference.dart';
import '../../domain/usecases/tdee_calculator.dart';
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
    final burnedHistory = ref.watch(dailyBurnedHistoryProvider(_period)).valueOrNull ?? {};
    final tdee = ref.watch(tdeeResultProvider);
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final nutritionSummary =
        ref.watch(periodNutritionSummaryProvider(_period)).valueOrNull ?? PeriodNutritionSummary.empty;

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

                  final totalIntake = days.fold<double>(0, (sum, d) => sum + (history[d] ?? 0));
                  final avgIntake = days.isEmpty ? 0.0 : totalIntake / days.length;
                  final totalDeficit = days.fold<double>(
                    0,
                    (sum, d) => sum + ((tdeeValue ?? 0) + (burnedHistory[d] ?? 0) - (history[d] ?? 0)),
                  );
                  final projectedKg = totalDeficit / kcalPerKgBodyFat;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _PeriodStatsRow(
                          totalIntake: totalIntake,
                          avgIntake: avgIntake,
                          projectedKg: projectedKg,
                        ).animate().fadeIn(duration: 300.ms),
                        const SizedBox(height: 16),
                        _ChartCard(
                          title: 'Aport caloric',
                          icon: Icons.restaurant_rounded,
                          child: _IntakeChart(days: days, history: history, target: target),
                        ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),
                        const SizedBox(height: 16),
                        _ChartCard(
                          title: 'Deficit caloric zilnic',
                          icon: Icons.trending_down_rounded,
                          child: _DeficitChart(
                            days: days,
                            history: history,
                            burnedHistory: burnedHistory,
                            tdee: tdeeValue,
                          ),
                        ).animate(delay: 100.ms).fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),
                        const SizedBox(height: 16),
                        _MacroBalanceCard(
                          summary: nutritionSummary,
                        ).animate(delay: 150.ms).fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),
                        const SizedBox(height: 16),
                        _MicronutrientCard(
                          summary: nutritionSummary,
                          dayCount: days.length,
                        ).animate(delay: 200.ms).fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),
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

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.icon, required this.child, this.fixedHeight = true});

  final String title;
  final IconData icon;
  final Widget child;

  /// True for actual charts (fl_chart needs a bounded height); false for
  /// variable-length content like the macro/micronutrient bar lists.
  final bool fixedHeight;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            fixedHeight ? SizedBox(height: 200, child: child) : child,
          ],
        ),
      ),
    );
  }
}

class _PeriodStatsRow extends StatelessWidget {
  const _PeriodStatsRow({required this.totalIntake, required this.avgIntake, required this.projectedKg});

  final double totalIntake;
  final double avgIntake;
  final double projectedKg;

  @override
  Widget build(BuildContext context) {
    // Positive projectedKg = calories burned exceeded calories eaten over
    // the period, i.e. an expected loss — shown as "-X kg" since that's
    // how a scale would read it, even though internally it's a positive
    // deficit number.
    final isLoss = projectedKg >= 0;
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.local_dining_rounded,
            label: 'Total calorii',
            value: '${totalIntake.round()}',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            icon: Icons.calendar_today_rounded,
            label: 'Medie/zi',
            value: '${avgIntake.round()}',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            icon: Icons.monitor_weight_outlined,
            label: 'Scădere estimată',
            value: '${isLoss ? '-' : '+'}${projectedKg.abs().toStringAsFixed(1)} kg',
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: colorScheme.primary),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Share of the period's calories coming from each macro, against the
/// standard EFSA/WHO acceptable distribution range — "sănătos" here means
/// "within the range", not a precise clinical judgement.
class _MacroBalanceCard extends StatelessWidget {
  const _MacroBalanceCard({required this.summary});

  final PeriodNutritionSummary summary;

  @override
  Widget build(BuildContext context) {
    final proteinKcal = summary.totalProtein * MacroNutrient.protein.kcalPerGram;
    final carbsKcal = summary.totalCarbs * MacroNutrient.carbs.kcalPerGram;
    final fatKcal = summary.totalFat * MacroNutrient.fat.kcalPerGram;
    final trackedKcal = proteinKcal + carbsKcal + fatKcal;

    return _ChartCard(
      title: 'Echilibru macronutrienți',
      icon: Icons.pie_chart_rounded,
      fixedHeight: false,
      child: trackedKcal <= 0
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Niciun aliment cu proteine/carbohidrați/grăsimi cunoscute în această perioadă.'),
            )
          : Column(
              children: [
                _MacroBar(nutrient: MacroNutrient.protein, share: proteinKcal / trackedKcal),
                const SizedBox(height: 10),
                _MacroBar(nutrient: MacroNutrient.carbs, share: carbsKcal / trackedKcal),
                const SizedBox(height: 10),
                _MacroBar(nutrient: MacroNutrient.fat, share: fatKcal / trackedKcal),
              ],
            ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  const _MacroBar({required this.nutrient, required this.share});

  final MacroNutrient nutrient;
  final double share;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (min, max) = nutrient.recommendedShareRange;
    final inRange = share >= min && share <= max;
    final barColor = inRange ? const Color(0xFF1FAE7E) : const Color(0xFFE0724A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(nutrient.label, style: Theme.of(context).textTheme.bodyMedium)),
            Text(
              '${(share * 100).round()}% (recomandat ${(min * 100).round()}-${(max * 100).round()}%)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: share.clamp(0, 1),
            minHeight: 8,
            backgroundColor: colorScheme.surfaceContainerHighest,
            color: barColor,
          ),
        ),
      ],
    );
  }
}

/// Average daily intake of the six tracked micronutrients vs. the EU
/// reference value — only shown for nutrients at least one logged entry
/// had data for for; the coverage note makes the partial nature explicit
/// rather than implying a full nutritional analysis.
class _MicronutrientCard extends StatelessWidget {
  const _MicronutrientCard({required this.summary, required this.dayCount});

  final PeriodNutritionSummary summary;
  final int dayCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final coveragePct = summary.totalEntries == 0
        ? 0
        : (summary.entriesWithMicronutrientData / summary.totalEntries * 100).round();

    return _ChartCard(
      title: 'Micronutrienți (medie/zi)',
      icon: Icons.science_outlined,
      fixedHeight: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (summary.micronutrientTotals.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Niciun aliment cu date despre vitamine/minerale în această perioadă — '
                'vezi nota de mai jos.',
              ),
            )
          else
            for (final nutrient in Micronutrient.values)
              if (summary.micronutrientTotals.containsKey(nutrient)) ...[
                _MicronutrientBar(
                  nutrient: nutrient,
                  avgPerDay: summary.micronutrientTotals[nutrient]! / (dayCount == 0 ? 1 : dayCount),
                ),
                const SizedBox(height: 10),
              ],
          const SizedBox(height: 4),
          Text(
            summary.totalEntries == 0
                ? 'Fără alimente înregistrate în această perioadă.'
                : 'Date de vitamine/minerale disponibile pentru $coveragePct% din alimentele '
                      'înregistrate (${summary.entriesWithMicronutrientData}/${summary.totalEntries}) — '
                      'restul (mâncare de casă, produse fără etichetă) nu au date cunoscute și nu '
                      'sunt incluse în medie.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _MicronutrientBar extends StatelessWidget {
  const _MicronutrientBar({required this.nutrient, required this.avgPerDay});

  final Micronutrient nutrient;
  final double avgPerDay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final share = avgPerDay / nutrient.dailyReferenceValue;
    final barColor = share >= 0.8 ? const Color(0xFF1FAE7E) : const Color(0xFFE0724A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(nutrient.label, style: Theme.of(context).textTheme.bodyMedium)),
            Text(
              '${avgPerDay.toStringAsFixed(1)} ${nutrient.unit} · ${(share * 100).round()}% din doza zilnică',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: share.clamp(0, 1),
            minHeight: 8,
            backgroundColor: colorScheme.surfaceContainerHighest,
            color: barColor,
          ),
        ),
      ],
    );
  }
}

class _IntakeChart extends StatelessWidget {
  const _IntakeChart({required this.days, required this.history, required this.target});

  final List<DateTime> days;
  final Map<DateTime, double> history;
  final double? target;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final maxIntake = days.map((d) => history[d] ?? 0).fold<double>(0, (a, b) => a > b ? a : b);
    final maxY = [maxIntake, target ?? 0, 100].reduce((a, b) => a > b ? a : b) * 1.2;

    return BarChart(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      BarChartData(
        maxY: maxY,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: _bottomTitles(days)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) =>
                  Text(value.round().toString(), style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: colorScheme.outlineVariant.withValues(alpha: 0.3), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        extraLinesData: target != null
            ? ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: target!,
                    color: colorScheme.tertiary,
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
                BarChartRodData(
                  toY: history[days[i]] ?? 0,
                  width: _barWidth(days.length),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.6)],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DeficitChart extends StatelessWidget {
  const _DeficitChart({
    required this.days,
    required this.history,
    required this.burnedHistory,
    required this.tdee,
  });

  final List<DateTime> days;
  final Map<DateTime, double> history;
  final Map<DateTime, double> burnedHistory;
  final double? tdee;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final positiveColor = const Color(0xFF1FAE7E);
    final negativeColor = colorScheme.error;

    // Same "eat back exercise calories" model as the food log screen:
    // deficit = TDEE + exercise burned - intake.
    final deficits = days
        .map((d) => (tdee ?? 0) + (burnedHistory[d] ?? 0) - (history[d] ?? 0))
        .toList();
    final maxAbs = deficits.map((v) => v.abs()).fold<double>(100, (a, b) => a > b ? a : b);

    return BarChart(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      BarChartData(
        maxY: maxAbs * 1.2,
        minY: -maxAbs * 1.2,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: _bottomTitles(days)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) =>
                  Text(value.round().toString(), style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: colorScheme.outlineVariant.withValues(alpha: 0.3), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          for (var i = 0; i < days.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: deficits[i],
                  width: _barWidth(days.length),
                  borderRadius: BorderRadius.vertical(
                    top: deficits[i] >= 0 ? const Radius.circular(6) : Radius.zero,
                    bottom: deficits[i] < 0 ? const Radius.circular(6) : Radius.zero,
                  ),
                  color: deficits[i] >= 0 ? positiveColor : negativeColor,
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
