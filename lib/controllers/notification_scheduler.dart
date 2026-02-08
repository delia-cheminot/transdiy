import 'package:intl/intl.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/services/notification_service.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:mona/util/date_helpers.dart';

class NotificationScheduler {
  final MedicationScheduleProvider medicationScheduleProvider;
  final PreferencesService preferencesService;

  NotificationScheduler(
      this.medicationScheduleProvider, this.preferencesService);

  bool _shouldSkipNotificationForToday(DateTime date) {
    if (!normalizeDate(date).isAtSameMomentAs(normalizedToday())) {
      return false;
    }

    final now = DateTime.now();
    final scheduledNotificationTime = DateTime(
      date.year,
      date.month,
      date.day,
      preferencesService.notificationTime.hour,
      preferencesService.notificationTime.minute,
    );

    return now.isAfter(scheduledNotificationTime);
  }

  Future<void> regenerateAll() async {
    NotificationService().triggerPastPendingNotifications();
    NotificationService().cancelPendingNotifications();

    for (final schedule in medicationScheduleProvider.schedules) {
      await Future.wait(schedule
          .getNextDates(count: 5)
          .where((date) => !_shouldSkipNotificationForToday(date))
          .map((date) => NotificationService().scheduleNotification(
                title: 'Time to take ${schedule.name}',
                body:
                    'Next intake scheduled for ${DateFormat.MMMMd().format(date)}',
                year: date.year,
                month: date.month,
                day: date.day,
                hour: preferencesService.notificationTime.hour,
                minute: preferencesService.notificationTime.minute,
              )));
    }
  }
}
