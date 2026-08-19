import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/home_widget/home_widget_sync_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/deficit_color.dart';
import '../../core/utils/number_format.dart';
import '../../data/models/custom_food.dart';
import '../../data/models/food_log_entry.dart';
import '../../data/models/meal_type.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/workout_entry.dart';
import '../../domain/usecases/met_calorie_estimator.dart';
import '../../domain/usecases/tdee_calculator.dart';
import '../../shared_widgets/deficit_gauge.dart';
import '../../shared_widgets/gradient_border_frame.dart';
import '../activity_sync/activity_sync_screen.dart';
import '../auth/auth_providers.dart';
import '../auth/delete_account_dialog.dart';
import '../camera_capture/camera_capture_screen.dart';
import '../device_capability/device_capability_screen.dart';
import '../hydration/hydration_card.dart';
import '../profile/profile_providers.dart';
import '../progress/progress_screen.dart';
import '../recipes/recipes_screen.dart';
import '../reminders/reminder_settings_dialog.dart';
import '../streaks/streak_badge.dart';
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
    setState(
      () => _selectedDate = _selectedDate.add(Duration(days: deltaDays)),
    );
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
    final totalCalories = entries.fold<double>(
      0,
      (sum, entry) => sum + entry.calories,
    );
    final workouts = ref.watch(workoutLogProvider(today));
    final totalBurned = workouts.fold<double>(
      0,
      (sum, workout) => sum + workout.caloriesBurned,
    );
    final tdee = ref.watch(tdeeResultProvider);
    final goal = ref.watch(userProfileProvider).valueOrNull?.goal;
    ref.watch(homeWidgetSyncProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Calorii Fit'),
        actions: [
          const StreakBadge(),
          IconButton(
            tooltip: 'Progres',
            icon: const Icon(Icons.show_chart_rounded),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ProgressScreen())),
          ),
          IconButton(
            tooltip: 'Activitate & sincronizare',
            icon: const Icon(Icons.watch_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ActivitySyncScreen()),
            ),
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
                value: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const DeviceCapabilityScreen(),
                  ),
                ),
                child: const ListTile(
                  leading: Icon(Icons.phone_iphone_rounded),
                  title: Text('Verifică capabilitate device'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RecipesScreen()),
                ),
                child: const ListTile(
                  leading: Icon(Icons.menu_book_rounded),
                  title: Text('Rețetele mele'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: () => ReminderSettingsDialog.show(context),
                child: const ListTile(
                  leading: Icon(Icons.notifications_active_outlined),
                  title: Text('Memento zilnic'),
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
              PopupMenuItem(
                value: () => DeleteAccountDialog.show(context),
                child: ListTile(
                  leading: Icon(Icons.delete_forever_rounded, color: Theme.of(context).colorScheme.error),
                  title: Text(
                    'Șterge cont definitiv',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const CameraCaptureScreen())),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _dateLabelRo(today),
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
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
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.05, end: 0, curve: Curves.easeOutCubic),
          const SizedBox(height: 12),
          HydrationSection(date: today)
              .animate(delay: 60.ms)
              .fadeIn(duration: 350.ms)
              .slideY(begin: 0.05, end: 0, curve: Curves.easeOutCubic),
          const SizedBox(height: 20),
          for (final (i, mealType) in MealType.values.indexed) ...[
            _MealSection(
                  mealType: mealType,
                  date: today,
                  entries: entries
                      .where((entry) => entry.mealType == mealType)
                      .toList(),
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
              )
              .animate(delay: 320.ms)
              .fadeIn(duration: 350.ms)
              .slideY(begin: 0.08, end: 0),
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

String _formatDateRo(DateTime date) =>
    '${date.day} ${_romanianMonths[date.month - 1]}';

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
      return 'Nu depăși ${formatThousands(adjustedTarget.round())} kcal, ca să atingi ritmul de slăbit propus.';
    case Goal.gain:
      return 'Ai nevoie de cel puțin ${formatThousands(adjustedTarget.round())} kcal pentru ritmul de creștere propus.';
    case Goal.maintain:
    case null:
      return 'Rămâi în jurul a ${formatThousands(adjustedTarget.round())} kcal pentru menținere.';
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${formatThousands(totalCalories.round())} kcal azi',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: appColors.protein,
              ),
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
    final cardBorderColor = deficitStatusColor(trueDeficit, tdee!.dailyDeficit);

    return gradientBorderFrame(
      context,
      statusColor: cardBorderColor,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  DeficitGauge(
                    deficit: trueDeficit,
                    goalDeficit: tdee!.dailyDeficit,
                    width: 260,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 62),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B6B34),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Ținta: ${formatThousands(tdee!.dailyDeficit.round())} kcal',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Deficit caloric',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.info_outline_rounded,
                              size: 15,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                        Text(
                          formatThousands(trueDeficit.round()),
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isOverLimit
                      ? colorScheme.errorContainer
                      : colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      isOverLimit ? Icons.warning_rounded : Icons.flag_rounded,
                      size: 18,
                      color: isOverLimit
                          ? colorScheme.onErrorContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isOverLimit
                            ? 'Ai depășit limita cu ${formatThousands(overBy.round())} kcal (peste ${formatThousands(adjustedTarget.round())} kcal).'
                            : _limitCaption(goal, adjustedTarget),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isOverLimit
                              ? colorScheme.onErrorContainer
                              : colorScheme.onSurfaceVariant,
                          fontWeight: isOverLimit
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final int value;
  final int? target;

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
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
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
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
            children: [
              TextSpan(text: formatThousands(value)),
              TextSpan(
                text: target != null
                    ? ' / ${formatThousands(target!)} kcal'
                    : ' kcal',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
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
  final Set<String> _quickSelectedIds = {};
  final Map<String, double> _quickGrams = {};

  void _toggleQuickSelect(CustomFood food) {
    setState(() {
      if (!_quickSelectedIds.remove(food.id)) {
        _quickSelectedIds.add(food.id);
        _quickGrams.putIfAbsent(food.id, () => food.lastGramsUsed ?? 100);
      }
    });
  }

  void _adjustQuickGrams(String foodId, double delta) {
    setState(() {
      final current = _quickGrams[foodId] ?? 100;
      _quickGrams[foodId] = (current + delta).clamp(10, 2000);
    });
  }

  /// Adds every checked frequent food at once, each at its own (possibly
  /// adjusted) portion, then bumps this meal's use count for each so the
  /// ranking keeps reflecting what's actually eaten here.
  Future<void> _addSelectedQuickFoods(List<CustomFood> frequentFoods) async {
    final selected = frequentFoods.where((food) => _quickSelectedIds.contains(food.id)).toList();
    for (final food in selected) {
      final grams = _quickGrams[food.id] ?? food.lastGramsUsed ?? 100;
      await ref
          .read(dailyLogProvider(widget.date).notifier)
          .addEntry(
            mealType: widget.mealType,
            foodName: food.name,
            grams: grams,
            kcalPer100g: food.kcalPer100g,
            proteinPer100g: food.proteinPer100g,
            carbsPer100g: food.carbsPer100g,
            fatPer100g: food.fatPer100g,
            micronutrients: food.micronutrients,
          );
      await ref.read(customFoodsProvider.notifier).incrementMealTypeUsage(food.id, widget.mealType);
    }
    setState(() {
      _quickSelectedIds.clear();
      _quickGrams.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.entries.fold<double>(
      0,
      (sum, entry) => sum + entry.calories,
    );
    final mealTarget = widget.dailyTarget != null
        ? widget.dailyTarget! * widget.mealType.dailyShare
        : null;
    // A ±15% band around the meal target, matching how mainstream trackers
    // present a "recommended range" rather than a single number no one ever
    // hits exactly.
    final rangeLow = mealTarget != null ? mealTarget * 0.85 : null;
    final rangeHigh = mealTarget != null ? mealTarget * 1.15 : null;
    final isOverRange = rangeHigh != null && subtotal > rangeHigh;
    final colorScheme = Theme.of(context).colorScheme;
    final warningColor = context.appColors.protein;
    final mealColor = _colorForMeal(widget.mealType);
    // Only foods actually logged for THIS meal before — a food eaten often
    // at breakfast shouldn't show up on the dinner card. Capped to 5 so the
    // card stays glanceable instead of turning into a full food list.
    final frequentFoods = foodsRankedForMeal(ref.watch(customFoodsProvider), widget.mealType)
        .where((food) => (food.mealTypeUseCounts[widget.mealType.name] ?? 0) > 0)
        .take(5)
        .toList();

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
                              decoration: BoxDecoration(
                                color: mealColor,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                _iconForMeal(widget.mealType),
                                size: 17,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.mealType.label,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: mealColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                        if (rangeLow != null && rangeHigh != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Valoare recomandată: ${formatThousands(rangeLow.round())}–${formatThousands(rangeHigh.round())} kcal',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    '${formatThousands(subtotal.round())} kcal',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isOverRange ? warningColor : null,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(height: 1),
                if (frequentFoods.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
                    child: Text(
                      'Folosite des',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: mealColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  for (final food in frequentFoods)
                    _QuickAddRow(
                      food: food,
                      selected: _quickSelectedIds.contains(food.id),
                      grams: _quickGrams[food.id] ?? food.lastGramsUsed ?? 100,
                      accentColor: mealColor,
                      onToggle: () => _toggleQuickSelect(food),
                      onAdjustGrams: (delta) => _adjustQuickGrams(food.id, delta),
                    ),
                  if (_quickSelectedIds.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                      child: FilledButton.tonalIcon(
                        onPressed: () => _addSelectedQuickFoods(frequentFoods),
                        icon: const Icon(Icons.add_rounded),
                        label: Text('Adaugă (${_quickSelectedIds.length})'),
                      ),
                    ),
                  const Divider(height: 1),
                ],
                for (final entry in widget.entries)
                  Dismissible(
                    key: ValueKey(entry.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: colorScheme.errorContainer,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                    onDismissed: (_) => ref
                        .read(dailyLogProvider(widget.date).notifier)
                        .removeEntry(entry.id),
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
                        child: Icon(
                          Icons.restaurant_rounded,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      title: Text(entry.foodName),
                      subtitle: Text('${_formatGrams(entry.grams)} g'),
                      trailing: Text(
                        '${formatThousands(entry.calories.round())} kcal',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: TextButton.icon(
                    onPressed: () => AddFoodEntrySheet.show(
                      context,
                      mealType: widget.mealType,
                      date: widget.date,
                    ),
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
    return grams == grams.roundToDouble()
        ? grams.toStringAsFixed(0)
        : grams.toString();
  }
}

/// One row in a meal card's "Folosite des" checklist — checking it reveals
/// a compact +/- stepper so the portion can be adjusted before adding,
/// without leaving the card or opening the full add-food sheet.
class _QuickAddRow extends StatelessWidget {
  const _QuickAddRow({
    required this.food,
    required this.selected,
    required this.grams,
    required this.accentColor,
    required this.onToggle,
    required this.onAdjustGrams,
  });

  final CustomFood food;
  final bool selected;
  final double grams;
  final Color accentColor;
  final VoidCallback onToggle;
  final ValueChanged<double> onAdjustGrams;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final kcal = (food.kcalPer100g * grams / 100).round();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Row(
        children: [
          Checkbox(value: selected, activeColor: accentColor, onChanged: (_) => onToggle()),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onToggle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name, style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis),
                  Text(
                    '$kcal kcal',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
          if (selected) ...[
            IconButton(
              icon: const Icon(Icons.remove_circle_outline_rounded, size: 20),
              visualDensity: VisualDensity.compact,
              onPressed: () => onAdjustGrams(-10),
            ),
            SizedBox(
              width: 44,
              child: Text(
                '${grams.round()}g',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
              visualDensity: VisualDensity.compact,
              onPressed: () => onAdjustGrams(10),
            ),
          ],
        ],
      ),
    );
  }
}

class _WorkoutSection extends ConsumerWidget {
  const _WorkoutSection({
    required this.date,
    required this.workouts,
    required this.totalBurned,
  });

  final DateTime date;
  final List<WorkoutEntry> workouts;
  final double totalBurned;

  static const _cardColor = Color(0xFFEFCA76);
  static const _borderColor = Color(0xFF6B4423);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return gradientBorderFrame(
      context,
      statusColor: _borderColor,
      outerColor: _borderColor,
      innerColor: _cardColor,
      child: Card(
        color: _cardColor,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.fitness_center_rounded,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      'Activitate sportivă',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    trailing: Text(
                      '${formatThousands(totalBurned.round())} kcal arse',
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  for (final workout in workouts)
                    ListTile(
                      dense: true,
                      title: Text(workout.activityType.label),
                      subtitle: workout.duration.inMinutes > 0
                          ? Text('${workout.duration.inMinutes} min')
                          : const Text('Calorii introduse manual'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${formatThousands(workout.caloriesBurned.round())} kcal',
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () => ref
                                .read(workoutLogProvider(date).notifier)
                                .removeWorkout(workout.id),
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
            const Positioned(
              top: 8,
              left: 8,
              child: _WeightlifterBadge(),
            ),
          ],
        ),
      ),
    );
  }
}

/// A circular badge with a small hand-drawn (CustomPainter) figure of a
/// person lifting a dumbbell overhead, one arm swinging continuously
/// between "racked" and "locked out" — a literal lifting motion, not just
/// a static dumbbell glyph.
class _WeightlifterBadge extends StatefulWidget {
  const _WeightlifterBadge();

  @override
  State<_WeightlifterBadge> createState() => _WeightlifterBadgeState();
}

class _WeightlifterBadgeState extends State<_WeightlifterBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(color: _WorkoutSection._borderColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          size: const Size(20, 20),
          painter: _WeightlifterPainter(lift: Curves.easeInOut.transform(_controller.value)),
        ),
      ),
    );
  }
}

class _WeightlifterPainter extends CustomPainter {
  _WeightlifterPainter({required this.lift});

  /// 0 = arm racked down at the shoulder, 1 = arm locked out overhead.
  final double lift;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final fillPaint = Paint()..color = Colors.white;

    final cx = size.width * 0.46;

    // Head.
    final headCenter = Offset(cx, size.height * 0.16);
    canvas.drawCircle(headCenter, size.width * 0.13, fillPaint);

    // Torso.
    final shoulder = Offset(cx, size.height * 0.34);
    final hip = Offset(cx, size.height * 0.64);
    canvas.drawLine(shoulder, hip, linePaint);

    // Legs, a slight stance for balance.
    canvas.drawLine(hip, Offset(hip.dx - size.width * 0.18, size.height * 0.98), linePaint);
    canvas.drawLine(hip, Offset(hip.dx + size.width * 0.14, size.height * 0.98), linePaint);

    // Bracing arm, static, opposite the lifting side.
    canvas.drawLine(shoulder, Offset(shoulder.dx - size.width * 0.2, size.height * 0.5), linePaint);

    // Lifting arm: sweeps from racked (near the shoulder) to overhead lockout.
    final angle = _lerp(2.0, -1.55, lift); // radians; down-ish -> up-and-back
    final armLength = size.width * 0.4;
    final hand = shoulder + Offset(math.cos(angle), math.sin(angle)) * armLength;
    canvas.drawLine(shoulder, hand, linePaint);

    // The dumbbell: a short bar through the hand, perpendicular to the
    // forearm, with a plate at each end.
    final forearm = hand - shoulder;
    final forearmLength = forearm.distance == 0 ? 1.0 : forearm.distance;
    final unit = forearm / forearmLength;
    final perp = Offset(-unit.dy, unit.dx);
    final barHalf = size.width * 0.16;
    final plate1 = hand + perp * barHalf;
    final plate2 = hand - perp * barHalf;
    canvas.drawLine(plate1, plate2, linePaint..strokeWidth = 1.6);
    canvas.drawCircle(plate1, size.width * 0.075, fillPaint);
    canvas.drawCircle(plate2, size.width * 0.075, fillPaint);
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  bool shouldRepaint(covariant _WeightlifterPainter oldDelegate) => oldDelegate.lift != lift;
}
