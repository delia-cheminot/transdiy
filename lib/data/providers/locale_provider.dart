import 'package:flutter/material.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/services/preferences_service.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // Default to English
  final PreferencesService _prefs;

  LocaleProvider(this._prefs) {
    _loadLocale();
  }

  Locale get locale => _locale;

  void _loadLocale() {
    final savedLang = _prefs.languageCode;
    if (savedLang.contains('_')) {
      final parts = savedLang.split('_');
      _locale = Locale(parts[0], parts[1]);
    } else {
      _locale = Locale(savedLang);
    }
  }

  void setLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      final code = newLocale.countryCode != null
          ? '${newLocale.languageCode}_${newLocale.countryCode}'
          : newLocale.languageCode;
      _prefs.setLanguageCode(code);
      notifyListeners();
    }
  }

  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;
}
