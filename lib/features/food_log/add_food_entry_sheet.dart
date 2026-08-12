import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/custom_food.dart';
import '../../data/models/meal_type.dart';
import 'food_log_providers.dart';

/// Bottom sheet for manually logging a product: type a name (autocompleted
/// against previously-remembered products, prefilling its calorie index),
/// or type a brand-new one, then enter the grams consumed now. On save, the
/// product is (re)remembered for next time — this is the "retinere in
/// memorie a produselor selectate" the user asked for.
class AddFoodEntrySheet extends ConsumerStatefulWidget {
  const AddFoodEntrySheet({super.key, required this.mealType, required this.date});

  final MealType mealType;
  final DateTime date;

  static Future<void> show(BuildContext context, {required MealType mealType, required DateTime date}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddFoodEntrySheet(mealType: mealType, date: date),
    );
  }

  @override
  ConsumerState<AddFoodEntrySheet> createState() => _AddFoodEntrySheetState();
}

class _AddFoodEntrySheetState extends ConsumerState<AddFoodEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _kcalController = TextEditingController();
  final _gramsController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _kcalController.dispose();
    _gramsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final name = _nameController.text.trim();
    final kcalPer100g = double.parse(_kcalController.text.replaceAll(',', '.'));
    final grams = double.parse(_gramsController.text.replaceAll(',', '.'));

    await ref.read(customFoodsProvider.notifier).rememberProduct(name: name, kcalPer100g: kcalPer100g);
    await ref
        .read(dailyLogProvider(widget.date).notifier)
        .addEntry(mealType: widget.mealType, foodName: name, grams: grams, kcalPer100g: kcalPer100g);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final customFoods = ref.watch(customFoodsProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Adaugă aliment — ${widget.mealType.label}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Autocomplete<CustomFood>(
              displayStringForOption: (food) => food.name,
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) return const Iterable<CustomFood>.empty();
                final query = textEditingValue.text.toLowerCase();
                return customFoods.where((food) => food.name.toLowerCase().contains(query));
              },
              onSelected: (food) {
                _nameController.text = food.name;
                _kcalController.text = _formatNumber(food.kcalPer100g);
              },
              fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                // Keep our own controller in sync so free-typed (non-selected) names still save.
                controller.addListener(() => _nameController.text = controller.text);
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Denumire produs',
                    hintText: 'ex. Iaurt grecesc 10%',
                  ),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Introdu denumirea produsului' : null,
                );
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _kcalController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Indice caloric (kcal / 100g)',
                suffixText: 'kcal/100g',
              ),
              validator: _validatePositiveNumber,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _gramsController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Cantitate consumată', suffixText: 'g'),
              validator: _validatePositiveNumber,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Salvează'),
            ),
          ],
        ),
      ),
    );
  }

  String? _validatePositiveNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'Câmp obligatoriu';
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null || parsed <= 0) return 'Valoare invalidă';
    return null;
  }

  String _formatNumber(double value) {
    return value == value.roundToDouble() ? value.toStringAsFixed(0) : value.toString();
  }
}
