import 'package:flutter/material.dart';
import 'package:mona/data/providers/locale_provider.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.selectLanguage)),
      body: ListView(
        children: [
          ListTile(
            title: Text(localizations.english),
            onTap: () {
              localeProvider.setLocale(const Locale('en'));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text(localizations.french),
            onTap: () {
              localeProvider.setLocale(const Locale('fr'));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
