import 'package:flutter/material.dart';

import '../../data/models/recipe.dart';
import '../../l10n/app_localizations.dart';

/// Curated set of food emoji a recipe can be tagged with — broad enough to
/// cover common meal shapes without turning into a full emoji keyboard.
const List<String> kRecipeIconOptions = [
  kDefaultRecipeIcon,
  '🍗',
  '🥩',
  '🐟',
  '🍳',
  '🥗',
  '🍝',
  '🍕',
  '🍲',
  '🍜',
  '🍛',
  '🍱',
  '🥘',
  '🥞',
  '🥪',
  '🌮',
  '🍔',
  '🍟',
  '🍚',
  '🥦',
  '🥑',
  '🍎',
  '🍫',
  '🍰',
  '☕',
  '🍹',
];

/// Keyword → emoji groups, checked in order against ingredient names
/// (Romanian and English keywords, case-insensitive substring match) —
/// deliberately simple rather than exhaustive, since it only needs to
/// produce a reasonable starting suggestion the user can override.
const List<(List<String>, String)> _keywordGroups = [
  (['pui', 'pasare', 'curcan', 'chicken', 'turkey'], '🍗'),
  (['vita', 'porc', 'miel', 'carne', 'beef', 'pork', 'steak', 'ceafa'], '🥩'),
  (['peste', 'somon', 'ton', 'fish', 'salmon', 'tuna', 'cod'], '🐟'),
  (['ou ', 'oua', 'omleta', 'egg'], '🍳'),
  (['salata', 'salad', 'verdeturi'], '🥗'),
  (['paste', 'pasta', 'spaghete', 'macaroane', 'noodle'], '🍝'),
  (['pizza'], '🍕'),
  (['supa', 'ciorba', 'soup', 'tocanita', 'stew'], '🍲'),
  (['clatite', 'pancake'], '🥞'),
  (['sandwich', 'sandvis', 'tost'], '🥪'),
  (['taco'], '🌮'),
  (['burger', 'hamburger'], '🍔'),
  (['cartofi prajiti', 'fries'], '🍟'),
  (['orez', 'rice'], '🍚'),
  (['legume', 'broccoli', 'vegetable'], '🥦'),
  (['avocado'], '🥑'),
  (['mar', 'banana', 'fruct', 'fruit', 'apple'], '🍎'),
  (['ciocolata', 'chocolate'], '🍫'),
  (['tort', 'prajitura', 'cake', 'desert', 'dessert'], '🍰'),
  (['cafea', 'coffee'], '☕'),
  (['smoothie', 'shake', 'suc'], '🍹'),
];

/// Suggests an icon from the first ingredient name that matches a known
/// keyword group — callers typically pass ingredients sorted by calories
/// (highest first) so the predominant food wins ties.
String suggestRecipeIcon(Iterable<String> ingredientNames) {
  for (final name in ingredientNames) {
    final lower = name.toLowerCase();
    for (final (keywords, emoji) in _keywordGroups) {
      if (keywords.any(lower.contains)) return emoji;
    }
  }
  return kDefaultRecipeIcon;
}

/// Opens a grid picker for one of [kRecipeIconOptions], with an optional
/// one-tap suggestion derived from the recipe's current ingredients.
/// Returns the chosen emoji, or null if dismissed without a selection.
Future<String?> pickRecipeIcon(BuildContext context, {required String current, String? suggested}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _RecipeIconPickerSheet(current: current, suggested: suggested),
  );
}

class _RecipeIconPickerSheet extends StatelessWidget {
  const _RecipeIconPickerSheet({required this.current, this.suggested});

  final String current;
  final String? suggested;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.chooseRecipeIconTitle, style: Theme.of(context).textTheme.titleLarge),
            if (suggested != null && suggested != current) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(suggested),
                icon: Text(suggested!, style: const TextStyle(fontSize: 18)),
                label: Text(l10n.recipeIconSuggested),
              ),
            ],
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 5,
              shrinkWrap: true,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                for (final emoji in kRecipeIconOptions)
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.of(context).pop(emoji),
                    child: Container(
                      decoration: BoxDecoration(
                        color: emoji == current ? colorScheme.primaryContainer : colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(emoji, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
