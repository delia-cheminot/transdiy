import 'package:intl/intl.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/services/notifications/notification_service.dart';
import 'package:mona/util/date_helpers.dart';

class NotificationScheduler {
  final MedicationScheduleProvider medicationScheduleProvider;

  NotificationScheduler(this.medicationScheduleProvider);

  bool shouldSkipNotificationForToday(DateTime date) {
    if (!date.isAtSameMomentAs(normalizedToday())) {
      return false;
    }

    final now = DateTime.now();
    final scheduledNotificationTime = DateTime(
      date.year,
      date.month,
      date.day,
      defaultNotificationHour,
      defaultNotificationMinute,
    );

    return now.isAfter(scheduledNotificationTime);
  }

  Future<void> regenerateAll() async {
    NotificationService().cancelPendingNotifications();

    final schedules = medicationScheduleProvider.schedules;

    for (final schedule in schedules) {
      for (final date in schedule.getNextDates(count: 5)) {
        if (shouldSkipNotificationForToday(date)) continue;

        await NotificationService().scheduleNotification(
          id: date.millisecondsSinceEpoch ~/ 1000,
          title: 'Time to take ${schedule.name}',
          body: 'Next intake scheduled for ${DateFormat.MMMMd().format(date)}',
          year: date.year,
          month: date.month,
          day: date.day,
        );
      }
    }
  }
}
