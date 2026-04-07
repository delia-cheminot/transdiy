import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/date.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
  });
  group('MedicationIntake', () {
    test('constructor should throw if takenDateTime is not UTC', () {
      expect(
        () => MedicationIntake(
          scheduledDateTime: DateTime.now(),
          dose: Decimal.one,
          takenDateTime: DateTime.now(),
          takenTimeZone: 'Etc/UTC',
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
        ),
        throwsArgumentError,
      );
    });

    test(
        'constructor should throw if takenDateTime is provided without takenTimeZone',
        () {
      expect(
        () => MedicationIntake(
          scheduledDateTime: DateTime.now(),
          dose: Decimal.one,
          takenDateTime: DateTime.utc(2025, 9, 14, 12, 0),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
        ),
        throwsArgumentError,
      );
    });

    test('toMap and fromMap should preserve values', () {
      final scheduled = DateTime.utc(2025, 9, 14, 10, 30);
      final taken = DateTime.utc(2025, 9, 14, 12, 0);

      final intake = MedicationIntake(
          id: 1,
          scheduledDateTime: scheduled,
          dose: Decimal.parse('2.5'),
          takenDateTime: taken,
          takenTimeZone: 'Etc/UTC',
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
            .having(
                (i) => i.takenTimeZone, 'takenTimeZone', intake.takenTimeZone)
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
        takenDateTime: DateTime.utc(2025, 9, 14, 11, 0),
        takenTimeZone: 'Etc/UTC',
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

    group('takenLocalDateTime and takenLocalDate', () {
      test('takenLocalDateTime returns null when takenDateTime is null', () {
        // Arrange
        final intake = MedicationIntake(
          scheduledDateTime: DateTime.utc(2024, 6, 15, 10, 0),
          dose: Decimal.one,
          takenDateTime: null,
          takenTimeZone: 'Europe/Paris',
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
        );

        // Act
        final result = intake.takenLocalDateTime;

        // Assert
        expect(result, isNull);
      });

      test(
          'takenLocalDateTime converts UTC to Europe/Paris summer time (UTC+2)',
          () {
        // Arrange
        final intake = MedicationIntake(
          scheduledDateTime: DateTime.utc(2024, 6, 15, 10, 0),
          dose: Decimal.one,
          takenDateTime: DateTime.utc(2024, 6, 15, 8, 0),
          takenTimeZone: 'Europe/Paris',
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
        );

        // Act
        final takenLocalDateTime = intake.takenLocalDateTime;

        // Assert
        expect(takenLocalDateTime?.hour, 10);
      });

      test(
          'takenLocalDateTime handles day rollback when crossing midnight behind UTC',
          () {
        // Arrange
        final intake = MedicationIntake(
          scheduledDateTime: DateTime.utc(2024, 6, 15, 10, 0),
          dose: Decimal.one,
          takenDateTime: DateTime.utc(2024, 6, 15, 1, 0),
          takenTimeZone: 'America/New_York',
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
        );

        // Act
        final result = intake.takenLocalDateTime;

        // Assert
        expect(result?.day, 14);
      });

      test('takenLocalDate returns null when takenDateTime is null', () {
        // Arrange
        final intake = MedicationIntake(
          scheduledDateTime: DateTime.utc(2024, 6, 15, 10, 0),
          dose: Decimal.one,
          takenDateTime: null,
          takenTimeZone: 'Europe/Paris',
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
        );

        // Act
        final result = intake.takenLocalDate;

        // Assert
        expect(result, isNull);
      });

      test('takenLocalDate returns correct date in Europe/Paris timezone', () {
        // Arrange
        final intake = MedicationIntake(
          scheduledDateTime: DateTime.utc(2024, 6, 15, 10, 0),
          dose: Decimal.one,
          takenDateTime: DateTime.utc(2024, 6, 15, 10, 0),
          takenTimeZone: 'Europe/Paris',
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
        );

        // Act
        final result = intake.takenLocalDate;

        // Assert
        expect(result, Date(DateTime.utc(2024, 6, 15)));
      });

      test(
          'takenLocalDate returns previous calendar date when local time crosses midnight behind UTC',
          () {
        // Arrange
        final intake = MedicationIntake(
          scheduledDateTime: DateTime.utc(2024, 6, 15, 10, 0),
          dose: Decimal.one,
          takenDateTime: DateTime.utc(2024, 6, 15, 1, 0),
          takenTimeZone: 'America/New_York',
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
        );

        // Act
        final result = intake.takenLocalDate;

        // Assert
        expect(result, Date(DateTime.utc(2024, 6, 14)));
      });

      test(
          'takenLocalDate returns previous date if taken is before 4am local time',
          () {
        // Arrange
        final intake = MedicationIntake(
          scheduledDateTime: DateTime.utc(2024, 6, 15, 10, 0),
          dose: Decimal.one,
          takenDateTime: DateTime.utc(2024, 6, 15, 2, 0),
          takenTimeZone: 'Etc/UTC',
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
        );

        // Act
        final result = intake.takenLocalDate;

        // Assert
        expect(result, Date(DateTime.utc(2024, 6, 14)));
      });
    });
  });
}
