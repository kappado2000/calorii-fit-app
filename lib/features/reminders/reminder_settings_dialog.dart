import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'reminder_settings_providers.dart';

class ReminderSettingsDialog extends ConsumerWidget {
  const ReminderSettingsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(context: context, builder: (_) => const ReminderSettingsDialog());
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref, bool value) async {
    final granted = await ref.read(reminderSettingsProvider.notifier).setEnabled(value);
    if (!granted && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permite notificările pentru aplicație din setările telefonului.')),
      );
    }
  }

  Future<void> _pickTime(BuildContext context, WidgetRef ref, ReminderSettings settings) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: settings.hour, minute: settings.minute),
      helpText: 'Ora mementoului',
    );
    if (picked != null) {
      await ref.read(reminderSettingsProvider.notifier).setTime(picked.hour, picked.minute);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(reminderSettingsProvider);

    return AlertDialog(
      title: const Text('Memento zilnic'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Notificare zilnică'),
            subtitle: const Text('O rememorare să-ți loghezi mesele'),
            value: settings.enabled,
            onChanged: (value) => _toggle(context, ref, value),
          ),
          if (settings.enabled)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule_rounded),
              title: const Text('Ora'),
              trailing: Text(
                '${settings.hour.toString().padLeft(2, '0')}:${settings.minute.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () => _pickTime(context, ref, settings),
            ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Închide')),
      ],
    );
  }
}
