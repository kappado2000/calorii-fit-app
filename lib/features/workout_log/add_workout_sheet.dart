import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/met_calorie_estimator.dart';
import '../profile/profile_providers.dart';
import 'workout_log_providers.dart';

class AddWorkoutSheet extends ConsumerStatefulWidget {
  const AddWorkoutSheet({super.key, required this.date});

  final DateTime date;

  static Future<void> show(BuildContext context, {required DateTime date}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddWorkoutSheet(date: date),
    );
  }

  @override
  ConsumerState<AddWorkoutSheet> createState() => _AddWorkoutSheetState();
}

class _AddWorkoutSheetState extends ConsumerState<AddWorkoutSheet> {
  final _durationController = TextEditingController(text: '30');
  final _manualCaloriesController = TextEditingController();
  ActivityType _activityType = ActivityType.walkingBrisk;
  ActivityType _manualActivityType = ActivityType.other;
  bool _manualMode = false;
  bool _saving = false;

  @override
  void dispose() {
    _durationController.dispose();
    _manualCaloriesController.dispose();
    super.dispose();
  }

  double? get _durationMinutes => double.tryParse(_durationController.text.replaceAll(',', '.'));

  double? get _manualCalories => double.tryParse(_manualCaloriesController.text.replaceAll(',', '.'));

  Future<void> _save(double weightKg) async {
    final minutes = _durationMinutes;
    if (minutes == null || minutes <= 0) return;
    setState(() => _saving = true);
    await ref
        .read(workoutLogProvider(widget.date).notifier)
        .addWorkout(
          activityType: _activityType,
          duration: Duration(seconds: (minutes * 60).round()),
          weightKg: weightKg,
        );
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _saveManual() async {
    final calories = _manualCalories;
    if (calories == null || calories <= 0) return;
    setState(() => _saving = true);
    await ref
        .read(workoutLogProvider(widget.date).notifier)
        .addManualWorkout(caloriesBurned: calories, activityType: _manualActivityType);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final weightKg = profile?.weightKg ?? 70;
    final minutes = _durationMinutes ?? 0;
    final estimatedCalories = const MetCalorieEstimator().estimateCalories(
      activityType: _activityType,
      weightKg: weightKg,
      duration: Duration(seconds: (minutes * 60).round()),
    );

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Adaugă activitate sportivă', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Din activitate'), icon: Icon(Icons.calculate_outlined)),
              ButtonSegment(
                value: true,
                label: Text('Calorii directe'),
                icon: Icon(Icons.edit_outlined),
              ),
            ],
            selected: {_manualMode},
            onSelectionChanged: (selection) => setState(() => _manualMode = selection.first),
          ),
          const SizedBox(height: 16),
          if (_manualMode) ...[
            DropdownButtonFormField<ActivityType>(
              initialValue: _manualActivityType,
              decoration: const InputDecoration(labelText: 'Tip activitate (opțional)'),
              items: ActivityType.values
                  .map((type) => DropdownMenuItem(value: type, child: Text(type.label)))
                  .toList(),
              onChanged: (value) => setState(() => _manualActivityType = value!),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _manualCaloriesController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Calorii arse',
                suffixText: 'kcal',
                hintText: 'ex. 250',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving || (_manualCalories ?? 0) <= 0 ? null : _saveManual,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Salvează'),
            ),
          ] else ...[
            DropdownButtonFormField<ActivityType>(
              initialValue: _activityType,
              decoration: const InputDecoration(labelText: 'Tip activitate'),
              items: ActivityType.values
                  .map((type) => DropdownMenuItem(value: type, child: Text(type.label)))
                  .toList(),
              onChanged: (value) => setState(() => _activityType = value!),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _durationController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Durată', suffixText: 'minute'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_fire_department_rounded, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Estimare: ${estimatedCalories.round()} kcal arse',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving ? null : () => _save(weightKg),
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Salvează'),
            ),
          ],
        ],
      ),
    );
  }
}
