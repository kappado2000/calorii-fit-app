import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Lets the user correct the portion of an already-logged food entry —
/// covers the common case of misjudging a portion at logging time (or a
/// rough photo-analysis estimate that needed a bigger correction than the
/// confirmation screen's slider offered) without having to delete and
/// re-add the entry. Calories/macros are derived from the entry's existing
/// per-100g values, unaffected by this dialog — only grams changes.
Future<double?> showEditGramsDialog(BuildContext context, {required double initialGrams}) {
  return showDialog<double>(
    context: context,
    builder: (_) => _EditGramsDialog(initialGrams: initialGrams),
  );
}

class _EditGramsDialog extends StatefulWidget {
  const _EditGramsDialog({required this.initialGrams});

  final double initialGrams;

  @override
  State<_EditGramsDialog> createState() => _EditGramsDialogState();
}

class _EditGramsDialogState extends State<_EditGramsDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final grams = widget.initialGrams;
    final text = grams == grams.roundToDouble() ? grams.toStringAsFixed(0) : grams.toString();
    _controller = TextEditingController(text: text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validate(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) return l10n.requiredField;
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null || parsed <= 0) return l10n.invalidValue;
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final grams = double.parse(_controller.text.replaceAll(',', '.'));
    Navigator.of(context).pop(grams);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.editGramsDialogTitle),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: l10n.quantityEatenLabel, suffixText: 'g'),
          validator: (value) => _validate(l10n, value),
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        FilledButton(onPressed: _submit, child: Text(l10n.save)),
      ],
    );
  }
}
