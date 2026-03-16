import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/services/notification_service.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:mona/services/update_service.dart';
import 'package:mona/ui/views/home/settings/schedules/schedules_page.dart';
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
  bool _permissionGranted = true;
  late PreferencesService _preferencesService;
  late MedicationScheduleProvider _medicationScheduleProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _preferencesService =
        Provider.of<PreferencesService>(context, listen: false);
    _medicationScheduleProvider = context.watch<MedicationScheduleProvider>();
    _notificationsEnabled = _preferencesService.notificationsEnabled;
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
    setState(() {
      _permissionGranted = granted;
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

  @override
  Widget build(BuildContext context) {
    if (_medicationScheduleProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          // Tile for medication schedules
          ListTile(
            title: Text('Schedules'),
            subtitle: Text(_medicationScheduleProvider.schedules.isEmpty
                ? 'No schedules'
                : '${_medicationScheduleProvider.schedules.length} created'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (context) => SchedulesPage(),
              ));
            },
          ),
          SwitchListTile(
            title: const Text('Enable notifications'),
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
          ),
          if (_notificationsEnabled && !_permissionGranted)
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Notifications are disabled'),
              subtitle: const Text("Click to open settings"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await openAppSettings();
              },
            ),
          if (Platform.isAndroid) ...[
            const Divider(),
            SwitchListTile(
              title: const Text('Auto-Update'),
              subtitle: const Text(
                  'Automatically check new updates when app is launched'),
              value: _preferencesService.autoCheckUpdatesEnabled,
              onChanged: (bool value) {
                _preferencesService.setAutoCheckUpdatesEnabled(value);
              },
            ),
            ListTile(
              title: const Text('Check for Updates'),
              subtitle: const Text(
                  'Check for the latest version manually\nThis will connect you to Internet\nNo data will be sent)'),
              trailing: const Icon(Icons.system_update),
              onTap: () => UpdateService().checkForUpdates(context),
            ),
          ],
        ],
      ),
    );
  }
}
