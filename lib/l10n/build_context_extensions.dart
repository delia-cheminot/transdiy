import 'package:flutter/widgets.dart';
import 'package:mona/l10n/app_localizations.dart';

extension BuildContextL10n on BuildContext {
  /// Current [Locale] for this context (same as [MaterialApp.locale] when set).
  Locale get locale => Localizations.localeOf(this);

  /// Current [Locale] as a string (same as [MaterialApp.locale] when set).
  String get languageTag => locale.toLanguageTag();

  /// Localized strings for the active locale.
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
