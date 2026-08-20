import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
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
        SnackBar(content: Text(AppLocalizations.of(context).reminderPermissionDenied)),
      );
    }
  }

  Future<void> _pickTime(BuildContext context, WidgetRef ref, ReminderSettings settings) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: settings.hour, minute: settings.minute),
      helpText: AppLocalizations.of(context).reminderTimePickerHelp,
    );
    if (picked != null) {
      await ref.read(reminderSettingsProvider.notifier).setTime(picked.hour, picked.minute);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(reminderSettingsProvider);
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.reminderDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.reminderDailyNotification),
            subtitle: Text(l10n.reminderDailyNotificationSubtitle),
            value: settings.enabled,
            onChanged: (value) => _toggle(context, ref, value),
          ),
          if (settings.enabled)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule_rounded),
              title: Text(l10n.reminderTimeLabel),
              trailing: Text(
                '${settings.hour.toString().padLeft(2, '0')}:${settings.minute.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () => _pickTime(context, ref, settings),
            ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.close)),
      ],
    );
  }
}
