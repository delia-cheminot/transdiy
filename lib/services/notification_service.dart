import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
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

  AndroidFlutterLocalNotificationsPlugin? get _androidImplementation =>
      _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  IOSFlutterLocalNotificationsPlugin? get _iosImplementation =>
      _notificationsPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    final TimezoneInfo currentTimeZone =
        await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _notificationsPlugin.initialize(
        settings: InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    ));

    _initialized = true;
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'medication_intakes', 'Medication Intakes',
          channelDescription: 'Notifications for medication intakes',
          importance: Importance.max,
          priority: Priority.max),
      iOS: DarwinNotificationDetails(
        interruptionLevel: InterruptionLevel.timeSensitive,
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      await _androidImplementation?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      await _iosImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<bool> hasPermission() async {
    if (Platform.isAndroid) {
      final granted = await _androidImplementation?.areNotificationsEnabled();
      return granted ?? false;
    }

    if (Platform.isIOS) {
      final granted = await _iosImplementation?.checkPermissions();
      return granted?.isEnabled ?? false;
    }

    return true;
  }

  Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return true;
    final canSchedule =
        await _androidImplementation?.canScheduleExactNotifications();
    return canSchedule ?? false;
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
      id: id,
      title: title,
      body: body,
      notificationDetails: _notificationDetails(),
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

    final scheduledDate =
        tz.TZDateTime(tz.local, year, month, day, hour, minute);

    final payload = jsonEncode({
      'scheduledTime':
          DateTime(year, month, day, hour, minute).toIso8601String(),
    });

    try {
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } on PlatformException catch (e) {
      if (e.code == 'exact_alarms_not_permitted') {
        await _notificationsPlugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
          notificationDetails: _notificationDetails(),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: payload,
        );
      } else {
        rethrow;
      }
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> cancelPendingNotifications() async {
    final pendingNotifications =
        await _notificationsPlugin.pendingNotificationRequests();

    for (final notification in pendingNotifications) {
      await _notificationsPlugin.cancel(id: notification.id);
    }
  }

  Future<List<PendingNotificationRequest>> get _pastPendingNotifications async {
    final pendingNotifications =
        await _notificationsPlugin.pendingNotificationRequests();

    return pendingNotifications.where((notification) {
      final payload = jsonDecode(notification.payload ?? '{}');
      final scheduledTime = DateTime.tryParse(payload['scheduledTime'] ?? '');
      if (scheduledTime == null) return false;
      return scheduledTime.isBefore(DateTime.now());
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
