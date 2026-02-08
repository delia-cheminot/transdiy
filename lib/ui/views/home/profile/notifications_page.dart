import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _preferencesService =
        Provider.of<PreferencesService>(context, listen: false);
    _notificationsEnabled = _preferencesService.notificationsEnabled;
    _notificationTime = _preferencesService.notificationTime;
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
    setState(() {
      _notificationsEnabled = value;
    });

    await _preferencesService.setNotificationsEnabled(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: [
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
