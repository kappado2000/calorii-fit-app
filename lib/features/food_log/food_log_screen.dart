import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/food_log_entry.dart';
import '../../data/models/meal_type.dart';
import '../../domain/usecases/tdee_calculator.dart';
import '../../shared_widgets/animated_gauge.dart';
import '../activity_sync/activity_sync_screen.dart';
import '../auth/auth_providers.dart';
import '../camera_capture/camera_capture_screen.dart';
import '../device_capability/device_capability_screen.dart';
import '../profile/profile_providers.dart';
import '../progress/progress_screen.dart';
import 'add_food_entry_sheet.dart';
import 'food_log_providers.dart';

class FoodLogScreen extends ConsumerWidget {
  const FoodLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = normalizeDate(DateTime.now());
    final entries = ref.watch(dailyLogProvider(today));
    final totalCalories = entries.fold<double>(0, (sum, entry) => sum + entry.calories);
    final tdee = ref.watch(tdeeResultProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Calorii Fit — ${_formatDateRo(today)}'),
        actions: [
          IconButton(
            tooltip: 'Progres',
            icon: const Icon(Icons.show_chart),
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
            onSelected: (action) => action(),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: () => context.push('/onboarding'),
                child: const Text('Editează profil/obiectiv'),
              ),
              PopupMenuItem(
                value: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const DeviceCapabilityScreen())),
                child: const Text('Verifică capabilitate device'),
              ),
              PopupMenuItem(
                value: () => ref.read(authControllerProvider).signOut(),
                child: const Text('Deconectare'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CameraCaptureScreen())),
        icon: const Icon(Icons.camera_alt),
        label: const Text('Fotografiază'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DailyProgressCard(totalCalories: totalCalories, tdee: tdee),
          const SizedBox(height: 16),
          for (final mealType in MealType.values) ...[
            _MealSection(
              mealType: mealType,
              date: today,
              entries: entries.where((entry) => entry.mealType == mealType).toList(),
              dailyTarget: tdee?.calorieTarget,
            ),
            const SizedBox(height: 12),
          ],
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

class _DailyProgressCard extends StatelessWidget {
  const _DailyProgressCard({required this.totalCalories, required this.tdee});

  final double totalCalories;
  final TdeeResult? tdee;

  @override
  Widget build(BuildContext context) {
    if (tdee == null) {
      return Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total azi', style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    '${totalCalories.round()} kcal',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              FilledButton(
                onPressed: () => context.push('/onboarding'),
                child: const Text('Setează obiectiv'),
              ),
            ],
          ),
        ),
      );
    }

    final target = tdee!.calorieTarget;
    final progress = target > 0 ? totalCalories / target : 0.0;
    final remaining = target - totalCalories;
    final isOverTarget = remaining < 0;

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            AnimatedGauge(
              value: progress,
              size: 100,
              centerText: '${totalCalories.round()}',
              centerSubtext: 'kcal',
              color: isOverTarget ? Theme.of(context).colorScheme.error : null,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Țintă: ${target.round()} kcal', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text(
                    isOverTarget
                        ? 'Peste țintă cu ${(-remaining).round()} kcal'
                        : '${remaining.round()} kcal rămase',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Deficit caloric azi: ${(tdee!.tdee - totalCalories).round()} kcal',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: mealTarget != null
                  ? AnimatedGauge(
                      value: subtotal / mealTarget,
                      size: 44,
                      strokeWidth: 5,
                      centerText: '',
                    )
                  : null,
              title: Text(mealType.label, style: Theme.of(context).textTheme.titleMedium),
              trailing: Text('${subtotal.round()} kcal'),
            ),
            for (final entry in entries)
              ListTile(
                dense: true,
                title: Text(entry.foodName),
                subtitle: Text('${_formatGrams(entry.grams)} g · ${entry.kcalPer100g.round()} kcal/100g'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${entry.calories.round()} kcal'),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => ref.read(dailyLogProvider(date).notifier).removeEntry(entry.id),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextButton.icon(
                onPressed: () => AddFoodEntrySheet.show(context, mealType: mealType, date: date),
                icon: const Icon(Icons.add),
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
}
