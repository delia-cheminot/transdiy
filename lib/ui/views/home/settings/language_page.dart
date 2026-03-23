import 'package:flutter/material.dart';
import 'package:mona/data/providers/locale_provider.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:provider/provider.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  static const _languages = [
    ('en', 'English', 'English'),
    ('fr', 'French', 'Français'),
    ('es', 'Spanish', 'Español'),
    ('de', 'German', 'Deutsch'),
    ('pt', 'Portuguese', 'Português'),
    ('pt_BR', 'Brazilian Portuguese', 'Português do Brasil')
  ];

  @override
  Widget build(BuildContext context) {
    final preferencesService = context.watch<PreferencesService>();
    final localeProvider = context.watch<LocaleProvider>();
    final localizations = AppLocalizations.of(context)!;
    final currentCode = preferencesService.languageCode;

    void onLanguageChanged(String? value) {
      if (value != null) {
        if (value.contains('_')) {
          final parts = value.split('_');
          localeProvider.setLocale(Locale(parts[0], parts[1]));
        } else {
          localeProvider.setLocale(Locale(value));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(localizations.language)),
      body: RadioGroup<String>(
        groupValue: currentCode,
        onChanged: onLanguageChanged,
        child: ListView(
          children: [
            for (final (code, englishName, nativeName) in _languages)
              RadioListTile<String>(
                title: Text(nativeName),
                subtitle: code != 'en' ? Text(englishName) : null,
                value: code,
              ),
          ],
        ),
      ),
    );
  }
}
