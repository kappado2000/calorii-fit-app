import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/meal_type.dart';
import '../../data/models/recipe.dart';
import '../../l10n/app_localizations.dart';
import 'recipe_editor_screen.dart';
import 'recipes_providers.dart';

/// Lists saved recipes. When opened with [mealType]/[date] set (from
/// AddFoodEntrySheet, mid-logging a meal), tapping a recipe logs it
/// straight to that meal and pops. Opened from the app bar's general
/// "Rețetele mele" menu (mealType/date null), it's a pure management
/// screen — tapping a recipe instead opens a small meal-type picker
/// first, since there's no meal already in context to log into.
class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key, this.mealType, this.date});

  final MealType? mealType;
  final DateTime? date;

  bool get _isLoggingMode => mealType != null && date != null;

  Future<void> _handleTap(BuildContext context, WidgetRef ref, Recipe recipe) async {
    final l10n = AppLocalizations.of(context);
    if (_isLoggingMode) {
      await ref.read(recipesProvider.notifier).logServings(recipe, mealType: mealType!, date: date!);
      if (context.mounted) Navigator.of(context).pop(true);
      return;
    }
    final chosen = await showModalBottomSheet<MealType>(
      context: context,
      builder: (_) => _MealTypePickerSheet(recipeName: recipe.name),
    );
    if (chosen != null && context.mounted) {
      await ref.read(recipesProvider.notifier).logServings(recipe, mealType: chosen, date: DateTime.now());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.recipeAddedToday(recipe.name))));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipesProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(_isLoggingMode ? l10n.chooseARecipe : l10n.myRecipes)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RecipeEditorScreen())),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.newRecipe),
      ),
      body: recipes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.noRecipesYet,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              itemCount: recipes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Card(
                  child: ListTile(
                    onTap: () => _handleTap(context, ref, recipe),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(recipe.icon, style: const TextStyle(fontSize: 18)),
                    ),
                    title: Text(recipe.name),
                    subtitle: Text(
                      l10n.recipeServingsSummary(
                        recipe.servings,
                        (recipe.kcalPer100g * recipe.perServingGrams / 100).round(),
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => RecipeEditorScreen(existing: recipe)),
                          );
                        } else if (value == 'delete') {
                          ref.read(recipesProvider.notifier).deleteRecipe(recipe.id);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                        PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _MealTypePickerSheet extends StatelessWidget {
  const _MealTypePickerSheet({required this.recipeName});

  final String recipeName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l10n.addRecipeTo(recipeName), style: Theme.of(context).textTheme.titleMedium),
          ),
          for (final mealType in MealType.values)
            ListTile(title: Text(mealType.label(l10n)), onTap: () => Navigator.of(context).pop(mealType)),
        ],
      ),
    );
  }
}
