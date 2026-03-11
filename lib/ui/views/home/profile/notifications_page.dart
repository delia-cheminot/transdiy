import 'package:flutter/material.dart';
import 'package:mona/services/notification_service.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late bool _notificationsEnabled;
  late TimeOfDay _notificationTime;
  late PreferencesService _preferencesService;
  bool _permissionGranted = true;

  @override
  void initState() {
    super.initState();
    _preferencesService =
        Provider.of<PreferencesService>(context, listen: false);
    _notificationsEnabled = _preferencesService.notificationsEnabled;
    _notificationTime = _preferencesService.notificationTime;
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final granted = await NotificationService().hasPermission();
    setState(() {
      _permissionGranted = granted;
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
    );

    if (picked != null) {
      setState(() {
        _notificationTime = picked;
      });

      await _preferencesService.setNotificationTime(picked);
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value == true) {
      await NotificationService().requestAndroidNotificationPermission();
    }

    await _preferencesService.setNotificationsEnabled(value);
    await _checkPermission();

    setState(() {
      _notificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: [
          if (_notificationsEnabled && !_permissionGranted)
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Notifications are disabled'),
              subtitle: Text("You need to allow them in system settings."),
            ),
          SwitchListTile(
            title: const Text('Enable notifications'),
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
          ),
          ListTile(
            title: const Text('Notification time'),
            subtitle: Text(_notificationTime.format(context)),
            trailing: const Icon(Icons.access_time),
            onTap: _pickTime,
          ),
        ],
      ),
    );
  }
}
