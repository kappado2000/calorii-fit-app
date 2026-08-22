import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/food_product.dart';
import '../../data/models/recipe.dart';
import '../../l10n/app_localizations.dart';
import '../food_log/food_log_providers.dart';
import 'recipe_icon.dart';
import 'recipes_providers.dart';

/// Create or edit a [Recipe]: a name, a serving count, and a list of
/// ingredients (each added via the same product search used elsewhere in
/// the app). Saves as one document — there's no per-ingredient sync with
/// the source product, by design (see Recipe's doc comment).
class RecipeEditorScreen extends ConsumerStatefulWidget {
  const RecipeEditorScreen({super.key, this.existing});

  final Recipe? existing;

  @override
  ConsumerState<RecipeEditorScreen> createState() => _RecipeEditorScreenState();
}

class _RecipeEditorScreenState extends ConsumerState<RecipeEditorScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _servingsController;
  late final List<RecipeIngredient> _ingredients;
  late String _icon;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _servingsController = TextEditingController(text: '${existing?.servings ?? 1}');
    _ingredients = [...?existing?.ingredients];
    _icon = existing?.icon ?? kDefaultRecipeIcon;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _servingsController.dispose();
    super.dispose();
  }

  Recipe get _previewRecipe => Recipe(
    id: widget.existing?.id ?? '',
    name: _nameController.text,
    servings: int.tryParse(_servingsController.text) ?? 1,
    ingredients: _ingredients,
    icon: _icon,
  );

  Future<void> _addIngredient() async {
    final ingredient = await showModalBottomSheet<RecipeIngredient>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddIngredientSheet(),
    );
    if (ingredient != null) setState(() => _ingredients.add(ingredient));
  }

  Future<void> _editIngredientQuantity(int index) async {
    final grams = await showEditIngredientQuantityDialog(context, current: _ingredients[index].grams);
    if (grams == null) return;
    setState(() {
      final ingredient = _ingredients[index];
      _ingredients[index] = RecipeIngredient(
        name: ingredient.name,
        grams: grams,
        kcalPer100g: ingredient.kcalPer100g,
        proteinPer100g: ingredient.proteinPer100g,
        carbsPer100g: ingredient.carbsPer100g,
        fatPer100g: ingredient.fatPer100g,
        micronutrients: ingredient.micronutrients,
      );
    });
  }

  Future<void> _changeIcon() async {
    final byCalories = [..._ingredients]..sort((a, b) => b.calories.compareTo(a.calories));
    final suggested = suggestRecipeIcon(byCalories.map((i) => i.name));
    final chosen = await pickRecipeIcon(context, current: _icon, suggested: suggested);
    if (chosen != null) setState(() => _icon = chosen);
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final servings = int.tryParse(_servingsController.text) ?? 0;
    if (name.isEmpty || servings <= 0 || _ingredients.isEmpty) return;

    setState(() => _saving = true);
    await ref
        .read(recipesProvider.notifier)
        .saveRecipe(
          id: widget.existing?.id,
          name: name,
          servings: servings,
          ingredients: _ingredients,
          icon: _icon,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final preview = _previewRecipe;
    final canSave = _nameController.text.trim().isNotEmpty &&
        (int.tryParse(_servingsController.text) ?? 0) > 0 &&
        _ingredients.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? l10n.newRecipe : l10n.editRecipe)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Center(
            child: GestureDetector(
              onTap: _changeIcon,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text(_icon, style: const TextStyle(fontSize: 32)),
                  ),
                  Positioned(
                    right: -4,
                    bottom: -4,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(Icons.edit_rounded, size: 14, color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: l10n.recipeNameLabel, hintText: l10n.recipeNameHint),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _servingsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.numberOfServings),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.ingredients, style: Theme.of(context).textTheme.titleMedium),
              TextButton.icon(
                onPressed: _addIngredient,
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.addLabel),
              ),
            ],
          ),
          if (_ingredients.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                l10n.addAtLeastOneIngredient,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outline),
              ),
            )
          else
            for (final (index, ingredient) in _ingredients.indexed)
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () => _editIngredientQuantity(index),
                title: Text(ingredient.name),
                subtitle: Text('${ingredient.grams.round()} g · ${ingredient.calories.round()} kcal'),
                trailing: IconButton(
                  tooltip: l10n.delete,
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => setState(() => _ingredients.removeAt(index)),
                ),
              ),
          if (_ingredients.isNotEmpty) ...[
            const Divider(height: 32),
            _RecipeSummary(recipe: preview),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: (!canSave || _saving) ? null : _save,
            child: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.saveRecipe),
          ),
        ),
      ),
    );
  }
}

class _RecipeSummary extends StatelessWidget {
  const _RecipeSummary({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String fmt(double? v) => v == null ? '—' : '${v.round()}g';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.perServing(
              recipe.perServingGrams.round(),
              (recipe.kcalPer100g * recipe.perServingGrams / 100).round(),
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.macroSummaryLine(
              fmt(recipe.proteinPer100g == null ? null : recipe.proteinPer100g! * recipe.perServingGrams / 100),
              fmt(recipe.carbsPer100g == null ? null : recipe.carbsPer100g! * recipe.perServingGrams / 100),
              fmt(recipe.fatPer100g == null ? null : recipe.fatPer100g! * recipe.perServingGrams / 100),
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _AddIngredientSheet extends ConsumerStatefulWidget {
  const _AddIngredientSheet();

  @override
  ConsumerState<_AddIngredientSheet> createState() => _AddIngredientSheetState();
}

class _AddIngredientSheetState extends ConsumerState<_AddIngredientSheet> {
  final _queryController = TextEditingController();
  final _gramsController = TextEditingController();
  FoodProduct? _selected;

  @override
  void dispose() {
    _queryController.dispose();
    _gramsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final searchState = ref.watch(foodSearchProvider);
    final grams = double.tryParse(_gramsController.text.replaceAll(',', '.'));

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
          Text(l10n.addIngredientTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _queryController,
            enabled: _selected == null,
            decoration: InputDecoration(
              labelText: l10n.productNameLabel,
              suffixIcon: _selected != null
                  ? IconButton(
                      tooltip: l10n.clearSelection,
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _selected = null),
                    )
                  : const Icon(Icons.search),
            ),
            onChanged: (value) {
              ref.read(foodSearchProvider.notifier).search(value);
              setState(() {});
            },
          ),
          if (_selected == null && _queryController.text.trim().length >= 2) ...[
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 240),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              child: searchState.results.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(l10n.noProductFound),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: searchState.results.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final product = searchState.results[index];
                        return ListTile(
                          dense: true,
                          title: Text(product.displayName),
                          trailing: Text('${product.kcalPer100g.round()} kcal/100g'),
                          onTap: () => setState(() {
                            _selected = product;
                            _queryController.text = product.name;
                          }),
                        );
                      },
                    ),
            ),
          ],
          if (_selected != null) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _gramsController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.quantityLabel, suffixText: 'g'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: (grams == null || grams <= 0)
                  ? null
                  : () => Navigator.of(context).pop(
                        RecipeIngredient(
                          name: _selected!.name,
                          grams: grams,
                          kcalPer100g: _selected!.kcalPer100g,
                          proteinPer100g: _selected!.proteinPer100g,
                          carbsPer100g: _selected!.carbsPer100g,
                          fatPer100g: _selected!.fatPer100g,
                          micronutrients: _selected!.micronutrients,
                        ),
                      ),
              child: Text(l10n.addIngredientButton),
            ),
          ],
        ],
      ),
    );
  }
}

/// Small numeric dialog for adjusting an already-added ingredient's
/// quantity without going through the full product search again — the
/// product identity and its per-100g values don't change, only the grams.
Future<double?> showEditIngredientQuantityDialog(BuildContext context, {required double current}) {
  return showDialog<double>(
    context: context,
    builder: (_) => _EditIngredientQuantityDialog(current: current),
  );
}

class _EditIngredientQuantityDialog extends StatefulWidget {
  const _EditIngredientQuantityDialog({required this.current});

  final double current;

  @override
  State<_EditIngredientQuantityDialog> createState() => _EditIngredientQuantityDialogState();
}

class _EditIngredientQuantityDialogState extends State<_EditIngredientQuantityDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.current.round().toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final grams = double.tryParse(_controller.text.replaceAll(',', '.'));
    return AlertDialog(
      title: Text(l10n.editIngredientQuantityTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: l10n.quantityLabel, suffixText: 'g'),
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) {
          if (grams != null && grams > 0) Navigator.of(context).pop(grams);
        },
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: (grams == null || grams <= 0) ? null : () => Navigator.of(context).pop(grams),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
