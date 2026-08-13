import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/food_product.dart';
import '../../data/models/meal_type.dart';
import 'food_log_providers.dart';

/// Bottom sheet for logging a product. The user types a name, the app
/// searches commercial products (Open Food Facts) merged with previously
/// remembered ones, and once a product is picked the app determines the
/// calorie index and macros — the user only supplies the grams eaten. A
/// manual fallback (editable calorie index, optional macros) covers
/// products the search can't find.
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
  final _queryController = TextEditingController();
  final _gramsController = TextEditingController();
  final _manualKcalController = TextEditingController();
  final _manualProteinController = TextEditingController();
  final _manualCarbsController = TextEditingController();
  final _manualFatController = TextEditingController();

  FoodProduct? _selectedProduct;
  bool _manualMode = false;
  bool _saving = false;

  @override
  void dispose() {
    _queryController.dispose();
    _gramsController.dispose();
    _manualKcalController.dispose();
    _manualProteinController.dispose();
    _manualCarbsController.dispose();
    _manualFatController.dispose();
    super.dispose();
  }

  void _selectProduct(FoodProduct product) {
    setState(() {
      _selectedProduct = product;
      _queryController.text = product.name;
      _manualMode = false;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedProduct = null;
      _manualKcalController.clear();
      _manualProteinController.clear();
      _manualCarbsController.clear();
      _manualFatController.clear();
    });
  }

  void _startManualEntry() {
    setState(() => _manualMode = true);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final name = _queryController.text.trim();
    final grams = double.parse(_gramsController.text.replaceAll(',', '.'));

    final double kcalPer100g;
    final double? proteinPer100g;
    final double? carbsPer100g;
    final double? fatPer100g;

    if (_selectedProduct != null) {
      kcalPer100g = _selectedProduct!.kcalPer100g;
      proteinPer100g = _selectedProduct!.proteinPer100g;
      carbsPer100g = _selectedProduct!.carbsPer100g;
      fatPer100g = _selectedProduct!.fatPer100g;
    } else {
      kcalPer100g = double.parse(_manualKcalController.text.replaceAll(',', '.'));
      proteinPer100g = _parseOptional(_manualProteinController.text);
      carbsPer100g = _parseOptional(_manualCarbsController.text);
      fatPer100g = _parseOptional(_manualFatController.text);
    }

    await ref
        .read(customFoodsProvider.notifier)
        .rememberProduct(
          name: name,
          kcalPer100g: kcalPer100g,
          proteinPer100g: proteinPer100g,
          carbsPer100g: carbsPer100g,
          fatPer100g: fatPer100g,
        );
    await ref
        .read(dailyLogProvider(widget.date).notifier)
        .addEntry(
          mealType: widget.mealType,
          foodName: name,
          grams: grams,
          kcalPer100g: kcalPer100g,
          proteinPer100g: proteinPer100g,
          carbsPer100g: carbsPer100g,
          fatPer100g: fatPer100g,
        );

    if (mounted) Navigator.of(context).pop();
  }

  double? _parseOptional(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed.replaceAll(',', '.'));
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(foodSearchProvider);
    final query = _queryController.text.trim();
    final showResultsList = _selectedProduct == null && !_manualMode && query.length >= 2;

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
            TextFormField(
              controller: _queryController,
              enabled: _selectedProduct == null,
              decoration: InputDecoration(
                labelText: 'Denumire produs',
                hintText: 'ex. Iaurt grecesc',
                suffixIcon: _selectedProduct != null
                    ? IconButton(icon: const Icon(Icons.close), onPressed: _clearSelection)
                    : const Icon(Icons.search),
              ),
              onChanged: (value) {
                ref.read(foodSearchProvider.notifier).search(value);
                setState(() {});
              },
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Introdu denumirea produsului' : null,
            ),
            if (showResultsList) ...[
              const SizedBox(height: 8),
              _SearchResultsList(
                state: searchState,
                onSelect: _selectProduct,
                onManualEntry: _startManualEntry,
              ),
            ],
            if (_selectedProduct != null) ...[
              const SizedBox(height: 12),
              _ProductNutritionCard(product: _selectedProduct!),
            ],
            if (_manualMode) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _manualKcalController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Indice caloric (kcal / 100g)',
                  suffixText: 'kcal/100g',
                ),
                validator: _validatePositiveNumber,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _manualProteinController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Proteine', suffixText: 'g/100g'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _manualCarbsController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Carbohidrați', suffixText: 'g/100g'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _manualFatController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Grăsimi', suffixText: 'g/100g'),
                    ),
                  ),
                ],
              ),
            ],
            if (_selectedProduct != null || _manualMode) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _gramsController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Cantitate consumată', suffixText: 'g'),
                validator: _validatePositiveNumber,
                onChanged: (_) => setState(() {}),
              ),
              _GramsPreview(
                grams: double.tryParse(_gramsController.text.replaceAll(',', '.')),
                kcalPer100g: _selectedProduct?.kcalPer100g ?? double.tryParse(
                  _manualKcalController.text.replaceAll(',', '.'),
                ),
                proteinPer100g: _selectedProduct?.proteinPer100g ?? _parseOptional(_manualProteinController.text),
                carbsPer100g: _selectedProduct?.carbsPer100g ?? _parseOptional(_manualCarbsController.text),
                fatPer100g: _selectedProduct?.fatPer100g ?? _parseOptional(_manualFatController.text),
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
}

class _SearchResultsList extends StatelessWidget {
  const _SearchResultsList({required this.state, required this.onSelect, required this.onManualEntry});

  final FoodSearchState state;
  final ValueChanged<FoodProduct> onSelect;
  final VoidCallback onManualEntry;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 260),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.isSearchingRemote)
            const Padding(
              padding: EdgeInsets.all(8),
              child: LinearProgressIndicator(minHeight: 2),
            ),
          if (state.results.isEmpty && !state.isSearchingRemote)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    state.hadRemoteError
                        ? 'Căutarea nu a putut fi realizată (verifică conexiunea).'
                        : 'Niciun produs găsit.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  TextButton(onPressed: onManualEntry, child: const Text('Adaugă produs manual')),
                ],
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: state.results.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final product = state.results[index];
                  return ListTile(
                    dense: true,
                    title: Text(product.displayName),
                    subtitle: Text(_macroSummary(product)),
                    trailing: Text('${product.kcalPer100g.round()} kcal/100g'),
                    onTap: () => onSelect(product),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  String _macroSummary(FoodProduct product) {
    final parts = <String>[];
    if (product.proteinPer100g != null) parts.add('P ${product.proteinPer100g!.round()}g');
    if (product.carbsPer100g != null) parts.add('C ${product.carbsPer100g!.round()}g');
    if (product.fatPer100g != null) parts.add('G ${product.fatPer100g!.round()}g');
    return parts.isEmpty ? 'Macro-nutrienți indisponibili' : parts.join(' · ');
  }
}

class _ProductNutritionCard extends StatelessWidget {
  const _ProductNutritionCard({required this.product});

  final FoodProduct product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${product.kcalPer100g.round()} kcal / 100g', style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  _macroLine(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _macroLine() {
    String fmt(double? v) => v == null ? '—' : '${v.round()}g';
    return 'Proteine ${fmt(product.proteinPer100g)} · Carbohidrați ${fmt(product.carbsPer100g)} · Grăsimi ${fmt(product.fatPer100g)} (per 100g)';
  }
}

class _GramsPreview extends StatelessWidget {
  const _GramsPreview({
    required this.grams,
    required this.kcalPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
  });

  final double? grams;
  final double? kcalPer100g;
  final double? proteinPer100g;
  final double? carbsPer100g;
  final double? fatPer100g;

  @override
  Widget build(BuildContext context) {
    if (grams == null || grams! <= 0 || kcalPer100g == null) return const SizedBox.shrink();

    final factor = grams! / 100;
    String fmt(double? per100g) => per100g == null ? '—' : '${(per100g * factor).round()}g';

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        '${(kcalPer100g! * factor).round()} kcal · Proteine ${fmt(proteinPer100g)} · '
        'Carbohidrați ${fmt(carbsPer100g)} · Grăsimi ${fmt(fatPer100g)}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
