import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transdiy/data/model/medication_schedule.dart';

void main() {
  group('MedicationSchedule model', () {
    test('toMap and fromMap should preserve values', () {
      final schedule = MedicationSchedule(
        id: 1,
        name: 'Test Med',
        dose: Decimal.parse('10.5'),
        intervalDays: 7,
      );

      final map = {
        'id': schedule.id,
        'name': schedule.name,
        'dose': schedule.dose.toString(),
        'intervalDays': schedule.intervalDays,
        'lastTaken': schedule.lastTaken.toIso8601String(),
      };

      final fromMap = MedicationSchedule.fromMap(map);

      expect(
        [
          fromMap.id,
          fromMap.name,
          fromMap.dose,
          fromMap.intervalDays,
          fromMap.lastTaken
        ],
        [
          schedule.id,
          schedule.name,
          schedule.dose,
          schedule.intervalDays,
          schedule.lastTaken
        ],
      );
    });

    test('copy creates identical object but different instance', () {
      final schedule = MedicationSchedule(
        id: 2,
        name: 'Copy Med',
        dose: Decimal.fromInt(5),
        intervalDays: 3,
      );

      final copy = schedule.copy();

      expect(
        [
          copy.id,
          copy.name,
          copy.dose,
          copy.intervalDays,
          copy.lastTaken,
        ],
        [
          schedule.id,
          schedule.name,
          schedule.dose,
          schedule.intervalDays,
          schedule.lastTaken,
        ],
      );
    });

    test('isValid returns correct values', () {
      final schedules = [
        MedicationSchedule(
            name: 'Valid', dose: Decimal.fromInt(5), intervalDays: 3),
        MedicationSchedule(name: '', dose: Decimal.fromInt(5), intervalDays: 3),
        MedicationSchedule(
            name: 'Zero dose', dose: Decimal.zero, intervalDays: 3),
        MedicationSchedule(
            name: 'Negative dose', dose: Decimal.fromInt(-1), intervalDays: 3),
        MedicationSchedule(
            name: 'Zero interval', dose: Decimal.fromInt(5), intervalDays: 0),
        MedicationSchedule(
            name: 'Negative interval',
            dose: Decimal.fromInt(5),
            intervalDays: -2),
      ];

      expect(
        schedules.map((s) => s.isValid()).toList(),
        [true, false, false, false, false, false],
      );
    });

    test('validateName works correctly', () {
      expect(
        [
          MedicationSchedule.validateName(null),
          MedicationSchedule.validateName(''),
          MedicationSchedule.validateName('Valid'),
        ],
        [
          isNotNull,
          isNotNull,
          isNull,
        ],
      );
    });

    test('validateDose works correctly', () {
      expect(
        [
          MedicationSchedule.validateDose(null),
          MedicationSchedule.validateDose(''),
          MedicationSchedule.validateDose('0'),
          MedicationSchedule.validateDose('-1'),
          MedicationSchedule.validateDose('abc'),
          MedicationSchedule.validateDose('2.5'),
        ],
        [
          isNotNull,
          isNotNull,
          isNotNull,
          isNotNull,
          isNotNull,
          isNull,
        ],
      );
    });

    test('validateIntervalDays works correctly', () {
      expect(
        [
          MedicationSchedule.validateIntervalDays(null),
          MedicationSchedule.validateIntervalDays(''),
          MedicationSchedule.validateIntervalDays('0'),
          MedicationSchedule.validateIntervalDays('-2'),
          MedicationSchedule.validateIntervalDays('abc'),
          MedicationSchedule.validateIntervalDays('7'),
        ],
        [
          isNotNull,
          isNotNull,
          isNotNull,
          isNotNull,
          isNotNull,
          isNull,
        ],
      );
    });
  });
}
