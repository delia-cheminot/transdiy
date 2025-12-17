import 'package:decimal/decimal.dart';
import 'package:transdiy/data/model/medication_intake.dart';
import 'package:transdiy/data/model/medication_schedule.dart';

import '../data/providers/medication_intake_provider.dart';

class MedicationIntakeGenerator {
  final MedicationIntakeProvider _medicationIntakeProvider;

  MedicationIntakeGenerator(this._medicationIntakeProvider);

  Future<void> generateIntakes(
      MedicationSchedule schedule, int numberOfIntakes) async {
    final List<DateTime> newIntakeDates = [];
    DateTime startOfWindow =
        DateTime.now().subtract(Duration(days: schedule.intervalDays));
    DateTime endOfWindow = startOfWindow
        .add(Duration(days: numberOfIntakes * schedule.intervalDays));
    DateTime cursor = schedule.startDate; // only increases

    while (cursor.isBefore(startOfWindow)) {
      cursor = cursor.add(Duration(days: schedule.intervalDays));
    }

    // cursor >= max(startOfWindow, schedule.startDate)

    while (cursor.isBefore(endOfWindow)) {
      newIntakeDates.add(cursor);
      cursor = cursor.add(Duration(days: schedule.intervalDays));
    }

    for (final date in newIntakeDates) {
      await _medicationIntakeProvider.add(MedicationIntake(
          scheduledDateTime: date,
          dose: Decimal.parse('0'),
          scheduleId: schedule.id));
    }
  }
}

    //     |----------|
  //     |  TODO test |
  //     |------------|
  //        ||
  // (\__/) ||
  // (•ㅅ•) ||
  // / 　 づ