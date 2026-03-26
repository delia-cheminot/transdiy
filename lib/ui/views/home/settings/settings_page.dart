import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mona/data/providers/locale_provider.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/services/notification_service.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:mona/services/update_service.dart';
import 'package:mona/ui/views/home/settings/language_page.dart';
import 'package:mona/ui/views/home/settings/schedules/schedules_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with WidgetsBindingObserver {
  late bool _notificationsEnabled;
  late bool _autoCheckUpdatesEnabled;
  bool _permissionGranted = true;
  bool _exactAlarmsGranted = true;
  late PreferencesService _preferencesService;

  static final Map<String, String Function(AppLocalizations)>
      _localizedLanguageNames = {
    for (final (code, _, __, getter) in LanguagePage.languages) code: getter,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _preferencesService =
        Provider.of<PreferencesService>(context, listen: false);
    _notificationsEnabled = _preferencesService.notificationsEnabled;
    _autoCheckUpdatesEnabled = _preferencesService.autoCheckUpdatesEnabled;
    _checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    final granted = await NotificationService().hasPermission();
    final exactAlarmsGranted =
        await NotificationService().canScheduleExactAlarms();
    setState(() {
      _permissionGranted = granted;
      _exactAlarmsGranted = exactAlarmsGranted;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value == true) {
      await NotificationService().requestNotificationPermission();
    }

    await _preferencesService.setNotificationsEnabled(value);
    await _checkPermission();

    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _toggleAutoCheckUpdates(bool value) async {
    await _preferencesService.setAutoCheckUpdatesEnabled(value);

    setState(() {
      _autoCheckUpdatesEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final medicationScheduleProvider =
        context.watch<MedicationScheduleProvider>();
    final preferencesService = context.watch<PreferencesService>();
    final localeProvider = context.watch<LocaleProvider>();
    final localizations = AppLocalizations.of(context)!;

    if (medicationScheduleProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(localizations.settingsTitle)),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settingsTitle)),
      body: ListView(
        children: [
          // Tile for medication schedules
          ListTile(
            title: Text(localizations.schedules),
            subtitle: Text(medicationScheduleProvider.schedules.isEmpty
                ? localizations.noSchedules
                : localizations.schedulesCreated(
                    medicationScheduleProvider.schedules.length)),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (context) => SchedulesPage(),
              ));
            },
          ),
          ListTile(
            title: Text(localizations.language),
            subtitle: Text(
                _localizedLanguageNames[preferencesService.languageCode]!(
                    localizations)),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => LanguagePage()),
              );
            },
          ),
          SwitchListTile(
            title: Text(localizations.enableNotifications),
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
          ),
          if (_notificationsEnabled && !_permissionGranted)
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(localizations.notificationsDisabledTitle),
              subtitle: Text(localizations.clickToOpenSettings),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await openAppSettings();
              },
            ),
          if (_notificationsEnabled &&
              _permissionGranted &&
              !_exactAlarmsGranted)
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(localizations.exactRemindersDisabled),
              subtitle: Text(localizations.remindersDelayed),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await openAppSettings();
              },
            ),
          if (Platform.isAndroid) ...[
            const Divider(),
            SwitchListTile(
              title: Text(localizations.autoUpdate),
              subtitle: Text(localizations.autoUpdateDescription),
              value: _autoCheckUpdatesEnabled,
              onChanged: _toggleAutoCheckUpdates,
            ),
            ListTile(
              title: Text(localizations.checkForUpdates),
              subtitle: Text(localizations.checkForUpdatesDescription),
              trailing: const Icon(Icons.system_update),
              onTap: () => UpdateService().checkForUpdates(context),
            ),
          ],
          const SizedBox(height: 32),

          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              final info = snapshot.data!;
              return Center(
                child: Text(
                  localizations.appVersion(info.version),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
