import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/l10n/build_context_extensions.dart';
import 'package:mona/services/backup_service.dart';
import 'package:mona/services/notification_service.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:mona/services/update_service.dart';
import 'package:mona/ui/constants/dimensions.dart';
import 'package:mona/ui/views/home/settings/language_page.dart';
import 'package:mona/ui/views/home/settings/schedules/schedules_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

String? _nativeLanguageNameForStoredTag(String tag) {
  for (final (code, _, nativeName) in LanguagePage.languages) {
    if (code == tag) return nativeName;
  }
  return null;
}

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

  Future<void> _exportData() async {
    final localizations = context.l10n;
    try {
      final savedPath = await BackupService().exportData();

      if (savedPath != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.backupSavedTo(savedPath)),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.exportFailed(e))),
        );
      }
    }
  }

  Future<void> _importData() async {
    final l10n = context.l10n;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.importDataTitle),
        content: Text(l10n.importDataOverwriteWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error),
            child: Text(l10n.importConfirm),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final success = await BackupService().importData();
        if (success && mounted) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text(l10n.importSuccessfulTitle),
              content: Text(l10n.importRestartRequired),
              actions: [
                TextButton(
                  onPressed: () => exit(0),
                  child: Text(l10n.closeApp),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.importFailed(e))),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicationScheduleProvider =
        context.watch<MedicationScheduleProvider>();
    final preferencesService = context.watch<PreferencesService>();
    final localizations = context.l10n;

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
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: borderPadding, vertical: 8.0),
            child: Text(
              localizations.notifications,
            ),
          ),
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
              _nativeLanguageNameForStoredTag(preferencesService.languageTag) ??
                  preferencesService.languageTag,
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => LanguagePage()),
              );
            },
          ),
          SwitchListTile(
            title: Text(localizations.enableNotifications),
            subtitle: Text(localizations.enableNotificationsDescription),
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
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: borderPadding, vertical: 8.0),
              child: Text(
                localizations.updates,
              ),
            ),
            SwitchListTile(
              title: Text(localizations.autoUpdate),
              subtitle: Text(localizations.autoUpdateDescription),
              value: _autoCheckUpdatesEnabled,
              onChanged: _toggleAutoCheckUpdates,
            ),
            ListTile(
              title: Text(localizations.checkForUpdates),
              subtitle: Text(localizations.checkForUpdatesDescription),
              trailing: const Icon(Symbols.update),
              onTap: () => UpdateService().checkForUpdates(context),
            ),
          ],
          const Divider(),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: borderPadding, vertical: 8.0),
            child: Text(
              localizations.dataManagement,
            ),
          ),
          ListTile(
            title: Text(localizations.exportDataTitle),
            subtitle: Text(localizations.exportDataSubtitle),
            trailing: const Icon(Symbols.download),
            onTap: _exportData,
          ),
          ListTile(
            title: Text(localizations.importDataTitle),
            subtitle: Text(localizations.importDataSubtitle),
            trailing: const Icon(Symbols.upload),
            onTap: _importData,
          ),
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
