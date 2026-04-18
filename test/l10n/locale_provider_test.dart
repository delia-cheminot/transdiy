import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/l10n/locale_provider.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleProvider', () {
    tearDown(() {
      TestWidgetsFlutterBinding.instance.platformDispatcher
          .clearLocaleTestValue();
    });

    test('constructor follows device locale when no language tag is stored',
        () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await PreferencesService.init();
      TestWidgetsFlutterBinding.instance.platformDispatcher.localeTestValue =
          const Locale('de', 'DE');

      final provider = LocaleProvider(preferences);

      expect(provider.locale, const Locale('de'));
    });

    test('constructor loads locale from stored BCP-47 language tag', () async {
      SharedPreferences.setMockInitialValues({'language_tag': 'fr'});
      final preferences = await PreferencesService.init();
      TestWidgetsFlutterBinding.instance.platformDispatcher.localeTestValue =
          const Locale('en', 'US');

      final provider = LocaleProvider(preferences);

      expect(provider.locale, const Locale('fr'));
    });

    test('constructor loads script and country from stored language tag',
        () async {
      SharedPreferences.setMockInitialValues({'language_tag': 'pt-BR'});
      final preferences = await PreferencesService.init();

      final provider = LocaleProvider(preferences);

      expect(provider.locale, const Locale('pt', 'BR'));
    });

    test(
        'constructor uses English fallback when stored language is unsupported',
        () async {
      SharedPreferences.setMockInitialValues({'language_tag': 'ja'});
      final preferences = await PreferencesService.init();

      final provider = LocaleProvider(preferences);

      expect(provider.locale, const Locale('en'));
    });

    test('setLocale updates current locale when it changes', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await PreferencesService.init();
      TestWidgetsFlutterBinding.instance.platformDispatcher.localeTestValue =
          const Locale('en', 'US');
      final provider = LocaleProvider(preferences);

      provider.setLocale(const Locale('de'));

      expect(provider.locale, const Locale('de'));
    });

    test('setLocale notifies listeners when locale changes', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await PreferencesService.init();
      TestWidgetsFlutterBinding.instance.platformDispatcher.localeTestValue =
          const Locale('en', 'US');
      final provider = LocaleProvider(preferences);
      var listenerCalls = 0;
      provider.addListener(() {
        listenerCalls++;
      });

      provider.setLocale(const Locale('es'));

      expect(listenerCalls, 1);
    });

    test('setLocale does not notify listeners when locale is unchanged',
        () async {
      SharedPreferences.setMockInitialValues({'language_tag': 'es'});
      final preferences = await PreferencesService.init();
      final provider = LocaleProvider(preferences);
      var listenerCalls = 0;
      provider.addListener(() {
        listenerCalls++;
      });

      provider.setLocale(const Locale('es'));

      expect(listenerCalls, 0);
    });

    test('setLocale persists language tag to preferences', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await PreferencesService.init();
      TestWidgetsFlutterBinding.instance.platformDispatcher.localeTestValue =
          const Locale('en', 'US');
      final provider = LocaleProvider(preferences);

      provider.setLocale(const Locale('fr'));
      await Future<void>.delayed(Duration.zero);

      expect(preferences.savedLanguageTag, 'fr');
    });

    test('setFollowSystemLocale clears stored tag', () async {
      SharedPreferences.setMockInitialValues({'language_tag': 'fr'});
      final preferences = await PreferencesService.init();
      TestWidgetsFlutterBinding.instance.platformDispatcher.localeTestValue =
          const Locale('de', 'DE');
      final provider = LocaleProvider(preferences);

      await provider.setFollowSystemLocale();
      await Future<void>.delayed(Duration.zero);

      expect(preferences.savedLanguageTag, isNull);
      expect(provider.locale, const Locale('de'));
    });
  });
}
