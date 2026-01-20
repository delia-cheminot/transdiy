import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await notificationsPlugin.initialize(InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    ));
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'medication_intakes', 'Medication Intakes',
          channelDescription: 'Notifications for medication intakes',
          importance: Importance.max,
          priority: Priority.max),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      print('Notification id $id: $title - $body');
      return;
    }

    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }
}
