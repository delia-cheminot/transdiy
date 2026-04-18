import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/locale.dart' as intl;
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/services/preferences_service.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  final PreferencesService _prefs;

  LocaleProvider(this._prefs) {
    _loadLocale();
  }

  Locale get locale => _locale;

  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  void setLocale(Locale newLocale) {
    if (locale == newLocale) return;

    _locale = newLocale;
    _prefs.setLanguageTag(newLocale.toLanguageTag());
    notifyListeners();
  }

  void _loadLocale() {
    Locale? result;

    final savedTag = _prefs.languageTag;
    final parsed = intl.Locale.tryParse(savedTag);
    if (parsed != null) {
      result = Locale.fromSubtags(
        languageCode: parsed.languageCode,
        scriptCode: parsed.scriptCode,
        countryCode: parsed.countryCode,
      );
    }

    result ??= PlatformDispatcher.instance.locale;

    final match = supportedLocales.firstWhere(
      (l) => l.languageCode == result!.languageCode,
      orElse: () => const Locale('en'),
    );

    _locale = match;
  }
}
