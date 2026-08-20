import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/locale_provider.dart';
import '../../l10n/app_localizations.dart';

/// Language names are shown in their own language regardless of the
/// current UI language — standard convention for language pickers, since
/// a user looking for their language reads it in that language, not a
/// translation of it.
const _languageNames = {
  'ro': 'Română',
  'en': 'English',
  'fr': 'Français',
  'de': 'Deutsch',
  'it': 'Italiano',
  'es': 'Español',
  'pt': 'Português',
  'nl': 'Nederlands',
  'pl': 'Polski',
  'sv': 'Svenska',
  'nb': 'Norsk',
  'da': 'Dansk',
  'hu': 'Magyar',
};

class LanguagePickerDialog extends ConsumerWidget {
  const LanguagePickerDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(context: context, builder: (_) => const LanguagePickerDialog());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);

    return SimpleDialog(
      title: Text(l10n.languageDialogTitle),
      children: [
        RadioGroup<Locale?>(
          groupValue: currentLocale,
          onChanged: (value) {
            ref.read(localeProvider.notifier).setLocale(value);
            Navigator.of(context).pop();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<Locale?>(
                value: null,
                title: Text(l10n.languageSystemDefault),
              ),
              for (final locale in AppLocalizations.supportedLocales)
                RadioListTile<Locale?>(
                  value: locale,
                  title: Text(_languageNames[locale.languageCode] ?? locale.languageCode),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
