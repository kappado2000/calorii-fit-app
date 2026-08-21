import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/micronutrient_reference.dart';
import '../../data/models/custom_food.dart';
import '../../data/models/food_product.dart';
import '../../data/models/meal_type.dart';
import '../../data/models/recipe.dart';
import '../../l10n/app_localizations.dart';
import '../admin/access_code_screen.dart';
import '../admin/admin_providers.dart';
import '../barcode_scan/barcode_scan_screen.dart';
import '../recipes/recipe_icon.dart';
import '../recipes/recipes_providers.dart';
import '../recipes/recipes_screen.dart';
import '../recipes/save_as_recipe_dialog.dart';
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
  final Set<String> _quickAddSelectedIds = {};

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

  void _toggleQuickAdd(String foodId) {
    setState(() {
      if (!_quickAddSelectedIds.remove(foodId)) _quickAddSelectedIds.add(foodId);
    });
  }

  /// Adds every checked frequent food at once, each at its remembered
  /// portion (falling back to 100g for a food never logged with a known
  /// portion) — the whole point of the checklist is not having to re-enter
  /// grams for a usual breakfast.
  Future<void> _saveQuickAdd(List<CustomFood> allFoods) async {
    setState(() => _saving = true);
    final today = widget.date;
    final selected = allFoods.where((food) => _quickAddSelectedIds.contains(food.id));
    for (final food in selected) {
      final grams = food.lastGramsUsed ?? 100;
      await ref
          .read(dailyLogProvider(today).notifier)
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
    if (mounted) Navigator.of(context).pop();
  }

  /// Saves the checked frequent foods as a new [Recipe] instead of logging
  /// them — the same "several foods entered together" moment as
  /// [_saveQuickAdd], just captured for reuse rather than for today's diary.
  Future<void> _saveQuickAddAsRecipe(List<CustomFood> allFoods) async {
    final selected = allFoods.where((food) => _quickAddSelectedIds.contains(food.id)).toList();
    if (selected.isEmpty) return;

    final byCalories = [...selected]
      ..sort((a, b) => (b.kcalPer100g * (b.lastGramsUsed ?? 100)).compareTo(a.kcalPer100g * (a.lastGramsUsed ?? 100)));
    final suggested = suggestRecipeIcon(byCalories.map((food) => food.name));

    final result = await showSaveAsRecipeDialog(context, suggestedIcon: suggested);
    if (result == null) return;

    final ingredients = selected
        .map(
          (food) => RecipeIngredient(
            name: food.name,
            grams: food.lastGramsUsed ?? 100,
            kcalPer100g: food.kcalPer100g,
            proteinPer100g: food.proteinPer100g,
            carbsPer100g: food.carbsPer100g,
            fatPer100g: food.fatPer100g,
          ),
        )
        .toList();

    await ref
        .read(recipesProvider.notifier)
        .saveRecipe(name: result.name, servings: 1, ingredients: ingredients, icon: result.icon);

    if (mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.recipeSavedConfirmation(result.name))));
    }
  }

  void _startManualEntry() {
    setState(() => _manualMode = true);
  }

  Future<void> _scanBarcode() async {
    final product = await BarcodeScanScreen.show(context);
    if (product != null) _selectProduct(product);
  }

  Future<void> _openRecipes() async {
    final logged = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => RecipesScreen(mealType: widget.mealType, date: widget.date)),
    );
    if (logged == true && mounted) Navigator.of(context).pop();
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
    final MicronutrientProfile? micronutrients;

    if (_selectedProduct != null) {
      kcalPer100g = _selectedProduct!.kcalPer100g;
      proteinPer100g = _selectedProduct!.proteinPer100g;
      carbsPer100g = _selectedProduct!.carbsPer100g;
      fatPer100g = _selectedProduct!.fatPer100g;
      micronutrients = _selectedProduct!.micronutrients;
    } else {
      kcalPer100g = double.parse(_manualKcalController.text.replaceAll(',', '.'));
      proteinPer100g = _parseOptional(_manualProteinController.text);
      carbsPer100g = _parseOptional(_manualCarbsController.text);
      fatPer100g = _parseOptional(_manualFatController.text);
      micronutrients = null;
    }

    await ref
        .read(customFoodsProvider.notifier)
        .rememberProduct(
          name: name,
          kcalPer100g: kcalPer100g,
          proteinPer100g: proteinPer100g,
          carbsPer100g: carbsPer100g,
          fatPer100g: fatPer100g,
          gramsUsed: grams,
          micronutrients: micronutrients,
          mealType: widget.mealType,
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
          micronutrients: micronutrients,
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
    final l10n = AppLocalizations.of(context);
    final searchState = ref.watch(foodSearchProvider);
    final frequentFoods = foodsRankedForMeal(ref.watch(customFoodsProvider), widget.mealType);
    final query = _queryController.text.trim();
    final showResultsList = _selectedProduct == null && !_manualMode && query.length >= 2;
    final showQuickAdd = _selectedProduct == null && !_manualMode && query.isEmpty && frequentFoods.isNotEmpty;

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
            Text(l10n.addFoodTitle(widget.mealType.label(l10n)), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _queryController,
              enabled: _selectedProduct == null,
              decoration: InputDecoration(
                labelText: l10n.productNameLabel,
                hintText: l10n.productNameHint,
                suffixIcon: _selectedProduct != null
                    ? IconButton(tooltip: l10n.clearSelection, icon: const Icon(Icons.close), onPressed: _clearSelection)
                    : IconButton(
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                        tooltip: l10n.barcodeScanTitle,
                        onPressed: _scanBarcode,
                      ),
              ),
              onChanged: (value) {
                ref.read(foodSearchProvider.notifier).search(value);
                setState(() {});
              },
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? l10n.enterProductName : null,
            ),
            if (_selectedProduct == null && !_manualMode) ...[
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _openRecipes,
                  icon: const Icon(Icons.menu_book_rounded, size: 18),
                  label: Text(l10n.myRecipes),
                ),
              ),
            ],
            if (showQuickAdd) ...[
              const SizedBox(height: 16),
              Text(l10n.frequentlyLogged, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              _QuickAddChecklist(
                foods: frequentFoods,
                selectedIds: _quickAddSelectedIds,
                onToggle: _toggleQuickAdd,
              ),
              if (_quickAddSelectedIds.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: _saving ? null : () => _saveQuickAdd(frequentFoods),
                        child: _saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(l10n.addCount(_quickAddSelectedIds.length)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: l10n.saveAsRecipeTooltip,
                      icon: const Icon(Icons.bookmark_add_outlined),
                      onPressed: _saving ? null : () => _saveQuickAddAsRecipe(frequentFoods),
                    ),
                  ],
                ),
              ],
            ],
            if (showResultsList) ...[
              const SizedBox(height: 8),
              _SearchResultsList(
                state: searchState,
                onSelect: _selectProduct,
                onManualEntry: _startManualEntry,
                onSearchWithAi: () => ref.read(foodSearchProvider.notifier).searchWithAi(),
                canUseAi: ref.watch(canUseAiFeaturesProvider),
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
                decoration: InputDecoration(
                  labelText: l10n.calorieIndexLabel,
                  suffixText: 'kcal/100g',
                ),
                validator: (value) => _validatePositiveNumber(l10n, value),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _manualProteinController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: l10n.macroProtein, suffixText: 'g/100g'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _manualCarbsController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: l10n.macroCarbs, suffixText: 'g/100g'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _manualFatController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: l10n.macroFat, suffixText: 'g/100g'),
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
                decoration: InputDecoration(labelText: l10n.quantityEatenLabel, suffixText: 'g'),
                validator: (value) => _validatePositiveNumber(l10n, value),
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
                    : Text(l10n.save),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String? _validatePositiveNumber(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) return l10n.requiredField;
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null || parsed <= 0) return l10n.invalidValue;
    return null;
  }
}

/// The "empty state" of the sheet, before the user types anything: a
/// checklist of previously-remembered foods, each at its last-used portion,
/// that can be tapped to check/uncheck and add several at once — for a
/// usual breakfast, that's faster than searching and entering grams one
/// product at a time.
class _QuickAddChecklist extends StatelessWidget {
  const _QuickAddChecklist({required this.foods, required this.selectedIds, required this.onToggle});

  final List<CustomFood> foods;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: foods.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final food = foods[index];
          final grams = food.lastGramsUsed ?? 100;
          final selected = selectedIds.contains(food.id);
          return ListTile(
            onTap: () => onToggle(food.id),
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.restaurant_rounded, size: 16, color: colorScheme.onSurfaceVariant),
            ),
            title: Text(food.name),
            subtitle: Text('${(food.kcalPer100g * grams / 100).round()} kcal/${_formatGrams(grams)} g'),
            trailing: Icon(
              selected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
              color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
          );
        },
      ),
    );
  }

  String _formatGrams(double grams) {
    return grams == grams.roundToDouble() ? grams.toStringAsFixed(0) : grams.toString();
  }
}

class _SearchResultsList extends StatelessWidget {
  const _SearchResultsList({
    required this.state,
    required this.onSelect,
    required this.onManualEntry,
    required this.onSearchWithAi,
    required this.canUseAi,
  });

  final FoodSearchState state;
  final ValueChanged<FoodProduct> onSelect;
  final VoidCallback onManualEntry;
  final VoidCallback onSearchWithAi;
  final bool canUseAi;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // The AI result (if any) always leads the list — it only exists
    // because the regular search found nothing, so it's the most relevant
    // thing to show, not an afterthought at the bottom.
    final items = [if (state.aiResult != null) state.aiResult!, ...state.results];

    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.isSearchingRemote)
            const Padding(
              padding: EdgeInsets.all(8),
              child: LinearProgressIndicator(minHeight: 2),
            ),
          if (items.isEmpty && !state.isSearchingRemote)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    state.hadRemoteError
                        ? l10n.searchFailedCheckConnection
                        : state.aiSearchAttempted
                        ? l10n.aiSearchNoResult
                        : l10n.noProductFound,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  if (state.isSearchingAi)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                  else
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      children: [
                        if (!state.hadRemoteError && !state.aiSearchAttempted)
                          canUseAi
                              ? OutlinedButton.icon(
                                  onPressed: onSearchWithAi,
                                  icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                                  label: Text(l10n.searchWithAiButton),
                                )
                              : OutlinedButton.icon(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const AccessCodeScreen()),
                                  ),
                                  icon: const Icon(Icons.lock_outline_rounded, size: 16),
                                  label: Text(l10n.searchWithAiButton),
                                ),
                        TextButton(onPressed: onManualEntry, child: Text(l10n.addProductManually)),
                      ],
                    ),
                ],
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final product = items[index];
                  return ListTile(
                    dense: true,
                    title: Row(
                      children: [
                        Flexible(child: Text(product.displayName)),
                        if (product.isAiEstimate) ...[
                          const SizedBox(width: 6),
                          _AiEstimateBadge(label: l10n.aiEstimateBadge),
                        ],
                      ],
                    ),
                    subtitle: Text(_macroSummary(l10n, product)),
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

  String _macroSummary(AppLocalizations l10n, FoodProduct product) {
    final parts = <String>[];
    if (product.proteinPer100g != null) parts.add('${l10n.macroProteinShort} ${product.proteinPer100g!.round()}g');
    if (product.carbsPer100g != null) parts.add('${l10n.macroCarbsShort} ${product.carbsPer100g!.round()}g');
    if (product.fatPer100g != null) parts.add('${l10n.macroFatShort} ${product.fatPer100g!.round()}g');
    return parts.isEmpty ? l10n.macrosUnavailable : parts.join(' · ');
  }
}

class _AiEstimateBadge extends StatelessWidget {
  const _AiEstimateBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.tertiary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome_rounded, size: 11, color: color),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 10.5)),
        ],
      ),
    );
  }
}

class _ProductNutritionCard extends StatelessWidget {
  const _ProductNutritionCard({required this.product});

  final FoodProduct product;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.local_fire_department_rounded, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${product.kcalPer100g.round()} kcal / 100g',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  _macroLine(l10n),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _macroLine(AppLocalizations l10n) {
    String fmt(double? v) => v == null ? '—' : '${v.round()}g';
    return l10n.macroSummaryLine(fmt(product.proteinPer100g), fmt(product.carbsPer100g), fmt(product.fatPer100g));
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
    final l10n = AppLocalizations.of(context);

    final factor = grams! / 100;
    String fmt(double? per100g) => per100g == null ? '—' : '${(per100g * factor).round()}g';

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        l10n.gramsPreviewLine(
          (kcalPer100g! * factor).round(),
          fmt(proteinPer100g),
          fmt(carbsPer100g),
          fmt(fatPer100g),
        ),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
