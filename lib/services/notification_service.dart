import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static FlutterLocalNotificationsPlugin Function()? createPlugin =
      () => FlutterLocalNotificationsPlugin();

  static bool Function()? isPlatformSupported =
      () => Platform.isAndroid || Platform.isIOS;

  late final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationService({FlutterLocalNotificationsPlugin? plugin}) {
    _notificationsPlugin =
        plugin ?? (createPlugin?.call() ?? FlutterLocalNotificationsPlugin());
  }

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

  NotificationDetails _notificationDetails() {
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
    int? id,
    String? title,
    String? body,
  }) async {
    id ??= Random().nextInt(1 << 31);

    final supported =
        isPlatformSupported?.call() ?? (Platform.isAndroid || Platform.isIOS);
    if (!supported) {
      print('Notification id $id: $title - $body');
      return;
    }

    await _notificationsPlugin.show(
      id,
      title,
      body,
      _notificationDetails(),
    );
  }

  Future<void> scheduleNotification({
    int? id,
    required String title,
    required String body,
    required int year,
    required int month,
    required int day,
    required int hour,
    required int minute,
  }) async {
    id ??= Random().nextInt(1 << 31);

    var scheduledDate = tz.TZDateTime(tz.local, year, month, day, hour, minute);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: jsonEncode({
        'scheduledTime':
            DateTime(year, month, day, hour, minute).toIso8601String(),
      }),
    );
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

  Future<List<PendingNotificationRequest>> get _pastPendingNotifications async {
    final pendingNotifications =
        await _notificationsPlugin.pendingNotificationRequests();

    return pendingNotifications.where((notification) {
      final payload = jsonDecode(notification.payload ?? '{}');
      final scheduledAt = DateTime.tryParse(payload['scheduledAt'] ?? '');
      if (scheduledAt == null) return false;
      return scheduledAt.isBefore(DateTime.now());
    }).toList();
  }

  Future<void> triggerPastPendingNotifications() async {
    final pastPendingNotifications = await _pastPendingNotifications;
    for (final notification in pastPendingNotifications) {
      await showNotification(
        title: notification.title,
        body: notification.body,
      );
    }
  }
}
