import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/micronutrient_reference.dart';
import '../../core/utils/deficit_color.dart';
import '../../core/utils/number_format.dart';
import '../../data/datasources/remote/cloud_functions/ai_food_lookup_api_client.dart';
import '../../data/models/food_log_entry.dart';
import '../../domain/usecases/tdee_calculator.dart';
import '../../l10n/app_localizations.dart';
import '../../shared_widgets/gradient_border_frame.dart';
import '../admin/access_code_screen.dart';
import '../admin/admin_providers.dart';
import '../food_log/food_log_providers.dart';
import '../profile/profile_providers.dart';
import 'adaptive_tdee_card.dart';
import 'progress_providers.dart';
import 'weekly_summary_card.dart';
import 'weight_evolution_card.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  // Defaults to the diet-start-anchored period rather than a fixed 7-day
  // window — the whole point of a user-settable programStartDate (see
  // onboarding_screen.dart) is that "how am I doing" means "since I
  // actually started", not an arbitrary rolling week, unless the user
  // explicitly picks a shorter period.
  ProgressPeriod _period = ProgressPeriod.sinceProgramStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final historyAsync = ref.watch(dailyCalorieHistoryProvider(_period));
    final burnedHistory = ref.watch(dailyBurnedHistoryProvider(_period)).valueOrNull ?? {};
    final tdee = ref.watch(tdeeResultProvider);
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final nutritionSummary =
        ref.watch(periodNutritionSummaryProvider(_period)).valueOrNull ?? PeriodNutritionSummary.empty;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.progress)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const WeeklySummaryCard(),
          const SizedBox(height: 16),
          const WeightEvolutionCard(),
          const SizedBox(height: 16),
          if (profile != null) AdaptiveTdeeCard(profile: profile),
          SegmentedButton<ProgressPeriod>(
            segments: ProgressPeriod.values
                .map((p) => ButtonSegment(value: p, label: Text(p.label(l10n))))
                .toList(),
            selected: {_period},
            onSelectionChanged: (selection) => setState(() => _period = selection.first),
          ),
          const SizedBox(height: 20),
          historyAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => Padding(
              padding: const EdgeInsets.all(32),
              child: Center(child: Text(l10n.errorPrefixed(error.toString()))),
            ),
            data: (history) {
              if (profile == null) {
                return Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(child: Text(l10n.setUpProfileFirst)),
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
              // How the whole period is doing, on average — same scale
              // used for a single day, just fed the period's average
              // daily deficit instead of one day's.
              final avgDeficit = days.isEmpty ? 0.0 : totalDeficit / days.length;
              final periodStatusColor = tdee != null
                  ? deficitStatusColor(avgDeficit, tdee.dailyDeficit)
                  : Theme.of(context).colorScheme.primary;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PeriodStatsRow(
                    totalIntake: totalIntake,
                    avgIntake: avgIntake,
                    projectedKg: projectedKg,
                  ).animate().fadeIn(duration: 300.ms),
                  const SizedBox(height: 16),
                  _ChartCard(
                    title: l10n.caloricIntake,
                    icon: Icons.restaurant_rounded,
                    borderColor: periodStatusColor,
                    thickGradientBorder: true,
                    child: _IntakeChart(
                      days: days,
                      history: history,
                      target: target,
                      burnedHistory: burnedHistory,
                      tdeeValue: tdeeValue,
                      goalDeficit: tdee?.dailyDeficit,
                    ),
                  ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),
                  const SizedBox(height: 16),
                  _ChartCard(
                    title: l10n.dailyCaloricDeficit,
                    icon: Icons.trending_down_rounded,
                    borderColor: periodStatusColor,
                    thickGradientBorder: true,
                    child: _DeficitChart(
                      days: days,
                      history: history,
                      burnedHistory: burnedHistory,
                      tdee: tdeeValue,
                    ),
                  ).animate(delay: 100.ms).fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),
                  _BulkCompleteNutritionButton(period: _period),
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
              );
            },
          ),
        ],
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
  const _ChartCard({
    required this.title,
    required this.icon,
    required this.child,
    this.fixedHeight = true,
    required this.borderColor,
    this.thickGradientBorder = false,
  });

  final String title;
  final IconData icon;
  final Widget child;

  /// True for actual charts (fl_chart needs a bounded height); false for
  /// variable-length content like the macro/micronutrient bar lists.
  final bool fixedHeight;

  final Color borderColor;

  /// The two real charts (intake/deficit) get the same thick fade-to-card
  /// gradient border as the daily gauge card, colored by how the whole
  /// period is doing — the other cards just get a thin colored outline.
  final bool thickGradientBorder;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      shape: thickGradientBorder
          ? null
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: borderColor, width: 1.5),
            ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: borderColor),
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
    if (!thickGradientBorder) return card;
    return gradientBorderFrame(context, statusColor: borderColor, radius: 20, child: card);
  }
}

class _PeriodStatsRow extends StatelessWidget {
  const _PeriodStatsRow({required this.totalIntake, required this.avgIntake, required this.projectedKg});

  final double totalIntake;
  final double avgIntake;
  final double projectedKg;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
            label: l10n.totalCaloriesLabel,
            value: formatThousands(totalIntake.round()),
            color: const Color(0xFFEF9B3D),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            icon: Icons.calendar_today_rounded,
            label: l10n.avgPerDay,
            value: formatThousands(avgIntake.round()),
            color: const Color(0xFF5B6EE8),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            icon: Icons.monitor_weight_outlined,
            label: l10n.estimatedLoss,
            value: '${isLoss ? '-' : '+'}${projectedKg.abs().toStringAsFixed(1)} kg',
            color: const Color(0xFF2FA84F),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.label, required this.value, required this.color});

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: color, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: color),
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

/// Bulk-fills macro/micronutrient data for every entry in the selected
/// period that has none (manual entries, or a database match too sparse
/// to carry macros) — premium-gated (see admin_providers.dart's "1 pentru
/// admin, 3 pentru coduri" decision: premium unlocks the *feature*, not a
/// higher/unlimited quota, so this still runs against the same daily AI
/// quota as everything else and simply stops early if that's hit).
/// Sequential, not parallel — gentler on that shared quota and lets the
/// UI show real progress instead of an opaque spinner.
class _BulkCompleteNutritionButton extends ConsumerStatefulWidget {
  const _BulkCompleteNutritionButton({required this.period});

  final ProgressPeriod period;

  @override
  ConsumerState<_BulkCompleteNutritionButton> createState() => _BulkCompleteNutritionButtonState();
}

class _BulkCompleteNutritionButtonState extends ConsumerState<_BulkCompleteNutritionButton> {
  bool _running = false;
  int _done = 0;
  int _total = 0;

  Future<void> _run(List<FoodLogEntry> entries) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _running = true;
      _done = 0;
      _total = entries.length;
    });

    final controller = ref.read(foodNutritionCompletionControllerProvider);
    var completedCount = 0;
    String? stoppedEarlyMessage;
    for (final entry in entries) {
      try {
        if (await controller.complete(entry)) completedCount++;
      } on AiFoodLookupException catch (e) {
        if (e.isQuotaExceeded) {
          stoppedEarlyMessage = e.message;
          break;
        }
        // Any other single-entry failure shouldn't abort the whole batch.
      } catch (_) {
        // Ignored — continue with the rest of the batch.
      }
      if (!mounted) return;
      setState(() => _done++);
    }

    if (!mounted) return;
    setState(() => _running = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          stoppedEarlyMessage ?? l10n.bulkNutritionCompletionResult(completedCount, entries.length),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final missing = ref.watch(periodEntriesMissingMacrosProvider(widget.period)).valueOrNull ?? const [];
    if (missing.isEmpty) return const SizedBox.shrink();

    final canUseAi = ref.watch(canUseAiFeaturesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (!canUseAi) {
      return OutlinedButton.icon(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AccessCodeScreen())),
        icon: const Icon(Icons.lock_outline_rounded, size: 18),
        label: Text(l10n.bulkNutritionCompletionPremiumLocked(missing.length)),
        style: OutlinedButton.styleFrom(foregroundColor: colorScheme.onSurfaceVariant),
      );
    }

    return FilledButton.icon(
      onPressed: _running ? null : () => _run(missing),
      icon: _running
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.auto_awesome_rounded, size: 18),
      label: Text(
        _running
            ? l10n.bulkNutritionCompletionProgress(_done, _total)
            : l10n.bulkNutritionCompletionButton(missing.length),
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
    final l10n = AppLocalizations.of(context);
    final proteinKcal = summary.totalProtein * MacroNutrient.protein.kcalPerGram;
    final carbsKcal = summary.totalCarbs * MacroNutrient.carbs.kcalPerGram;
    final fatKcal = summary.totalFat * MacroNutrient.fat.kcalPerGram;
    final trackedKcal = proteinKcal + carbsKcal + fatKcal;

    return _ChartCard(
      title: l10n.macroBalanceTitle,
      icon: Icons.pie_chart_rounded,
      borderColor: const Color(0xFF7C5CFC),
      fixedHeight: false,
      child: trackedKcal <= 0
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(l10n.macroBalanceNoData),
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
    final l10n = AppLocalizations.of(context);
    final (min, max) = nutrient.recommendedShareRange;
    final inRange = share >= min && share <= max;
    final barColor = inRange ? const Color(0xFF1FAE7E) : const Color(0xFFE0724A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(nutrient.label(l10n), style: Theme.of(context).textTheme.bodyMedium)),
            Text(
              l10n.macroSharePercent((share * 100).round(), (min * 100).round(), (max * 100).round()),
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
    final l10n = AppLocalizations.of(context);
    final coveragePct = summary.totalEntries == 0
        ? 0
        : (summary.entriesWithMicronutrientData / summary.totalEntries * 100).round();

    return _ChartCard(
      title: l10n.micronutrientsTitle,
      icon: Icons.science_outlined,
      borderColor: const Color(0xFF1FAE7E),
      fixedHeight: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (summary.micronutrientTotals.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(l10n.micronutrientsNoData),
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
                ? l10n.micronutrientsNoEntries
                : l10n.micronutrientsCoverage(
                    coveragePct,
                    summary.entriesWithMicronutrientData,
                    summary.totalEntries,
                  ),
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
    final l10n = AppLocalizations.of(context);
    final share = avgPerDay / nutrient.dailyReferenceValue;
    final barColor = share >= 0.8 ? const Color(0xFF1FAE7E) : const Color(0xFFE0724A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(nutrient.label(l10n), style: Theme.of(context).textTheme.bodyMedium)),
            Text(
              l10n.micronutrientShare(avgPerDay.toStringAsFixed(1), nutrient.unit, (share * 100).round()),
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
  const _IntakeChart({
    required this.days,
    required this.history,
    required this.target,
    required this.burnedHistory,
    required this.tdeeValue,
    required this.goalDeficit,
  });

  final List<DateTime> days;
  final Map<DateTime, double> history;
  final double? target;

  /// Needed (along with [tdeeValue] and [goalDeficit]) to color each bar by
  /// how that day's actual deficit compared to the target — the same
  /// "eat back exercise calories" model used everywhere else in the app.
  final Map<DateTime, double> burnedHistory;
  final double? tdeeValue;
  final double? goalDeficit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final maxIntake = days.map((d) => history[d] ?? 0).fold<double>(0, (a, b) => a > b ? a : b);
    final rawMaxY = [maxIntake, target ?? 0, 100].reduce((a, b) => a > b ? a : b) * 1.25;
    // A round, non-overlap-prone step (nearest 100/250/500 depending on
    // magnitude) rather than an arbitrary maxY/4 — fl_chart otherwise
    // picks its own tick spacing that can crowd or misalign with the grid.
    final interval = _niceInterval(rawMaxY / 4);
    final maxY = interval * 4;
    final labelStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, fontSize: 10.5);

    return BarChart(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      BarChartData(
        maxY: maxY,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => colorScheme.inverseSurface,
            tooltipBorderRadius: BorderRadius.circular(10),
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(
              '${formatThousands(rod.toY.round())} kcal',
              TextStyle(color: colorScheme.onInverseSurface, fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: _bottomTitles(days)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              interval: interval,
              getTitlesWidget: (value, meta) =>
                  Text(formatThousands(value.round()), style: labelStyle),
            ),
          ),
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: colorScheme.outlineVariant.withValues(alpha: 0.25), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        extraLinesData: target != null
            ? ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: target!,
                    color: const Color(0xFF2FA84F),
                    strokeWidth: 2,
                    dashArray: [6, 4],
                    label: HorizontalLineLabel(
                      show: true,
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(bottom: 4, right: 4),
                      style: const TextStyle(
                        color: Color(0xFF2FA84F),
                        fontWeight: FontWeight.w700,
                        fontSize: 10.5,
                      ),
                      labelResolver: (_) => l10n.chartTargetLabel,
                    ),
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
                  borderRadius: BorderRadius.circular(_barWidth(days.length) / 2),
                  gradient: () {
                    final dayColor = goalDeficit != null
                        ? deficitStatusColor(
                            (tdeeValue ?? 0) + (burnedHistory[days[i]] ?? 0) - (history[days[i]] ?? 0),
                            goalDeficit!,
                          )
                        : colorScheme.primary;
                    return LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [dayColor, dayColor.withValues(alpha: 0.55)],
                    );
                  }(),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
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
    final positiveColor = const Color(0xFF2FA84F);
    final negativeColor = const Color(0xFFE0503C);

    // Same "eat back exercise calories" model as the food log screen:
    // deficit = TDEE + exercise burned - intake.
    final deficits = days
        .map((d) => (tdee ?? 0) + (burnedHistory[d] ?? 0) - (history[d] ?? 0))
        .toList();
    final rawMaxAbs = deficits.map((v) => v.abs()).fold<double>(100, (a, b) => a > b ? a : b) * 1.25;
    final interval = _niceInterval(rawMaxAbs / 2);
    final maxAbs = interval * 2;
    final labelStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, fontSize: 10.5);

    return BarChart(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      BarChartData(
        maxY: maxAbs,
        minY: -maxAbs,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => colorScheme.inverseSurface,
            tooltipBorderRadius: BorderRadius.circular(10),
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(
              formatSignedThousands(rod.toY.round()),
              TextStyle(color: colorScheme.onInverseSurface, fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: _bottomTitles(days)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              interval: interval,
              getTitlesWidget: (value, meta) =>
                  Text(formatThousands(value.round()), style: labelStyle),
            ),
          ),
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: colorScheme.outlineVariant.withValues(alpha: 0.25), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        extraLinesData: ExtraLinesData(
          horizontalLines: [HorizontalLine(y: 0, color: colorScheme.outline.withValues(alpha: 0.5), strokeWidth: 1.5)],
        ),
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

/// Rounds a raw axis step up to a "nice" round number (steps of 1/2/5 at
/// the appropriate magnitude) so the left-axis labels land on clean values
/// like 250/500/1000 instead of an arbitrary fraction of maxY — the latter
/// is what let labels overlap or land awkwardly close together before.
double _niceInterval(double raw) {
  if (raw <= 0) return 100;
  final magnitude = math.pow(10, (math.log(raw) / math.ln10).floor()).toDouble();
  final normalized = raw / magnitude;
  final niceNormalized = normalized <= 1 ? 1 : (normalized <= 2 ? 2 : (normalized <= 5 ? 5 : 10));
  return niceNormalized * magnitude;
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
