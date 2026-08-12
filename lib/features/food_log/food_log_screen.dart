import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/food_log_entry.dart';
import '../../data/models/meal_type.dart';
import '../device_capability/device_capability_screen.dart';
import 'add_food_entry_sheet.dart';
import 'food_log_providers.dart';

class FoodLogScreen extends ConsumerWidget {
  const FoodLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = normalizeDate(DateTime.now());
    final entries = ref.watch(dailyLogProvider(today));
    final totalCalories = entries.fold<double>(0, (sum, entry) => sum + entry.calories);

    return Scaffold(
      appBar: AppBar(
        title: Text('Calorii Fit — ${_formatDateRo(today)}'),
        actions: [
          IconButton(
            tooltip: 'Capabilitate captură',
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const DeviceCapabilityScreen())),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DailyTotalCard(totalCalories: totalCalories),
          const SizedBox(height: 16),
          for (final mealType in MealType.values) ...[
            _MealSection(
              mealType: mealType,
              date: today,
              entries: entries.where((entry) => entry.mealType == mealType).toList(),
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

class _DailyTotalCard extends StatelessWidget {
  const _DailyTotalCard({required this.totalCalories});

  final double totalCalories;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total azi', style: Theme.of(context).textTheme.titleMedium),
            Text(
              '${totalCalories.round()} kcal',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealSection extends ConsumerWidget {
  const _MealSection({required this.mealType, required this.date, required this.entries});

  final MealType mealType;
  final DateTime date;
  final List<FoodLogEntry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtotal = entries.fold<double>(0, (sum, entry) => sum + entry.calories);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
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
