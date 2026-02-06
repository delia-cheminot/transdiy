import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    final TimezoneInfo currentTimeZone =
        await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _notificationsPlugin.initialize(InitializationSettings(
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
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
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

    return _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }

  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required int year,
    required int month,
    required int day,
    required int hour,
    required int minute,
  }) async {
    var scheduledDate = tz.TZDateTime(tz.local, year, month, day, hour, minute);

    await _notificationsPlugin.zonedSchedule(
        id, title, body, scheduledDate, notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> cancelPendingNotifications() async {
    final pendingNotifications =
        await _notificationsPlugin.pendingNotificationRequests();

    for (final notification in pendingNotifications) {
      await _notificationsPlugin.cancel(notification.id);
    }
  }
}
