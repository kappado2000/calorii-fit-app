import 'package:depth_capture/depth_capture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/meal_type.dart';
import '../camera_capture/camera_capture_state.dart';
import '../food_log/food_log_providers.dart';

/// Mandatory confirmation/correction step before anything is saved — every
/// serious competitor (Cal AI, BiteSnap, SnapCalorie) converges on this
/// pattern because raw AI portion/food-ID accuracy alone isn't production
/// acceptable (see project plan, Risk #1). Nothing here is written to the
/// log until the user taps Salvează.
class FoodConfirmationScreen extends ConsumerStatefulWidget {
  const FoodConfirmationScreen({super.key, required this.result});

  final AwaitingConfirmation result;

  @override
  ConsumerState<FoodConfirmationScreen> createState() => _FoodConfirmationScreenState();
}

class _FoodConfirmationScreenState extends ConsumerState<FoodConfirmationScreen> {
  late List<ConfirmationItem> _items;
  late MealType _mealType;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _items = widget.result.items;
    _mealType = _defaultMealTypeForNow();
  }

  MealType _defaultMealTypeForNow() {
    final hour = DateTime.now().hour;
    if (hour < 11) return MealType.breakfast;
    if (hour < 17) return MealType.lunch;
    return MealType.dinner;
  }

  void _updatePortionFactor(int index, double factor) {
    setState(() {
      _items[index] = _items[index].copyWithPortionFactor(factor);
    });
  }

  /// The model sometimes reports an item that isn't actually on the plate
  /// (a hallucinated identification, usually at lower confidence) — this is
  /// exactly the kind of mistake the mandatory confirmation step exists to
  /// catch, so the user must be able to reject an item outright, not just
  /// resize one that was correctly identified.
  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
  }

  double get _totalCalories => _items.fold(0, (sum, item) => sum + item.estimate.calories);

  Future<void> _save() async {
    setState(() => _saving = true);
    final today = normalizeDate(DateTime.now());
    for (final item in _items) {
      final grams = item.estimate.grams;
      if (grams <= 0) continue;
      final kcalPer100g = item.estimate.calories / grams * 100;
      await ref
          .read(customFoodsProvider.notifier)
          .rememberProduct(name: item.analyzed.label, kcalPer100g: kcalPer100g, gramsUsed: grams);
      await ref
          .read(dailyLogProvider(today).notifier)
          .addEntry(
            mealType: _mealType,
            foodName: item.analyzed.label,
            grams: grams,
            kcalPer100g: kcalPer100g,
          );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmă alimentele')),
      body: Column(
        children: [
          if (widget.result.mixedPlateDetected) const _MixedPlateBanner(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Masă:'),
                const SizedBox(width: 12),
                Expanded(
                  child: SegmentedButton<MealType>(
                    segments: MealType.values
                        .map((type) => ButtonSegment(value: type, label: Text(type.label)))
                        .toList(),
                    selected: {_mealType},
                    onSelectionChanged: (selection) => setState(() => _mealType = selection.first),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? const _NoItemsLeftMessage()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: _items.length,
                    itemBuilder: (context, index) => _FoodItemCard(
                          item: _items[index],
                          onPortionFactorChanged: (factor) => _updatePortionFactor(index, factor),
                          onRemove: () => _removeItem(index),
                        )
                        .animate(delay: (60 * index).ms)
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
                  ),
          ),
          _SaveBar(
            totalCalories: _totalCalories,
            saving: _saving,
            onSave: _items.isEmpty ? null : _save,
          ),
        ],
      ),
    );
  }
}

class _MixedPlateBanner extends StatelessWidget {
  const _MixedPlateBanner();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome_rounded, size: 18, color: colorScheme.onTertiaryContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Farfurie cu alimente amestecate — verifică fiecare element, identificarea poate fi mai puțin precisă.',
              style: TextStyle(color: colorScheme.onTertiaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoItemsLeftMessage extends StatelessWidget {
  const _NoItemsLeftMessage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Ai eliminat toate elementele identificate. Fotografiază din nou dacă vrei să reîncerci.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _FoodItemCard extends StatelessWidget {
  const _FoodItemCard({required this.item, required this.onPortionFactorChanged, required this.onRemove});

  final ConfirmationItem item;
  final ValueChanged<double> onPortionFactorChanged;
  final VoidCallback onRemove;

  static const _portionPresets = {'Mic': 0.7, 'Mediu': 1.0, 'Mare': 1.4};

  @override
  Widget build(BuildContext context) {
    final estimate = item.estimate;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(item.analyzed.label, style: Theme.of(context).textTheme.titleMedium),
                ),
                _ConfidenceBadge(confidence: item.analyzed.confidence),
                IconButton(
                  tooltip: 'Nu e pe farfurie — elimină',
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: onRemove,
                ),
              ],
            ),
            if (estimate.isRoughEstimate) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Theme.of(context).colorScheme.tertiary),
                  const SizedBox(width: 4),
                  Text(
                    'Estimare aproximativă (${_depthSourceLabel(estimate.depthSource)}, fără senzor de adâncime)',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${estimate.grams.round()} g · ${estimate.calories.round()} kcal',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _portionPresets.entries
                  .map(
                    (preset) => ChoiceChip(
                      label: Text(preset.key),
                      selected: item.portionFactor == preset.value,
                      onSelected: (_) => onPortionFactorChanged(preset.value),
                    ),
                  )
                  .toList(),
            ),
            Slider(
              value: item.portionFactor.clamp(0.3, 2.5),
              min: 0.3,
              max: 2.5,
              divisions: 22,
              label: '${(item.portionFactor * 100).round()}%',
              onChanged: onPortionFactorChanged,
            ),
          ],
        ),
      ),
    );
  }

  String _depthSourceLabel(DepthSource source) {
    switch (source) {
      case DepthSource.lidar:
        return 'LiDAR';
      case DepthSource.arcoreDepth:
        return 'ARCore Depth';
      case DepthSource.portraitDualCamera:
        return 'cameră duală';
      case DepthSource.referenceObjectOnly:
        return 'referință vizuală';
      case DepthSource.none:
        return 'necunoscut';
    }
  }
}

class _ConfidenceBadge extends StatelessWidget {
  const _ConfidenceBadge({required this.confidence});

  final double confidence;

  @override
  Widget build(BuildContext context) {
    final color = confidence >= 0.6
        ? Colors.green
        : confidence >= 0.3
        ? Colors.orange
        : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
      child: Text(
        '${(confidence * 100).round()}%',
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.totalCalories, required this.saving, required this.onSave});

  final double totalCalories;
  final bool saving;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Total: ${totalCalories.round()} kcal',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              FilledButton(
                onPressed: (saving || onSave == null) ? null : onSave,
                child: saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Salvează'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
