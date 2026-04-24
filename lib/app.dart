import 'package:dynamic_system_colors/dynamic_system_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mona/controllers/notification_scheduler.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/l10n/locale_provider.dart';
import 'package:mona/services/notification_service.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:mona/theme/app_theme_controller.dart';
import 'package:provider/provider.dart';
import 'ui/views/main_page.dart';

class MonaApp extends StatefulWidget {
  const MonaApp({super.key});

  @override
  State<MonaApp> createState() => _MonaAppState();
}

class _MonaAppState extends State<MonaApp> with WidgetsBindingObserver {
  String? _lastTimeZone;
  late MedicationScheduleProvider _medicationScheduleProvider;
  late MedicationIntakeProvider _medicationIntakeProvider;
  late PreferencesService _preferencesService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lastTimeZone = DateTime.now().timeZoneOffset.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await NotificationService().initialize();
      if (!mounted) return;
      _medicationScheduleProvider = context.read<MedicationScheduleProvider>();
      _medicationIntakeProvider = context.read<MedicationIntakeProvider>();
      _preferencesService = context.read<PreferencesService>();
      _medicationScheduleProvider.addListener(_regenerateNotifications);
      _medicationIntakeProvider.addListener(_regenerateNotifications);
      _preferencesService.addListener(_regenerateNotifications);
      _regenerateNotifications();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _medicationScheduleProvider.removeListener(_regenerateNotifications);
    _medicationIntakeProvider.removeListener(_regenerateNotifications);
    _preferencesService.removeListener(_regenerateNotifications);
    super.dispose();
  }

  void _regenerateNotifications() async {
    if (!mounted) return;

    final locale = context.read<LocaleProvider>().locale;

    final l10n = await AppLocalizations.delegate.load(locale);

    if (!mounted) return;

    NotificationScheduler(
      _medicationScheduleProvider,
      _medicationIntakeProvider,
      _preferencesService,
    ).regenerateAll(l10n, locale.toLanguageTag());
  }

  void _checkTimezoneChange() {
    final currentTimezone = DateTime.now().timeZoneOffset.toString();
    if (_lastTimeZone != currentTimezone) {
      _lastTimeZone = currentTimezone;
      _regenerateNotifications();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkTimezoneChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppThemeProvider>();
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final themes = context.read<AppThemeProvider>().buildThemeData(
              systemLight: lightDynamic,
              systemDark: darkDynamic,
            );

        return MaterialApp(
          title: 'Mona',
          locale: context.watch<LocaleProvider>().locale,
          supportedLocales: context.watch<LocaleProvider>().supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: themes.theme,
          darkTheme: themes.darkTheme,
          themeMode: ThemeMode.system,
          home: MainPage(),
        );
      },
    );
  }
}
