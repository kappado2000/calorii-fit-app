import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/food_log_entry.dart';
import '../../data/models/meal_type.dart';
import '../../data/models/workout_entry.dart';
import '../../domain/usecases/met_calorie_estimator.dart';
import '../../domain/usecases/tdee_calculator.dart';
import '../../shared_widgets/animated_gauge.dart';
import '../../shared_widgets/deficit_gauge.dart';
import '../activity_sync/activity_sync_screen.dart';
import '../auth/auth_providers.dart';
import '../camera_capture/camera_capture_screen.dart';
import '../device_capability/device_capability_screen.dart';
import '../profile/profile_providers.dart';
import '../progress/progress_screen.dart';
import '../workout_log/add_workout_sheet.dart';
import '../workout_log/workout_log_providers.dart';
import 'add_food_entry_sheet.dart';
import 'food_log_providers.dart';

class FoodLogScreen extends ConsumerWidget {
  const FoodLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = normalizeDate(DateTime.now());
    final entries = ref.watch(dailyLogProvider(today));
    final totalCalories = entries.fold<double>(0, (sum, entry) => sum + entry.calories);
    final totalProtein = _sumIfAnyKnown(entries.map((e) => e.protein));
    final totalCarbs = _sumIfAnyKnown(entries.map((e) => e.carbs));
    final totalFat = _sumIfAnyKnown(entries.map((e) => e.fat));
    final workouts = ref.watch(workoutLogProvider(today));
    final totalBurned = workouts.fold<double>(0, (sum, workout) => sum + workout.caloriesBurned);
    final tdee = ref.watch(tdeeResultProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Calorii Fit'),
        actions: [
          IconButton(
            tooltip: 'Progres',
            icon: const Icon(Icons.show_chart_rounded),
            onPressed: () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProgressScreen())),
          ),
          IconButton(
            tooltip: 'Activitate & sincronizare',
            icon: const Icon(Icons.watch_outlined),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ActivitySyncScreen())),
          ),
          PopupMenuButton<VoidCallback>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (action) => action(),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: () => context.push('/onboarding'),
                child: const ListTile(
                  leading: Icon(Icons.tune_rounded),
                  title: Text('Editează profil/obiectiv'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const DeviceCapabilityScreen())),
                child: const ListTile(
                  leading: Icon(Icons.phone_iphone_rounded),
                  title: Text('Verifică capabilitate device'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: () => ref.read(authControllerProvider).signOut(),
                child: const ListTile(
                  leading: Icon(Icons.logout_rounded),
                  title: Text('Deconectare'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CameraCaptureScreen())),
        icon: const Icon(Icons.camera_alt_rounded),
        label: const Text('Fotografiază'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          Text(
            _formatDateRo(today),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          _DailyProgressCard(
            totalCalories: totalCalories,
            totalBurned: totalBurned,
            tdee: tdee,
            totalProtein: totalProtein,
            totalCarbs: totalCarbs,
            totalFat: totalFat,
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0, curve: Curves.easeOutCubic),
          const SizedBox(height: 20),
          for (final (i, mealType) in MealType.values.indexed) ...[
            _MealSection(
                  mealType: mealType,
                  date: today,
                  entries: entries.where((entry) => entry.mealType == mealType).toList(),
                  dailyTarget: tdee?.calorieTarget,
                )
                .animate(delay: (80 * i).ms)
                .fadeIn(duration: 350.ms)
                .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
            const SizedBox(height: 12),
          ],
          _WorkoutSection(
            date: today,
            workouts: workouts,
            totalBurned: totalBurned,
          ).animate(delay: 320.ms).fadeIn(duration: 350.ms).slideY(begin: 0.08, end: 0),
        ],
      ),
    );
  }
}

const _romanianMonths = [
  'ianuarie',
  'februarie',
  'martie',
  'aprilie',
  'mai',
  'iunie',
  'iulie',
  'august',
  'septembrie',
  'octombrie',
  'noiembrie',
  'decembrie',
];

String _formatDateRo(DateTime date) => '${date.day} ${_romanianMonths[date.month - 1]}';

/// Sums the known (non-null) macro values across today's entries — entries
/// without a known macro (fully-manual, calorie-only) simply don't
/// contribute, rather than the whole day showing "—" because one entry
/// lacks data. Returns null only when nothing at all is known yet.
double? _sumIfAnyKnown(Iterable<double?> values) {
  if (values.every((v) => v == null)) return null;
  return values.fold<double>(0, (sum, v) => sum + (v ?? 0));
}

IconData _iconForMeal(MealType mealType) {
  switch (mealType) {
    case MealType.breakfast:
      return Icons.wb_twilight_rounded;
    case MealType.lunch:
      return Icons.lunch_dining_rounded;
    case MealType.dinner:
      return Icons.dinner_dining_rounded;
    case MealType.snack:
      return Icons.local_cafe_rounded;
  }
}

class _DailyProgressCard extends StatelessWidget {
  const _DailyProgressCard({
    required this.totalCalories,
    required this.totalBurned,
    required this.tdee,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
  });

  final double totalCalories;
  final double totalBurned;
  final TdeeResult? tdee;
  final double? totalProtein;
  final double? totalCarbs;
  final double? totalFat;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    if (tdee == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: appColors.heroGradient,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configurează-ți obiectivul',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${totalCalories.round()} kcal azi',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: appColors.protein),
              onPressed: () => context.push('/onboarding'),
              child: const Text('Setează'),
            ),
          ],
        ),
      );
    }

    // Exercise beyond the baseline activity level "earns back" extra
    // calories for the day — the same "eat back exercise calories" model
    // used by mainstream trackers, layered on top of the activity-level
    // multiplier already baked into TDEE.
    final adjustedTarget = tdee!.calorieTarget + totalBurned;
    final totalBurnedToday = tdee!.tdee + totalBurned;
    final trueDeficit = totalBurnedToday - totalCalories;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                DeficitGauge(deficit: trueDeficit, goalDeficit: tdee!.dailyDeficit, width: 260),
                Padding(
                  padding: const EdgeInsets.only(top: 56),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Deficit caloric', style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(width: 4),
                          Icon(Icons.info_outline_rounded, size: 15, color: colorScheme.onSurfaceVariant),
                        ],
                      ),
                      Text(
                        '${trueDeficit.round()}',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatBlock(
                    icon: Icons.local_fire_department_rounded,
                    iconColor: appColors.protein,
                    label: 'Total arse',
                    value: totalBurned.round(),
                    target: totalBurnedToday.round(),
                  ),
                ),
                Expanded(
                  child: _StatBlock(
                    icon: Icons.shopping_basket_rounded,
                    iconColor: const Color(0xFF1FAE7E),
                    label: 'Total consumate',
                    value: totalCalories.round(),
                    target: adjustedTarget.round(),
                  ),
                ),
              ],
            ),
            if (totalProtein != null || totalCarbs != null || totalFat != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  _MacroPill(label: 'Proteine', value: totalProtein, color: appColors.protein),
                  const SizedBox(width: 8),
                  _MacroPill(label: 'Carbo', value: totalCarbs, color: appColors.carbs),
                  const SizedBox(width: 8),
                  _MacroPill(label: 'Grăsimi', value: totalFat, color: appColors.fat),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.target,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final int value;
  final int target;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.15), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(icon, size: 15, color: iconColor),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            children: [
              TextSpan(text: '$value'),
              TextSpan(
                text: ' / $target kcal',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MacroPill extends StatelessWidget {
  const _MacroPill({required this.label, required this.value, required this.color});

  final String label;
  final double? value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                value == null ? '—' : '${value!.round()}g',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealSection extends ConsumerWidget {
  const _MealSection({
    required this.mealType,
    required this.date,
    required this.entries,
    required this.dailyTarget,
  });

  final MealType mealType;
  final DateTime date;
  final List<FoodLogEntry> entries;
  final double? dailyTarget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtotal = entries.fold<double>(0, (sum, entry) => sum + entry.calories);
    final mealTarget = dailyTarget != null ? dailyTarget! * mealType.dailyShare : null;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: Stack(
                alignment: Alignment.center,
                children: [
                  if (mealTarget != null)
                    AnimatedGauge(value: subtotal / mealTarget, size: 44, strokeWidth: 5, centerText: ''),
                  Icon(_iconForMeal(mealType), size: 18, color: colorScheme.primary),
                ],
              ),
              title: Text(mealType.label, style: Theme.of(context).textTheme.titleMedium),
              trailing: Text(
                '${subtotal.round()} kcal',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            for (final entry in entries)
              ListTile(
                dense: true,
                title: Text(entry.foodName),
                subtitle: Text(
                  '${_formatGrams(entry.grams)} g · ${entry.kcalPer100g.round()} kcal/100g'
                  '${_macroSuffix(entry)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${entry.calories.round()} kcal', style: Theme.of(context).textTheme.bodyMedium),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () => ref.read(dailyLogProvider(date).notifier).removeEntry(entry.id),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TextButton.icon(
                onPressed: () => AddFoodEntrySheet.show(context, mealType: mealType, date: date),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Adaugă aliment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatGrams(double grams) {
    return grams == grams.roundToDouble() ? grams.toStringAsFixed(0) : grams.toString();
  }

  String _macroSuffix(FoodLogEntry entry) {
    if (entry.protein == null && entry.carbs == null && entry.fat == null) return '';
    String fmt(double? v) => v == null ? '—' : '${v.round()}g';
    return ' · P ${fmt(entry.protein)} C ${fmt(entry.carbs)} G ${fmt(entry.fat)}';
  }
}

class _WorkoutSection extends ConsumerWidget {
  const _WorkoutSection({required this.date, required this.workouts, required this.totalBurned});

  final DateTime date;
  final List<WorkoutEntry> workouts;
  final double totalBurned;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: Icon(Icons.fitness_center_rounded, color: colorScheme.primary),
              title: Text('Activitate sportivă', style: Theme.of(context).textTheme.titleMedium),
              trailing: Text(
                '${totalBurned.round()} kcal arse',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            for (final workout in workouts)
              ListTile(
                dense: true,
                title: Text(workout.activityType.label),
                subtitle: Text('${workout.duration.inMinutes} min'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${workout.caloriesBurned.round()} kcal'),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () =>
                          ref.read(workoutLogProvider(date).notifier).removeWorkout(workout.id),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TextButton.icon(
                onPressed: () => AddWorkoutSheet.show(context, date: date),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Adaugă activitate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
