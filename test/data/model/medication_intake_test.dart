import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/model/molecule.dart';

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
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.injection,
          ester: Ester.cypionate);

      final map = intake.toMap();
      final fromMap = MedicationIntake.fromMap(map);

      expect(
        fromMap,
        isA<MedicationIntake>()
            .having((i) => i.id, 'id', intake.id)
            .having((i) => i.scheduledDateTime, 'scheduledDateTime',
                intake.scheduledDateTime)
            .having(
                (i) => i.takenDateTime, 'takenDateTime', intake.takenDateTime)
            .having((i) => i.dose, 'dose', intake.dose)
            .having((i) => i.scheduleId, 'scheduleId', intake.scheduleId)
            .having((i) => i.side, 'side', intake.side)
            .having((i) => i.molecule, 'molecule', intake.molecule)
            .having((i) => i.administrationRoute, 'administrationRoute',
                intake.administrationRoute)
            .having((i) => i.ester, 'ester', intake.ester),
      );
    });

    test('isTaken returns correct value', () {
      final scheduled = DateTime(2025, 9, 14, 10, 30);

      final intakeTaken = MedicationIntake(
        scheduledDateTime: scheduled,
        dose: Decimal.one,
        takenDateTime: DateTime(2025, 9, 14, 11, 0),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.gel,
      );

      final intakeNotTaken = MedicationIntake(
        scheduledDateTime: scheduled,
        dose: Decimal.one,
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.gel,
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
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.gel,
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
