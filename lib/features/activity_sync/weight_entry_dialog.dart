import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/weight_entry.dart';
import '../../l10n/app_localizations.dart';
import '../profile/profile_providers.dart';

/// Add or edit a manual weight entry — full date *and* time (not just the
/// day), since more than one weigh-in on the same calendar day needs to
/// stay orderable, and "just now" should be the default without extra taps.
class WeightEntryDialog extends ConsumerStatefulWidget {
  const WeightEntryDialog({super.key, this.existing});

  final WeightEntry? existing;

  static Future<void> show(BuildContext context, {WeightEntry? existing}) {
    return showDialog(context: context, builder: (_) => WeightEntryDialog(existing: existing));
  }

  @override
  ConsumerState<WeightEntryDialog> createState() => _WeightEntryDialogState();
}

class _WeightEntryDialogState extends ConsumerState<WeightEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _weightController;
  late DateTime _dateTime;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _weightController = TextEditingController(
      text: existing == null ? '' : _formatWeight(existing.weightKg),
    );
    _dateTime = existing?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  String _formatWeight(double kg) => kg == kg.roundToDouble() ? kg.toStringAsFixed(0) : kg.toString();

  Future<void> _pickDateTime() async {
    final l10n = AppLocalizations.of(context);
    final date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: l10n.weighInDateHelp,
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
      helpText: l10n.weighInTimeHelp,
    );
    if (time == null) return;
    setState(() {
      _dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final weightKg = double.parse(_weightController.text.replaceAll(',', '.'));
    setState(() => _saving = true);
    final controller = ref.read(profileControllerProvider);
    if (widget.existing != null) {
      await controller.updateWeight(widget.existing!.id, date: _dateTime, weightKg: weightKg);
    } else {
      await controller.logWeight(weightKg, date: _dateTime);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    setState(() => _saving = true);
    await ref.read(profileControllerProvider).deleteWeight(widget.existing!.id);
    if (mounted) Navigator.of(context).pop();
  }

  String _formatDateTime(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d.$m.${dt.year}, $h:$min';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.existing == null ? l10n.addWeightTitle : l10n.editWeightTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _weightController,
              autofocus: widget.existing == null,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.weight, suffixText: 'kg'),
              validator: (value) {
                final parsed = double.tryParse((value ?? '').replaceAll(',', '.'));
                if (parsed == null || parsed <= 0 || parsed > 400) return l10n.invalidValue;
                return null;
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule_rounded),
              title: Text(_formatDateTime(_dateTime)),
              onTap: _pickDateTime,
            ),
          ],
        ),
      ),
      actions: [
        if (widget.existing != null)
          TextButton(
            onPressed: _saving ? null : _delete,
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: Text(l10n.delete),
          ),
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        FilledButton(onPressed: _saving ? null : _save, child: Text(l10n.save)),
      ],
    );
  }
}
