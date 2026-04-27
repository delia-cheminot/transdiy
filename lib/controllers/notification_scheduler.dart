import 'package:intl/intl.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/services/notification_service.dart';
import 'package:mona/services/preferences_service.dart';

class NotificationScheduler {
  final MedicationScheduleProvider medicationScheduleProvider;
  final MedicationIntakeProvider medicationIntakeProvider;
  final PreferencesService preferencesService;

  NotificationScheduler(
    this.medicationScheduleProvider,
    this.medicationIntakeProvider,
    this.preferencesService,
  );

  Map<DateTime, MedicationSchedule> _getNotificationTimes() {
    final Map<DateTime, MedicationSchedule> notificationsToSchedule = {};
    final now = DateTime.now();

    for (final schedule in medicationScheduleProvider.schedules) {
      final lastTaken =
          medicationIntakeProvider.getLastIntakeDateForSchedule(schedule.id);
      final nextDates = schedule.getNextDates(5);

      for (final date in nextDates) {
        for (final time in schedule.notificationTimes) {
          final dateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );

          if (now.isAfter(dateTime)) continue;
          if (date.isToday && schedule.isTakenTodayOrLater(lastTaken)) {
            continue;
          }

          notificationsToSchedule[dateTime] = schedule;
        }
      }
    }

    return notificationsToSchedule;
  }

  Future<void> regenerateAll(AppLocalizations l10n, String localeName) async {
    NotificationService().triggerPastPendingNotifications();
    NotificationService().cancelPendingNotifications();

    if (!preferencesService.notificationsEnabled) {
      return;
    }

    final scheduledDateTimeFormat = DateFormat.MMMMd(localeName);

    final notificationTimes = _getNotificationTimes();

    await Future.wait(
      notificationTimes.entries.map(
        (entry) {
          final dateTime = entry.key;
          final schedule = entry.value;

          return NotificationService().scheduleNotification(
            title: l10n.notificationMedicationReminderTitle(schedule.name),
            body: l10n.notificationMedicationReminderBody(
              scheduledDateTimeFormat.format(dateTime),
            ),
            year: dateTime.year,
            month: dateTime.month,
            day: dateTime.day,
            hour: dateTime.hour,
            minute: dateTime.minute,
          );
        },
      ),
    );
  }
}
