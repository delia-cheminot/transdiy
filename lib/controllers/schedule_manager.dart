import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';

enum ScheduleStatus { overdue, todayOverdue, today, upcoming, taken }

class ScheduleManager {
  final MedicationScheduleProvider _medicationScheduleProvider;
  final MedicationIntakeProvider _medicationIntakeProvider;

  ScheduleManager(
      this._medicationScheduleProvider, this._medicationIntakeProvider);

  List<MedicationSchedule> getSchedulesByStatus(ScheduleStatus status) {
    final List<MedicationSchedule> schedules = [];
    for (final schedule in _medicationScheduleProvider.schedules) {
      final lastTaken =
          _medicationIntakeProvider.getLastIntakeDateForSchedule(schedule.id);

      switch (status) {
        case ScheduleStatus.today:
          if (schedule.isScheduledForToday() &&
              !schedule.isLate(lastTaken) &&
              !schedule.isTakenToday(lastTaken)) {
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
              !schedule.isLate(lastTaken))) {
            schedules.add(schedule);
          }
          break;
        case ScheduleStatus.taken:
          if (schedule.isScheduledForToday() &&
              schedule.isTakenToday(lastTaken)) {
            schedules.add(schedule);
          }
          break;
      }
    }
    return schedules;
  }
}
