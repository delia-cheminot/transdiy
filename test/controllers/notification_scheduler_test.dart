import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mona/controllers/notification_scheduler.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/services/preferences_service.dart';

@GenerateNiceMocks([
  MockSpec<MedicationScheduleProvider>(),
  MockSpec<PreferencesService>(),
])
import 'notification_scheduler_test.mocks.dart';

void main() {
  late MockMedicationScheduleProvider mockMedicationScheduleProvider;
  late MockPreferencesService mockPreferencesService;

  setUp(() {
    mockMedicationScheduleProvider = MockMedicationScheduleProvider();
    mockPreferencesService = MockPreferencesService();
  });

  group('NotificationScheduler.shouldSkipNotificationForToday', () {
    test(
        'should not skip notification when date is today and current time is before notification time',
        () {
      final futureHour = (DateTime.now().hour + 1) % 24;
      when(mockPreferencesService.notificationTime)
          .thenReturn(TimeOfDay(hour: futureHour, minute: 0));

      final scheduler = NotificationScheduler(
        mockMedicationScheduleProvider,
        mockPreferencesService,
      );

      final today = DateTime.now();
      expect(scheduler.shouldSkipNotificationForToday(today), isFalse);
    });

    test(
        'should skip notification when date is today and current time is after notification time',
        () {
      final pastHour = (DateTime.now().hour - 1) % 24;
      when(mockPreferencesService.notificationTime)
          .thenReturn(TimeOfDay(hour: pastHour, minute: 0));

      final scheduler = NotificationScheduler(
        mockMedicationScheduleProvider,
        mockPreferencesService,
      );

      final today = DateTime.now();
      expect(scheduler.shouldSkipNotificationForToday(today), isTrue);
    });

    test('should not skip notification when date is not today', () {
      when(mockPreferencesService.notificationTime)
          .thenReturn(const TimeOfDay(hour: 12, minute: 0));

      final scheduler = NotificationScheduler(
        mockMedicationScheduleProvider,
        mockPreferencesService,
      );

      final tomorrow = DateTime.now().add(const Duration(days: 1));
      expect(scheduler.shouldSkipNotificationForToday(tomorrow), isFalse);
    });
  });
}
