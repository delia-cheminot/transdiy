import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/l10n/locale_provider.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LocaleProvider', () {
    test('constructor uses English when no language tag is stored', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final preferences = await PreferencesService.init();

      // Act
      final provider = LocaleProvider(preferences);

      // Assert
      expect(provider.locale, const Locale('en'));
    });

    test('constructor loads locale from stored BCP-47 language tag', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({'language_tag': 'fr'});
      final preferences = await PreferencesService.init();

      // Act
      final provider = LocaleProvider(preferences);

      // Assert
      expect(provider.locale, const Locale('fr'));
    });

    test('constructor loads script and country from stored language tag',
        () async {
      // Arrange
      SharedPreferences.setMockInitialValues({'language_tag': 'pt-BR'});
      final preferences = await PreferencesService.init();

      // Act
      final provider = LocaleProvider(preferences);

      // Assert
      expect(provider.locale, const Locale('pt', 'BR'));
    });

    test('constructor leaves locale as English when stored tag is invalid',
        () async {
      // Arrange
      SharedPreferences.setMockInitialValues({'language_tag': ''});
      final preferences = await PreferencesService.init();

      // Act
      final provider = LocaleProvider(preferences);

      // Assert
      expect(provider.locale, const Locale('en'));
    });

    test('setLocale updates current locale when it changes', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final preferences = await PreferencesService.init();
      final provider = LocaleProvider(preferences);

      // Act
      provider.setLocale(const Locale('de'));

      // Assert
      expect(provider.locale, const Locale('de'));
    });

    test('setLocale notifies listeners when locale changes', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final preferences = await PreferencesService.init();
      final provider = LocaleProvider(preferences);
      var listenerCalls = 0;
      provider.addListener(() {
        listenerCalls++;
      });

      // Act
      provider.setLocale(const Locale('es'));

      // Assert
      expect(listenerCalls, 1);
    });

    test('setLocale does not notify listeners when locale is unchanged',
        () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final preferences = await PreferencesService.init();
      final provider = LocaleProvider(preferences);
      var listenerCalls = 0;
      provider.addListener(() {
        listenerCalls++;
      });

      // Act
      provider.setLocale(const Locale('en'));

      // Assert
      expect(listenerCalls, 0);
    });

    test('setLocale persists language tag to preferences', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final preferences = await PreferencesService.init();
      final provider = LocaleProvider(preferences);

      // Act
      provider.setLocale(const Locale('fr'));
      await Future<void>.delayed(Duration.zero);

      // Assert
      expect(preferences.languageTag, 'fr');
    });
  });
}
