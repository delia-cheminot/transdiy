import 'package:flutter/material.dart';
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
    _locale = Locale(savedLang);
  }

  void setLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      _prefs.setLanguageCode(newLocale.languageCode);
      notifyListeners();
    }
  }

  List<Locale> get supportedLocales =>
      [const Locale('en'), const Locale('fr')]; // Add more as needed
}
