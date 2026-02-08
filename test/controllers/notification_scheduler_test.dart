import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mona/controllers/notification_scheduler.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/services/notifications/notification_service.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@GenerateNiceMocks([
  MockSpec<MedicationScheduleProvider>(),
  MockSpec<PreferencesService>(),
  MockSpec<FlutterLocalNotificationsPlugin>(),
])
import 'notification_scheduler_test.mocks.dart';

void main() {
  late MockMedicationScheduleProvider mockMedicationScheduleProvider;
  late MockPreferencesService mockPreferencesService;
  late MockFlutterLocalNotificationsPlugin mockPlugin;

  setUpAll(() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('UTC'));
  });

  setUp(() {
    mockMedicationScheduleProvider = MockMedicationScheduleProvider();
    mockPreferencesService = MockPreferencesService();
    mockPlugin = MockFlutterLocalNotificationsPlugin();
  });

  group('pending notifications', () {
    test('regenerateAll triggers past pending notifications', () async {
      // Arrange
      final origPlatformCheck = NotificationService.isPlatformSupported;
      NotificationService.isPlatformSupported = () => true;

      final pending = PendingNotificationRequest(
        1,
        'title',
        'body',
        '{"scheduledAt":"${DateTime.now().subtract(Duration(days: 1)).toIso8601String()}"}',
      );

      when(mockPlugin.pendingNotificationRequests())
          .thenAnswer((_) async => [pending]);
      when(mockPlugin.show(any, any, any, any)).thenAnswer((_) async {});

      final origCreate = NotificationService.createPlugin;
      NotificationService.createPlugin = () => mockPlugin;

      final scheduler = NotificationScheduler(
        mockMedicationScheduleProvider,
        mockPreferencesService,
      );

      // Act
      await scheduler.regenerateAll();

      // Assert
      verify(mockPlugin.show(any, 'title', 'body', any)).called(1);

      // Cleanup
      NotificationService.createPlugin = origCreate;
      NotificationService.isPlatformSupported = origPlatformCheck;
    });

    test('regenerateAll cancels pending notifications', () async {
      // Arrange
      final origPlatformCheck = NotificationService.isPlatformSupported;
      NotificationService.isPlatformSupported = () => true;

      final pending = PendingNotificationRequest(
        1,
        'title',
        'body',
        '{"scheduledAt":"${DateTime.now().add(Duration(days: 1)).toIso8601String()}"}',
      );

      when(mockPlugin.pendingNotificationRequests())
          .thenAnswer((_) async => [pending]);
      when(mockPlugin.cancel(any)).thenAnswer((_) async {});

      final origCreate = NotificationService.createPlugin;
      NotificationService.createPlugin = () => mockPlugin;

      final scheduler = NotificationScheduler(
        mockMedicationScheduleProvider,
        mockPreferencesService,
      );

      // Act
      await scheduler.regenerateAll();

      // Assert
      verify(mockPlugin.cancel(pending.id)).called(1);

      // Cleanup
      NotificationService.createPlugin = origCreate;
      NotificationService.isPlatformSupported = origPlatformCheck;
    });
  });

  group('regenerateAll scheduling logic', () {
    test(
        'regenerateAll should schedule 5 notification when next is today and current time is before notification time',
        () async {
      // Arrange
      final origPlatformCheck = NotificationService.isPlatformSupported;
      NotificationService.isPlatformSupported = () => true;

      final futureHour = (DateTime.now().hour + 1) % 24;
      when(mockMedicationScheduleProvider.schedules).thenReturn([
        MedicationSchedule(
            name: 'Test Medication', dose: Decimal.fromInt(10), intervalDays: 1)
      ]);
      when(mockPreferencesService.notificationTime)
          .thenReturn(TimeOfDay(hour: futureHour, minute: 0));
      when(mockPlugin.zonedSchedule(any, any, any, any, any,
              androidScheduleMode: anyNamed('androidScheduleMode'),
              payload: anyNamed('payload')))
          .thenAnswer((_) async {});

      final origCreate = NotificationService.createPlugin;
      NotificationService.createPlugin = () => mockPlugin;

      final scheduler = NotificationScheduler(
        mockMedicationScheduleProvider,
        mockPreferencesService,
      );

      // Act
      await scheduler.regenerateAll();

      // Assert
      verify(mockPlugin.zonedSchedule(any, any, any, any, any,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              payload: anyNamed('payload')))
          .called(5);

      // Cleanup
      NotificationService.createPlugin = origCreate;
      NotificationService.isPlatformSupported = origPlatformCheck;
    });

    test(
        'regenerateAll should schedule 4 notifications when next date is today and current time is after notification time',
        () async {
      // Arrange
      final origPlatformCheck = NotificationService.isPlatformSupported;
      NotificationService.isPlatformSupported = () => true;

      final pastHour = (DateTime.now().hour - 1) % 24;
      when(mockMedicationScheduleProvider.schedules).thenReturn([
        MedicationSchedule(
            name: 'Test Medication', dose: Decimal.fromInt(10), intervalDays: 1)
      ]);
      when(mockPreferencesService.notificationTime)
          .thenReturn(TimeOfDay(hour: pastHour, minute: 0));
      when(mockPlugin.zonedSchedule(any, any, any, any, any,
              androidScheduleMode: anyNamed('androidScheduleMode'),
              payload: anyNamed('payload')))
          .thenAnswer((_) async {});

      final origCreate = NotificationService.createPlugin;
      NotificationService.createPlugin = () => mockPlugin;

      final scheduler = NotificationScheduler(
        mockMedicationScheduleProvider,
        mockPreferencesService,
      );

      // Act
      await scheduler.regenerateAll();

      // Assert
      verify(mockPlugin.zonedSchedule(any, any, any, any, any,
              androidScheduleMode: anyNamed('androidScheduleMode'),
              payload: anyNamed('payload')))
          .called(4);
      // Cleanup
      NotificationService.createPlugin = origCreate;
      NotificationService.isPlatformSupported = origPlatformCheck;
    });

    test(
        'regenerateAll should schedule 5 notifications when next date is not today',
        () async {
      // Arrange
      final origPlatformCheck = NotificationService.isPlatformSupported;
      NotificationService.isPlatformSupported = () => true;

      when(mockMedicationScheduleProvider.schedules).thenReturn([
        MedicationSchedule(
            name: 'Test Medication',
            dose: Decimal.fromInt(10),
            intervalDays: 1,
            startDate: DateTime.now().add(const Duration(days: 1)))
      ]);
      when(mockPreferencesService.notificationTime)
          .thenReturn(const TimeOfDay(hour: 12, minute: 0));
      when(mockPlugin.zonedSchedule(any, any, any, any, any,
              androidScheduleMode: anyNamed('androidScheduleMode'),
              payload: anyNamed('payload')))
          .thenAnswer((_) async {});

      final origCreate = NotificationService.createPlugin;
      NotificationService.createPlugin = () => mockPlugin;

      final scheduler = NotificationScheduler(
        mockMedicationScheduleProvider,
        mockPreferencesService,
      );

      // Act
      await scheduler.regenerateAll();

      // Assert
      verify(mockPlugin.zonedSchedule(any, any, any, any, any,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              payload: anyNamed('payload')))
          .called(5);

      // Cleanup
      NotificationService.createPlugin = origCreate;
      NotificationService.isPlatformSupported = origPlatformCheck;
    });
  });
}
