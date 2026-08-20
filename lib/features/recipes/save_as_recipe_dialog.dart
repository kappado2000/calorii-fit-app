import 'package:flutter/material.dart';

import '../../data/models/recipe.dart';
import '../../l10n/app_localizations.dart';
import 'recipe_icon.dart';

/// Name the recipe wraps, plus its representative icon.
typedef SaveAsRecipeResult = ({String name, String icon});

/// Shared "name it and pick an icon" prompt for turning a set of foods
/// already being logged together (a photo with several detected items, or
/// several checked quick-add foods) directly into a reusable [Recipe] —
/// used from both FoodConfirmationScreen and AddFoodEntrySheet so saving a
/// combo as a recipe looks and behaves the same everywhere it's offered.
Future<SaveAsRecipeResult?> showSaveAsRecipeDialog(BuildContext context, {String? suggestedIcon}) {
  return showDialog<SaveAsRecipeResult>(
    context: context,
    builder: (_) => _SaveAsRecipeDialog(suggestedIcon: suggestedIcon),
  );
}

class _SaveAsRecipeDialog extends StatefulWidget {
  const _SaveAsRecipeDialog({this.suggestedIcon});

  final String? suggestedIcon;

  @override
  State<_SaveAsRecipeDialog> createState() => _SaveAsRecipeDialogState();
}

class _SaveAsRecipeDialogState extends State<_SaveAsRecipeDialog> {
  final _nameController = TextEditingController();
  late String _icon;

  @override
  void initState() {
    super.initState();
    _icon = widget.suggestedIcon ?? kDefaultRecipeIcon;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _changeIcon() async {
    final chosen = await pickRecipeIcon(context, current: _icon, suggested: widget.suggestedIcon);
    if (chosen != null) setState(() => _icon = chosen);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canSave = _nameController.text.trim().isNotEmpty;

    return AlertDialog(
      title: Text(l10n.saveAsRecipeDialogTitle),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _changeIcon,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(_icon, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.recipeNameLabel, hintText: l10n.recipeNameHint),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: !canSave
              ? null
              : () => Navigator.of(context).pop((name: _nameController.text.trim(), icon: _icon)),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
