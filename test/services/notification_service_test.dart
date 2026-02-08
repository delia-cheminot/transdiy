import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class FakeFlutterLocalNotificationsPlugin
    implements FlutterLocalNotificationsPlugin {
  final List<Map<String, dynamic>> scheduled = [];
  final List<Map<String, dynamic>> shown = [];

  @override
  Future<bool?> initialize(
    InitializationSettings initializationSettings, {
    void Function(NotificationResponse)? onDidReceiveNotificationResponse,
    void Function(NotificationResponse)?
        onDidReceiveBackgroundNotificationResponse,
  }) async {
    return true;
  }

  @override
  Future<void> show(
      int id, String? title, String? body, NotificationDetails? details,
      {String? payload}) async {
    shown.add({'id': id, 'title': title, 'body': body, 'payload': payload});
  }

  @override
  Future<void> zonedSchedule(int id, String? title, String? body,
      tz.TZDateTime scheduledDate, NotificationDetails details,
      {required AndroidScheduleMode androidScheduleMode,
      DateTimeComponents? matchDateTimeComponents,
      String? payload}) async {
    scheduled.add({
      'id': id,
      'title': title,
      'body': body,
      'date': scheduledDate,
      'payload': payload,
    });
  }

  @override
  Future<List<PendingNotificationRequest>> pendingNotificationRequests() async {
    return scheduled
        .map((n) => PendingNotificationRequest(
            n['id'] as int,
            n['title'] as String?,
            n['body'] as String?,
            n['payload'] as String?))
        .toList();
  }

  @override
  Future<void> cancel(int id, {String? tag}) async {
    scheduled.removeWhere((n) => n['id'] == id);
  }

  @override
  Future<void> cancelAll() async {
    scheduled.clear();
  }

  @override
  Future<void> cancelAllPendingNotifications() async {
    scheduled.clear();
  }

  @override
  Future<List<ActiveNotification>> getActiveNotifications() async {
    return [];
  }

  @override
  Future<NotificationAppLaunchDetails?>
      getNotificationAppLaunchDetails() async {
    return null;
  }

  @override
  Future<void> periodicallyShow(
    int id,
    String? title,
    String? body,
    RepeatInterval repeatInterval,
    NotificationDetails details, {
    required AndroidScheduleMode androidScheduleMode,
    String? payload,
  }) async {}

  @override
  Future<void> periodicallyShowWithDuration(
    int id,
    String? title,
    String? body,
    Duration duration,
    NotificationDetails details, {
    AndroidScheduleMode? androidScheduleMode,
    String? payload,
  }) async {}

  @override
  T? resolvePlatformSpecificImplementation<
      T extends FlutterLocalNotificationsPlatform>() {
    return null;
  }
}

void main() {
  late NotificationService service;
  late FakeFlutterLocalNotificationsPlugin fakePlugin;

  setUp(() {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('UTC'));

    NotificationService.isPlatformSupported = () => true;
    fakePlugin = FakeFlutterLocalNotificationsPlugin();
    service = NotificationService(plugin: fakePlugin);
  });

  tearDownAll(() {
    NotificationService.isPlatformSupported = null;
  });

  test('scheduleNotification adds a notification', () async {
    await service.scheduleNotification(
        title: 'Test',
        body: 'Body',
        year: 2026,
        month: 2,
        day: 8,
        hour: 10,
        minute: 30);

    expect(fakePlugin.scheduled.length, 1);
    final n = fakePlugin.scheduled.first;
    expect(n['title'], 'Test');
    expect(n['body'], 'Body');
    expect((n['date'] as tz.TZDateTime).hour, 10);
    expect((n['date'] as tz.TZDateTime).minute, 30);
  });

  test('showNotification adds a shown notification', () async {
    await service.showNotification(title: 'Show', body: 'Body');
    expect(fakePlugin.shown.length, 1);
    final n = fakePlugin.shown.first;
    expect(n['title'], 'Show');
    expect(n['body'], 'Body');
  });

  test('cancelAllNotifications clears scheduled', () async {
    await service.scheduleNotification(
        title: 'T1',
        body: 'B1',
        year: 2026,
        month: 2,
        day: 8,
        hour: 10,
        minute: 0);
    await service.cancelAllNotifications();
    expect(fakePlugin.scheduled.length, 0);
  });

  test('cancelPendingNotifications removes only pending', () async {
    await service.scheduleNotification(
        title: 'T1',
        body: 'B1',
        year: 2026,
        month: 2,
        day: 8,
        hour: 10,
        minute: 0);
    await service.scheduleNotification(
        title: 'T2',
        body: 'B2',
        year: 2026,
        month: 2,
        day: 9,
        hour: 10,
        minute: 0);

    await service.cancelPendingNotifications();
    expect(fakePlugin.scheduled.length, 0);
  });

  test('triggerPastPendingNotifications shows past notifications', () async {
    final payload = jsonEncode({
      'scheduledAt':
          DateTime.now().subtract(Duration(days: 1)).toIso8601String()
    });
    fakePlugin.scheduled.add({
      'id': 1,
      'title': 'Past',
      'body': 'B',
      'date': DateTime.now(),
      'payload': payload
    });

    await service.triggerPastPendingNotifications();
    expect(fakePlugin.shown.length, 1);
    expect(fakePlugin.shown.first['title'], 'Past');
  });
}
