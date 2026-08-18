import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/food_log_entry.dart';
import '../../data/models/meal_type.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/workout_entry.dart';
import '../../domain/usecases/met_calorie_estimator.dart';
import '../../domain/usecases/tdee_calculator.dart';
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

class FoodLogScreen extends ConsumerStatefulWidget {
  const FoodLogScreen({super.key});

  @override
  ConsumerState<FoodLogScreen> createState() => _FoodLogScreenState();
}

class _FoodLogScreenState extends ConsumerState<FoodLogScreen> {
  DateTime _selectedDate = normalizeDate(DateTime.now());

  void _shiftDay(int deltaDays) {
    setState(() => _selectedDate = _selectedDate.add(Duration(days: deltaDays)));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Alege ziua',
    );
    if (picked != null) {
      setState(() => _selectedDate = normalizeDate(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = _selectedDate;
    final entries = ref.watch(dailyLogProvider(today));
    final totalCalories = entries.fold<double>(0, (sum, entry) => sum + entry.calories);
    final workouts = ref.watch(workoutLogProvider(today));
    final totalBurned = workouts.fold<double>(0, (sum, workout) => sum + workout.caloriesBurned);
    final tdee = ref.watch(tdeeResultProvider);
    final goal = ref.watch(userProfileProvider).valueOrNull?.goal;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _shiftDay(-1),
                icon: const Icon(Icons.chevron_left_rounded),
                tooltip: 'Ziua anterioară',
              ),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _pickDate,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _dateLabelRo(today),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.expand_more_rounded,
                        size: 18,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _shiftDay(1),
                icon: const Icon(Icons.chevron_right_rounded),
                tooltip: 'Ziua următoare',
              ),
            ],
          ),
          const SizedBox(height: 4),
          _DailyProgressCard(
            key: ValueKey(today),
            totalCalories: totalCalories,
            totalBurned: totalBurned,
            tdee: tdee,
            goal: goal,
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

/// "Azi"/"Ieri"/"Mâine" when applicable (the common case), otherwise the
/// plain date — used in the day-navigation header so it's obvious at a
/// glance whether you're looking at today or a day you've navigated to.
String _dateLabelRo(DateTime date) {
  final today = normalizeDate(DateTime.now());
  final diff = date.difference(today).inDays;
  final formatted = _formatDateRo(date);
  switch (diff) {
    case 0:
      return 'Azi, $formatted';
    case -1:
      return 'Ieri, $formatted';
    case 1:
      return 'Mâine, $formatted';
    default:
      return date.year == today.year ? formatted : '$formatted ${date.year}';
  }
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

/// Distinct accent per meal — used only for the icon badge and a thin card
/// outline, so each meal reads as visually different at a glance while the
/// card body stays the neutral grey the user asked for earlier.
Color _colorForMeal(MealType mealType) {
  switch (mealType) {
    case MealType.breakfast:
      return const Color(0xFFEF9B3D);
    case MealType.lunch:
      return const Color(0xFF2E9E5B);
    case MealType.dinner:
      return const Color(0xFF5B6EE8);
    case MealType.snack:
      return const Color(0xFFD9668B);
  }
}

/// The calorie ceiling/floor derived from the goal set in onboarding (target
/// kg/week) plus any exercise logged that day — phrased by goal direction so
/// "don't exceed" only appears when the goal is actually to lose weight.
String _limitCaption(Goal? goal, double adjustedTarget) {
  switch (goal) {
    case Goal.lose:
      return 'Nu depăși ${adjustedTarget.round()} kcal, ca să atingi ritmul de slăbit propus.';
    case Goal.gain:
      return 'Ai nevoie de cel puțin ${adjustedTarget.round()} kcal pentru ritmul de creștere propus.';
    case Goal.maintain:
    case null:
      return 'Rămâi în jurul a ${adjustedTarget.round()} kcal pentru menținere.';
  }
}

class _DailyProgressCard extends StatelessWidget {
  const _DailyProgressCard({
    super.key,
    required this.totalCalories,
    required this.totalBurned,
    required this.tdee,
    required this.goal,
  });

  final double totalCalories;
  final double totalBurned;
  final TdeeResult? tdee;
  final Goal? goal;

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
    final isOverLimit = totalCalories > adjustedTarget;
    final overBy = totalCalories - adjustedTarget;

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
                    // The headline number is the full daily burn — bazal
                    // metabolism + activity-level baseline (tdee.tdee)
                    // plus any logged exercise — not just logged workouts,
                    // since most calories burned in a day come from simply
                    // being alive and moving around, not from a sport.
                    icon: Icons.local_fire_department_rounded,
                    iconColor: appColors.protein,
                    label: 'Total arse',
                    value: totalBurnedToday.round(),
                    caption: totalBurned > 0
                        ? 'bazal ${tdee!.tdee.round()} + sport ${totalBurned.round()}'
                        : 'doar din activitatea zilnică',
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
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isOverLimit ? colorScheme.errorContainer : colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    isOverLimit ? Icons.warning_rounded : Icons.flag_rounded,
                    size: 18,
                    color: isOverLimit ? colorScheme.onErrorContainer : colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isOverLimit
                          ? 'Ai depășit limita cu ${overBy.round()} kcal (peste ${adjustedTarget.round()} kcal).'
                          : _limitCaption(goal, adjustedTarget),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isOverLimit ? colorScheme.onErrorContainer : colorScheme.onSurfaceVariant,
                        fontWeight: isOverLimit ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
    this.target,
    this.caption,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final int value;
  final int? target;

  /// A breakdown line shown below the number instead of a "/ target" pair
  /// — used where a second raw number would be ambiguous (e.g. is it a
  /// goal, or just a reference point?).
  final String? caption;

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
                text: target != null ? ' / $target kcal' : ' kcal',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        if (caption != null) ...[
          const SizedBox(height: 2),
          Text(
            caption!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}

class _MealSection extends ConsumerStatefulWidget {
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
  ConsumerState<_MealSection> createState() => _MealSectionState();
}

class _MealSectionState extends ConsumerState<_MealSection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.entries.fold<double>(0, (sum, entry) => sum + entry.calories);
    final mealTarget = widget.dailyTarget != null ? widget.dailyTarget! * widget.mealType.dailyShare : null;
    // A ±15% band around the meal target, matching how mainstream trackers
    // present a "recommended range" rather than a single number no one ever
    // hits exactly.
    final rangeLow = mealTarget != null ? mealTarget * 0.85 : null;
    final rangeHigh = mealTarget != null ? mealTarget * 1.15 : null;
    final isOverRange = rangeHigh != null && subtotal > rangeHigh;
    final colorScheme = Theme.of(context).colorScheme;
    final warningColor = context.appColors.protein;
    final mealColor = _colorForMeal(widget.mealType);

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: mealColor.withValues(alpha: 0.55), width: 1.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 5, color: mealColor),
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(color: mealColor, shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: Icon(_iconForMeal(widget.mealType), size: 17, color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.mealType.label,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(color: mealColor, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        if (rangeLow != null && rangeHigh != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Valoare recomandată: ${rangeLow.round()}–${rangeHigh.round()} kcal',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    '${subtotal.round()} kcal',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isOverRange ? warningColor : null,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(height: 1),
                for (final entry in widget.entries)
                  Dismissible(
                    key: ValueKey(entry.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: colorScheme.errorContainer,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: Icon(Icons.delete_outline_rounded, color: colorScheme.onErrorContainer),
                    ),
                    onDismissed: (_) =>
                        ref.read(dailyLogProvider(widget.date).notifier).removeEntry(entry.id),
                    child: ListTile(
                      dense: true,
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Icon(Icons.restaurant_rounded, size: 16, color: colorScheme.onSurfaceVariant),
                      ),
                      title: Text(entry.foodName),
                      subtitle: Text('${_formatGrams(entry.grams)} g'),
                      trailing: Text(
                        '${entry.calories.round()} kcal',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: TextButton.icon(
                    onPressed: () =>
                        AddFoodEntrySheet.show(context, mealType: widget.mealType, date: widget.date),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Adaugă aliment'),
                  ),
                ),
              ],
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  String _formatGrams(double grams) {
    return grams == grams.roundToDouble() ? grams.toStringAsFixed(0) : grams.toString();
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
