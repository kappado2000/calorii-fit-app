import 'package:flutter/material.dart';

import '../../data/models/recipe.dart';
import '../../l10n/app_localizations.dart';

/// Curated set of food emoji a recipe can be tagged with — organized by
/// category (proteins, grains, vegetables, fruits, dairy, prepared dishes,
/// desserts, drinks) for broad coverage without turning into a full emoji
/// keyboard.
const List<String> kRecipeIconOptions = [
  kDefaultRecipeIcon,
  // Proteins
  '🍗', '🥩', '🍖', '🐟', '🍤', '🍳', '🥚', '🥓',
  // Grains & bread
  '🍝', '🍚', '🍞', '🥐', '🥯',
  // Vegetables
  '🥦', '🥕', '🌽', '🥔', '🍅', '🥒', '🧄', '🧅', '🥬',
  // Fruits
  '🍎', '🍌', '🍇', '🍓', '🍊', '🍋', '🍒', '🍑', '🥝', '🍍', '🥥', '🥑',
  // Dairy & breakfast
  '🧀', '🥛', '🥞', '🧇', '🥪',
  // Prepared dishes
  '🍕', '🍲', '🍜', '🍛', '🍱', '🥘', '🌮', '🌯', '🥙', '🍣', '🥟', '🥗', '🍔', '🍟',
  // Desserts & snacks
  '🍰', '🧁', '🍪', '🍩', '🍦', '🍨', '🥧', '🍫', '🍿',
  // Drinks
  '☕', '🍵', '🍹', '🧃', '🥤',
];

/// Keyword → emoji groups, checked in order against ingredient names
/// (Romanian and English keywords, case-insensitive substring match) —
/// deliberately simple rather than exhaustive, since it only needs to
/// produce a reasonable starting suggestion the user can override.
const List<(List<String>, String)> _keywordGroups = [
  (['pui', 'pasare', 'curcan', 'chicken', 'turkey'], '🍗'),
  (['vita', 'porc', 'miel', 'carne', 'beef', 'pork', 'steak', 'ceafa'], '🥩'),
  (['slanina', 'bacon'], '🥓'),
  (['peste', 'somon', 'ton', 'fish', 'salmon', 'tuna', 'cod'], '🐟'),
  (['creveti', 'shrimp', 'prawn'], '🍤'),
  (['ou ', 'oua', 'omleta', 'egg'], '🍳'),
  (['salata', 'salad', 'verdeturi'], '🥗'),
  (['paste', 'pasta', 'spaghete', 'macaroane', 'noodle'], '🍝'),
  (['orez', 'rice'], '🍚'),
  (['paine', 'bread'], '🍞'),
  (['croissant', 'cornet'], '🥐'),
  (['covrig', 'bagel'], '🥯'),
  (['legume', 'broccoli', 'vegetable'], '🥦'),
  (['morcov', 'carrot'], '🥕'),
  (['porumb', 'corn'], '🌽'),
  (['cartofi prajiti', 'fries'], '🍟'),
  (['cartof', 'potato'], '🥔'),
  (['rosie', 'rosii', 'tomate', 'tomato'], '🍅'),
  (['castravete', 'cucumber'], '🥒'),
  (['usturoi', 'garlic'], '🧄'),
  (['ceapa', 'onion'], '🧅'),
  (['spanac', 'kale'], '🥬'),
  (['avocado'], '🥑'),
  (['mar', 'apple'], '🍎'),
  (['banana'], '🍌'),
  (['strugur', 'grape'], '🍇'),
  (['capsuna', 'strawberry'], '🍓'),
  (['portocala', 'orange'], '🍊'),
  (['lamaie', 'lemon'], '🍋'),
  (['cirese', 'visine', 'cherry'], '🍒'),
  (['piersica', 'peach'], '🍑'),
  (['kiwi'], '🥝'),
  (['ananas', 'pineapple'], '🍍'),
  (['cocos', 'coconut'], '🥥'),
  (['fruct', 'fruit'], '🍎'),
  (['cascaval', 'branza', 'urda', 'telemea', 'mozzarella', 'cheese'], '🧀'),
  (['lapte', 'milk'], '🥛'),
  (['clatite', 'pancake'], '🥞'),
  (['vafe', 'waffle'], '🧇'),
  (['sandwich', 'sandvis', 'tost'], '🥪'),
  (['pizza'], '🍕'),
  (['supa', 'ciorba', 'soup', 'tocanita', 'stew'], '🍲'),
  (['sushi'], '🍣'),
  (['gogosi de aluat', 'dumpling'], '🥟'),
  (['taco'], '🌮'),
  (['burrito'], '🌯'),
  (['shaorma', 'gyros', 'pita', 'gyro'], '🥙'),
  (['burger', 'hamburger'], '🍔'),
  (['tort', 'prajitura', 'cake', 'desert', 'dessert'], '🍰'),
  (['briosa', 'cupcake'], '🧁'),
  (['fursec', 'cookie'], '🍪'),
  (['gogoasa', 'donut', 'doughnut'], '🍩'),
  (['inghetata', 'ice cream'], '🍦'),
  (['placinta', 'pie'], '🥧'),
  (['ciocolata', 'chocolate'], '🍫'),
  (['popcorn', 'floricele'], '🍿'),
  (['cafea', 'coffee'], '☕'),
  (['ceai', 'tea'], '🍵'),
  (['smoothie', 'shake'], '🍹'),
  (['suc', 'juice'], '🧃'),
  (['limonada', 'soda', 'cola'], '🥤'),
];

/// Suggests an icon from the first ingredient name that matches a known
/// keyword group — callers typically pass ingredients sorted by calories
/// (highest first) so the predominant food wins ties.
String suggestRecipeIcon(Iterable<String> ingredientNames) {
  for (final name in ingredientNames) {
    final normalized = _stripDiacritics(name.toLowerCase());
    for (final (keywords, emoji) in _keywordGroups) {
      if (keywords.any(normalized.contains)) return emoji;
    }
  }
  return kDefaultRecipeIcon;
}

/// Romanian diacritics → plain ASCII, so keywords only need to be written
/// once (e.g. "cascaval") and still match however the user typed the
/// ingredient name ("Cașcaval", "cascaval", "Caşcaval" with the cedilla
/// variant some keyboards produce).
String _stripDiacritics(String s) {
  const from = 'ăâîșşțţĂÂÎȘŞȚŢ';
  const to = 'aaisstAAISSTT';
  var result = s;
  for (var i = 0; i < from.length; i++) {
    result = result.replaceAll(from[i], to[i]);
  }
  return result;
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

    // A fixed-height scrolling grid rather than shrinkWrap-inside-Flexible —
    // that combination left the grid effectively unresponsive to taps and
    // clipped most of the icon set on some screen sizes. A definite height
    // sidesteps the ambiguity entirely and always leaves the full list
    // reachable by scrolling.
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
            SizedBox(
              height: 340,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: kRecipeIconOptions.length,
                itemBuilder: (context, index) {
                  final emoji = kRecipeIconOptions[index];
                  return InkWell(
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
