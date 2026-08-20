import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_mode_provider.dart';
import '../../l10n/app_localizations.dart';

class ThemePickerDialog extends ConsumerWidget {
  const ThemePickerDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(context: context, builder: (_) => const ThemePickerDialog());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentMode = ref.watch(themeModeProvider);

    return SimpleDialog(
      title: Text(l10n.themeDialogTitle),
      children: [
        RadioGroup<ThemeMode>(
          groupValue: currentMode,
          onChanged: (value) {
            if (value != null) ref.read(themeModeProvider.notifier).setThemeMode(value);
            Navigator.of(context).pop();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(value: ThemeMode.system, title: Text(l10n.themeSystemDefault)),
              RadioListTile<ThemeMode>(value: ThemeMode.light, title: Text(l10n.themeLight)),
              RadioListTile<ThemeMode>(value: ThemeMode.dark, title: Text(l10n.themeDark)),
            ],
          ),
        ),
      ],
    );
  }
}
