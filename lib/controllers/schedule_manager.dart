import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/util/date_helpers.dart';

enum ScheduleStatus { overdue, todayOverdue, today, upcoming }

class ScheduleManager {
  final MedicationScheduleProvider _medicationScheduleProvider;
  final MedicationIntakeProvider _medicationIntakeProvider;

  ScheduleManager(
      this._medicationScheduleProvider, this._medicationIntakeProvider);

  bool isTakenToday(MedicationSchedule schedule) {
    final lastDate =
        _medicationIntakeProvider.getLastIntakeDateForSchedule(schedule.id);
    if (lastDate == null) return false;
    return normalizeDate(lastDate) == normalizedToday();
  }

  List<MedicationSchedule> getSchedulesByStatus(ScheduleStatus status) {
    final List<MedicationSchedule> schedules = [];
    for (final schedule in _medicationScheduleProvider.schedules) {
      final lastTaken =
          _medicationIntakeProvider.getLastIntakeDateForSchedule(schedule.id);

      switch (status) {
        case ScheduleStatus.today:
          if (schedule.isScheduledForToday() &&
              !schedule.isLate(lastTaken) &&
              !isTakenToday(schedule)) {
            schedules.add(schedule);
          }
          break;
        case ScheduleStatus.todayOverdue:
          if (schedule.isScheduledForToday() && schedule.isLate(lastTaken)) {
            schedules.add(schedule);
          }
          break;
        case ScheduleStatus.overdue:
          if (!schedule.isScheduledForToday() && schedule.isLate(lastTaken)) {
            schedules.add(schedule);
          }
          break;
        case ScheduleStatus.upcoming:
          if ((!schedule.isScheduledForToday() &&
                  !schedule.isLate(lastTaken)) ||
              schedule.isScheduledForToday() &&
                  isTakenToday(schedule)) {
            schedules.add(schedule);
          }
          break;
      }
    }
    return schedules;
  }
}
