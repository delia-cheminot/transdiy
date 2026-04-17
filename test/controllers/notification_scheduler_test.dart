import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mona/controllers/notification_scheduler.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/date.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/services/notification_service.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@GenerateNiceMocks([
  MockSpec<MedicationScheduleProvider>(),
  MockSpec<MedicationIntakeProvider>(),
  MockSpec<PreferencesService>(),
  MockSpec<FlutterLocalNotificationsPlugin>(),
])
import 'notification_scheduler_test.mocks.dart';

void main() {
  late MockMedicationScheduleProvider mockMedicationScheduleProvider;
  late MockMedicationIntakeProvider mockMedicationIntakeProvider;
  late MockPreferencesService mockPreferencesService;
  late MockFlutterLocalNotificationsPlugin mockPlugin;

  setUpAll(() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Etc/UTC'));
  });

  setUp(() {
    mockMedicationScheduleProvider = MockMedicationScheduleProvider();
    mockMedicationIntakeProvider = MockMedicationIntakeProvider();
    mockPreferencesService = MockPreferencesService();
    mockPlugin = MockFlutterLocalNotificationsPlugin();
  });

  group('NotificationScheduler', () {
    group('pending notifications', () {
      test('regenerateAll triggers past pending notifications', () async {
        // Arrange
        final origPlatformCheck = NotificationService.isPlatformSupported;
        NotificationService.isPlatformSupported = () => true;

        final pending = PendingNotificationRequest(
          1,
          'title',
          'body',
          '{"scheduledTime":"${DateTime.now().subtract(Duration(days: 1)).toIso8601String()}"}',
        );

        when(mockPlugin.pendingNotificationRequests())
            .thenAnswer((_) async => [pending]);
        when(mockPlugin.show(
          id: anyNamed('id'),
          title: 'title',
          body: 'body',
          notificationDetails: anyNamed('notificationDetails'),
          payload: anyNamed('payload'),
        )).thenAnswer((_) async {});

        final origCreate = NotificationService.createPlugin;
        NotificationService.createPlugin = () => mockPlugin;

        final scheduler = NotificationScheduler(
          mockMedicationScheduleProvider,
          mockMedicationIntakeProvider,
          mockPreferencesService,
        );

        // Act
        await scheduler.regenerateAll();

        // Assert
        verify(mockPlugin.show(
          id: anyNamed('id'),
          title: 'title',
          body: 'body',
          notificationDetails: anyNamed('notificationDetails'),
          payload: anyNamed('payload'),
        )).called(1);

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
          '{"scheduledTime":"${DateTime.now().add(Duration(days: 1)).toIso8601String()}"}',
        );

        when(mockPlugin.pendingNotificationRequests())
            .thenAnswer((_) async => [pending]);
        when(mockPlugin.cancel(id: anyNamed('id'))).thenAnswer((_) async {});

        final origCreate = NotificationService.createPlugin;
        NotificationService.createPlugin = () => mockPlugin;

        final scheduler = NotificationScheduler(
          mockMedicationScheduleProvider,
          mockMedicationIntakeProvider,
          mockPreferencesService,
        );

        // Act
        await scheduler.regenerateAll();

        // Assert
        verify(mockPlugin.cancel(id: pending.id)).called(1);

        // Cleanup
        NotificationService.createPlugin = origCreate;
        NotificationService.isPlatformSupported = origPlatformCheck;
      });
    });

    group('notifications disabled', () {
      test('regenerateAll should return early when notifications are disabled',
          () async {
        // Arrange
        final origPlatformCheck = NotificationService.isPlatformSupported;
        NotificationService.isPlatformSupported = () => true;

        when(mockPreferencesService.notificationsEnabled).thenReturn(false);
        when(mockMedicationScheduleProvider.schedules).thenReturn([
          MedicationSchedule(
            name: 'Test Medication',
            dose: Decimal.fromInt(10),
            intervalDays: 1,
            molecule: KnownMolecules.estradiol,
            administrationRoute: AdministrationRoute.oral,
            notificationTimes: List.empty(),
          )
        ]);
        when(mockPlugin.zonedSchedule(
                id: anyNamed('id'),
                title: anyNamed('title'),
                body: anyNamed('body'),
                scheduledDate: anyNamed('scheduledDate'),
                notificationDetails: anyNamed('notificationDetails'),
                androidScheduleMode: anyNamed('androidScheduleMode'),
                payload: anyNamed('payload')))
            .thenAnswer((_) async {});

        final origCreate = NotificationService.createPlugin;
        NotificationService.createPlugin = () => mockPlugin;

        final scheduler = NotificationScheduler(
          mockMedicationScheduleProvider,
          mockMedicationIntakeProvider,
          mockPreferencesService,
        );

        // Act
        await scheduler.regenerateAll();

        // Assert
        verifyNever(mockPlugin.zonedSchedule(
            id: anyNamed('id'),
            title: anyNamed('title'),
            body: anyNamed('body'),
            scheduledDate: anyNamed('scheduledDate'),
            notificationDetails: anyNamed('notificationDetails'),
            androidScheduleMode: anyNamed('androidScheduleMode'),
            payload: anyNamed('payload')));

        // Cleanup
        NotificationService.createPlugin = origCreate;
        NotificationService.isPlatformSupported = origPlatformCheck;
      });
    });

    group('regenerateAll scheduling logic', () {
      test('Schedule with no notification times -> no notifications scheduled',
          () async {
        // Arrange
        final origPlatformCheck = NotificationService.isPlatformSupported;
        final origCreate = NotificationService.createPlugin;
        NotificationService.isPlatformSupported = () => true;
        NotificationService.createPlugin = () => mockPlugin;

        const scheduleId = 1001;
        when(mockPreferencesService.notificationsEnabled).thenReturn(true);
        when(mockMedicationScheduleProvider.schedules).thenReturn([
          MedicationSchedule(
            id: scheduleId,
            name: 'Empty Schedule',
            dose: Decimal.fromInt(10),
            intervalDays: 1,
            molecule: KnownMolecules.estradiol,
            administrationRoute: AdministrationRoute.oral,
            notificationTimes: [],
          )
        ]);
        when(mockMedicationIntakeProvider
                .getLastIntakeDateForSchedule(scheduleId))
            .thenReturn(null);

        final scheduler = NotificationScheduler(
          mockMedicationScheduleProvider,
          mockMedicationIntakeProvider,
          mockPreferencesService,
        );

        // Act
        await scheduler.regenerateAll();

        // Assert
        verifyNever(mockPlugin.zonedSchedule(
          id: anyNamed('id'),
          title: anyNamed('title'),
          body: anyNamed('body'),
          scheduledDate: anyNamed('scheduledDate'),
          notificationDetails: anyNamed('notificationDetails'),
          androidScheduleMode: anyNamed('androidScheduleMode'),
          payload: anyNamed('payload'),
        ));

        // Cleanup
        NotificationService.createPlugin = origCreate;
        NotificationService.isPlatformSupported = origPlatformCheck;
      });

      test(
          'Schedule with one future notification time -> 5 notifications scheduled',
          () async {
        // Arrange
        final origPlatformCheck = NotificationService.isPlatformSupported;
        final origCreate = NotificationService.createPlugin;
        NotificationService.isPlatformSupported = () => true;
        NotificationService.createPlugin = () => mockPlugin;

        const scheduleId = 1002;
        when(mockPreferencesService.notificationsEnabled).thenReturn(true);
        when(mockMedicationScheduleProvider.schedules).thenReturn([
          MedicationSchedule(
            id: scheduleId,
            name: 'Future Schedule',
            dose: Decimal.fromInt(10),
            intervalDays: 1,
            molecule: KnownMolecules.estradiol,
            administrationRoute: AdministrationRoute.oral,
            notificationTimes: [
              TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 1)))
            ],
          )
        ]);
        when(mockMedicationIntakeProvider
                .getLastIntakeDateForSchedule(scheduleId))
            .thenReturn(null);

        final scheduler = NotificationScheduler(
          mockMedicationScheduleProvider,
          mockMedicationIntakeProvider,
          mockPreferencesService,
        );

        // Act
        await scheduler.regenerateAll();

        // Assert
        verify(mockPlugin.zonedSchedule(
          id: anyNamed('id'),
          title: anyNamed('title'),
          body: anyNamed('body'),
          scheduledDate: anyNamed('scheduledDate'),
          notificationDetails: anyNamed('notificationDetails'),
          androidScheduleMode: anyNamed('androidScheduleMode'),
          payload: anyNamed('payload'),
        )).called(5);

        // Cleanup
        NotificationService.createPlugin = origCreate;
        NotificationService.isPlatformSupported = origPlatformCheck;
      });

      test(
          'Schedule with one past notification time -> 4 notifications scheduled',
          () async {
        // Arrange
        final origPlatformCheck = NotificationService.isPlatformSupported;
        final origCreate = NotificationService.createPlugin;
        NotificationService.isPlatformSupported = () => true;
        NotificationService.createPlugin = () => mockPlugin;

        const scheduleId = 1003;
        when(mockPreferencesService.notificationsEnabled).thenReturn(true);
        when(mockMedicationScheduleProvider.schedules).thenReturn([
          MedicationSchedule(
            id: scheduleId,
            name: 'Past Schedule',
            dose: Decimal.fromInt(10),
            intervalDays: 1,
            molecule: KnownMolecules.estradiol,
            administrationRoute: AdministrationRoute.oral,
            notificationTimes: [
              TimeOfDay.fromDateTime(
                  DateTime.now().subtract(Duration(minutes: 1)))
            ],
          )
        ]);
        when(mockMedicationIntakeProvider
                .getLastIntakeDateForSchedule(scheduleId))
            .thenReturn(null);

        final scheduler = NotificationScheduler(
          mockMedicationScheduleProvider,
          mockMedicationIntakeProvider,
          mockPreferencesService,
        );

        // Act
        await scheduler.regenerateAll();

        // Assert
        verify(mockPlugin.zonedSchedule(
          id: anyNamed('id'),
          title: anyNamed('title'),
          body: anyNamed('body'),
          scheduledDate: anyNamed('scheduledDate'),
          notificationDetails: anyNamed('notificationDetails'),
          androidScheduleMode: anyNamed('androidScheduleMode'),
          payload: anyNamed('payload'),
        )).called(4);

        // Cleanup
        NotificationService.createPlugin = origCreate;
        NotificationService.isPlatformSupported = origPlatformCheck;
      });

      test('Schedule with multiple notification times -> schedule accordingly',
          () async {
        // Arrange
        final origPlatformCheck = NotificationService.isPlatformSupported;
        final origCreate = NotificationService.createPlugin;
        NotificationService.isPlatformSupported = () => true;
        NotificationService.createPlugin = () => mockPlugin;

        final now = DateTime.now();
        final times = [
          TimeOfDay(hour: (now.hour + 1) % 24, minute: 0),
          TimeOfDay(hour: (now.hour + 2) % 24, minute: 30),
        ];

        // When we generate the notification times and they go after 23:59 it
        // goes back to 00:00 but as the same day than DateTime.now() and not
        // the next day so the scheduler see it as behind the current time
        // and ignores them.
        // So we have to count the ignored times for the test to pass.

        int ignored = 0;
        for (final time in times) {
          final dateTime = DateTime(
            now.year,
            now.month,
            now.day,
            time.hour,
            time.minute,
          );
          if (now.isAfter(dateTime)) ignored++;
        }

        const scheduleId = 1004;
        when(mockPreferencesService.notificationsEnabled).thenReturn(true);
        when(mockMedicationScheduleProvider.schedules).thenReturn([
          MedicationSchedule(
            id: scheduleId,
            name: 'MultiTime Schedule',
            dose: Decimal.fromInt(10),
            intervalDays: 1,
            molecule: KnownMolecules.estradiol,
            administrationRoute: AdministrationRoute.oral,
            notificationTimes: times,
          )
        ]);
        when(mockMedicationIntakeProvider
                .getLastIntakeDateForSchedule(scheduleId))
            .thenReturn(null);

        final scheduler = NotificationScheduler(
          mockMedicationScheduleProvider,
          mockMedicationIntakeProvider,
          mockPreferencesService,
        );

        // Act
        await scheduler.regenerateAll();

        // Assert
        verify(mockPlugin.zonedSchedule(
          id: anyNamed('id'),
          title: anyNamed('title'),
          body: anyNamed('body'),
          scheduledDate: anyNamed('scheduledDate'),
          notificationDetails: anyNamed('notificationDetails'),
          androidScheduleMode: anyNamed('androidScheduleMode'),
          payload: anyNamed('payload'),
        )).called(10 - ignored);

        // Cleanup
        NotificationService.createPlugin = origCreate;
        NotificationService.isPlatformSupported = origPlatformCheck;
      });

      test(
          'Skips future notification times today when intake already taken today',
          () async {
        // Arrange
        const scheduleId = 4242;
        final origPlatformCheck = NotificationService.isPlatformSupported;
        final origCreate = NotificationService.createPlugin;
        NotificationService.isPlatformSupported = () => true;
        NotificationService.createPlugin = () => mockPlugin;

        when(mockPreferencesService.notificationsEnabled).thenReturn(true);
        when(mockMedicationIntakeProvider
                .getLastIntakeDateForSchedule(scheduleId))
            .thenReturn(Date.today());
        when(mockMedicationScheduleProvider.schedules).thenReturn([
          MedicationSchedule(
            id: scheduleId,
            name: 'Taken Today Schedule',
            dose: Decimal.fromInt(10),
            intervalDays: 1,
            molecule: KnownMolecules.estradiol,
            administrationRoute: AdministrationRoute.oral,
            notificationTimes: [
              TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 1)))
            ],
          )
        ]);
        when(mockPlugin.zonedSchedule(
                id: anyNamed('id'),
                title: anyNamed('title'),
                body: anyNamed('body'),
                scheduledDate: anyNamed('scheduledDate'),
                notificationDetails: anyNamed('notificationDetails'),
                androidScheduleMode: anyNamed('androidScheduleMode'),
                payload: anyNamed('payload')))
            .thenAnswer((_) async {});

        final scheduler = NotificationScheduler(
          mockMedicationScheduleProvider,
          mockMedicationIntakeProvider,
          mockPreferencesService,
        );

        // Act
        await scheduler.regenerateAll();

        // Assert
        verify(mockPlugin.zonedSchedule(
          id: anyNamed('id'),
          title: anyNamed('title'),
          body: anyNamed('body'),
          scheduledDate: anyNamed('scheduledDate'),
          notificationDetails: anyNamed('notificationDetails'),
          androidScheduleMode: anyNamed('androidScheduleMode'),
          payload: anyNamed('payload'),
        )).called(4);

        // Cleanup
        NotificationService.createPlugin = origCreate;
        NotificationService.isPlatformSupported = origPlatformCheck;
      });
    });
  });
}
