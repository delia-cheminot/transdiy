import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/medication_intake.dart';

void main() {
  group('MedicationIntake model', () {
    test('toMap and fromMap should preserve values', () {
      final scheduled = DateTime(2025, 9, 14, 10, 30);
      final taken = DateTime(2025, 9, 14, 12, 0);

      final intake = MedicationIntake(
        id: 1,
        scheduledDateTime: scheduled,
        dose: Decimal.parse('2.5'),
        takenDateTime: taken,
        scheduleId: 42,
        side: InjectionSide.left,
      );

      final map = intake.toMap();
      final fromMap = MedicationIntake.fromMap(map);

      expect(fromMap, intake);
    });

    test('copy creates identical object but different instance', () {
      final scheduled = DateTime(2025, 9, 14, 10, 30);
      final taken = DateTime(2025, 9, 14, 12, 0);

      final intake = MedicationIntake(
        id: 2,
        scheduledDateTime: scheduled,
        dose: Decimal.fromInt(5),
        takenDateTime: taken,
        scheduleId: 7,
        side: InjectionSide.left,
      );

      final copy = intake.copy();

      expect(copy, intake);
    });

    test('isTaken returns correct value', () {
      final scheduled = DateTime(2025, 9, 14, 10, 30);

      final intakeTaken = MedicationIntake(
        scheduledDateTime: scheduled,
        dose: Decimal.one,
        takenDateTime: DateTime(2025, 9, 14, 11, 0),
      );

      final intakeNotTaken = MedicationIntake(
        scheduledDateTime: scheduled,
        dose: Decimal.one,
      );

      expect(
        [
          intakeTaken.isTaken,
          intakeNotTaken.isTaken,
        ],
        [
          true,
          false,
        ],
      );
    });

    test('toString includes id, scheduledDateTime, and isTaken', () {
      final scheduled = DateTime(2025, 9, 14, 10, 30);
      final intake = MedicationIntake(
        id: 3,
        scheduledDateTime: scheduled,
        dose: Decimal.fromInt(2),
      );

      final stringValue = intake.toString();

      expect(
        stringValue.contains(intake.id.toString()) &&
            stringValue.contains(intake.scheduledDateTime.toString()) &&
            stringValue.contains(intake.isTaken.toString()),
        true,
      );
    });
  });
}
