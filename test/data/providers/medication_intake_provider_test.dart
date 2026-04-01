import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/date.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'generic_repository_mock.dart';

void main() {
  late MedicationIntakeProvider provider;
  late GenericRepositoryMock<MedicationIntake> repo;

  setUp(() {
    repo = GenericRepositoryMock<MedicationIntake>(
      withId: (i, id) => MedicationIntake(
          id: id,
          scheduledDateTime: i.scheduledDateTime,
          dose: i.dose,
          takenDateTime: i.takenDateTime,
          scheduleId: i.scheduleId,
          molecule: i.molecule,
          administrationRoute: i.administrationRoute,
          ester: i.ester),
    );
    provider = MedicationIntakeProvider(repository: repo);
    repo.insert(MedicationIntake(
      id: 1,
      scheduledDateTime: DateTime(2025, 9, 12, 8, 0),
      dose: Decimal.parse('10.5'),
      takenDateTime: DateTime(2025, 9, 12, 8, 15),
      molecule: KnownMolecules.estradiol,
      administrationRoute: AdministrationRoute.gel,
    ));
    repo.insert(MedicationIntake(
      id: 2,
      scheduledDateTime: DateTime(2025, 9, 12, 20, 0),
      dose: Decimal.parse('5.0'),
      molecule: KnownMolecules.estradiol,
      administrationRoute: AdministrationRoute.gel,
    ));
  });

  group('MedicationIntakeProvider Tests', () {
    test('initialization loads intakes', () async {
      await provider.fetchIntakes();
      expect(provider.intakes.length, repo.items.length);
    });

    test('add inserts a new item', () async {
      // Arrange
      final newDate = DateTime(2025, 9, 13, 8, 0);
      final newDose = Decimal.parse('2.5');

      // Act
      await provider.add(MedicationIntake(
        scheduledDateTime: newDate,
        dose: newDose,
        takenDateTime: DateTime(2025, 9, 13, 8, 10),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.gel,
      ));

      // Assert
      expect(
        provider.intakes
            .any((i) => i.scheduledDateTime == newDate && i.dose == newDose),
        true,
      );
    });

    test('updateIntake updates an existing item', () async {
      // Arrange
      final intakeToUpdate = repo.items.first;
      final updatedIntake = MedicationIntake(
        id: intakeToUpdate.id,
        scheduledDateTime: intakeToUpdate.scheduledDateTime,
        dose: Decimal.parse('99.9'),
        takenDateTime: intakeToUpdate.takenDateTime,
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.gel,
      );

      // Act
      await provider.updateIntake(updatedIntake);

      // Assert
      final fetchedIntake =
          provider.intakes.firstWhere((i) => i.id == intakeToUpdate.id);
      expect(fetchedIntake.dose, Decimal.parse('99.9'));
    });

    test('deleteIntakeFromId removes the item', () async {
      // Act
      await provider.deleteIntakeFromId(1);

      // Assert
      expect(
        [provider.intakes.length, provider.intakes.first.id],
        [1, 2],
      );
    });

    test('deleteIntake removes the item by object', () async {
      // Arrange
      final intakeToDelete = repo.items.first;

      // Act
      await provider.deleteIntake(intakeToDelete);

      // Assert
      expect(
        [provider.intakes.length, provider.intakes.first.id],
        [1, 2],
      );
    });

    test('takenIntakes and notTakenIntakes return correct subsets', () async {
      await provider.fetchIntakes();
      expect(
        [provider.takenIntakes, provider.notTakenIntakes],
        [
          repo.items.where((i) => i.isTaken).toList(),
          repo.items.where((i) => !i.isTaken).toList()
        ],
      );
    });

    test('takenIntakesSortedDesc returns taken intakes sorted descending',
        () async {
      await provider.fetchIntakes();
      provider.add(MedicationIntake(
        id: 100,
        scheduledDateTime: DateTime(2025, 9, 14, 8, 0),
        dose: Decimal.parse('1.0'),
        takenDateTime: DateTime(2025, 9, 14, 8, 10),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.gel,
      ));
      provider.add(MedicationIntake(
        id: 101,
        scheduledDateTime: DateTime(2025, 9, 15, 8, 0),
        dose: Decimal.parse('1.0'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.gel,
      ));
      provider.add(MedicationIntake(
        id: 102,
        scheduledDateTime: DateTime(2025, 9, 16, 8, 0),
        dose: Decimal.parse('1.0'),
        takenDateTime: DateTime(2025, 9, 16, 8, 10),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.gel,
      ));

      final sorted = provider.takenIntakesSortedDesc;

      expect(
        sorted.asMap().entries.every((entry) {
          final i = entry.key;
          final intake = entry.value;
          if (!intake.isTaken) return false;
          if (i < sorted.length - 1) {
            final next = sorted[i + 1];
            if (intake.takenDateTime!.isBefore(next.takenDateTime!)) {
              return false;
            }
          }
          return true;
        }),
        true,
      );

      provider.deleteIntakeFromId(100);
      provider.deleteIntakeFromId(101);
      provider.deleteIntakeFromId(102);
    });

    group('getTakenIntakesForSchedule', () {
      test('returns only taken intakes for the given schedule', () async {
        repo.insert(MedicationIntake(
          id: 100,
          scheduleId: 100,
          scheduledDateTime: DateTime(2025, 9, 13, 8, 0),
          dose: Decimal.parse('10.0'),
          takenDateTime: DateTime(2025, 9, 13, 8, 15),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.gel,
        ));
        repo.insert(MedicationIntake(
          id: 200,
          scheduleId: 200,
          scheduledDateTime: DateTime(2025, 9, 13, 8, 0),
          dose: Decimal.parse('10.0'),
          takenDateTime: DateTime(2025, 9, 13, 8, 15),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.gel,
        ));
        await provider.fetchIntakes();

        expect(provider.getTakenIntakesForSchedule(100).length, 1);
      });

      test('returns empty list if no taken intakes for schedule', () async {
        await provider.fetchIntakes();

        expect(provider.getTakenIntakesForSchedule(3), isEmpty);
      });
    });

    group('getLastIntakeDateFromList', () {
      test('returns null if the list is empty', () {
        final result = provider.getLastIntakeDateFromList([]);
        expect(result, isNull);
      });

      test('returns the only takenDateTime if list has one intake', () {
        final intake = MedicationIntake(
          id: 1,
          scheduleId: 1,
          scheduledDateTime: DateTime(2025, 9, 12, 8, 0),
          dose: Decimal.parse('10.5'),
          takenDateTime: DateTime(2025, 9, 12, 8, 15),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.gel,
        );

        final result = provider.getLastIntakeDateFromList([intake]);
        // TODO use local date
        expect(result, Date.fromDateTime(intake.takenDateTime!));
      });

      test('returns the latest takenDateTime if list has multiple intakes', () {
        final intake1 = MedicationIntake(
          id: 1,
          scheduleId: 1,
          scheduledDateTime: DateTime(2025, 9, 12, 8, 0),
          dose: Decimal.parse('10.5'),
          takenDateTime: DateTime(2025, 9, 12, 8, 15),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.gel,
        );

        final intake2 = MedicationIntake(
          id: 2,
          scheduleId: 1,
          scheduledDateTime: DateTime(2025, 9, 12, 20, 0),
          dose: Decimal.parse('5.0'),
          takenDateTime: DateTime(2025, 9, 12, 20, 10),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.gel,
        );

        final intake3 = MedicationIntake(
          id: 3,
          scheduleId: 1,
          scheduledDateTime: DateTime(2025, 9, 13, 8, 0),
          dose: Decimal.parse('2.5'),
          takenDateTime: DateTime(2025, 9, 13, 8, 5),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.gel,
        );

        final result =
            provider.getLastIntakeDateFromList([intake1, intake2, intake3]);
        // TODO use local date
        expect(result, Date.fromDateTime(intake3.takenDateTime!));
      });

      test('handles intakes with same takenDateTime correctly', () {
        final dt = DateTime(2025, 9, 12, 8, 0);
        final intake1 = MedicationIntake(
          id: 1,
          scheduleId: 1,
          scheduledDateTime: dt,
          dose: Decimal.parse('10.5'),
          takenDateTime: dt,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.gel,
        );

        final intake2 = MedicationIntake(
          id: 2,
          scheduleId: 1,
          scheduledDateTime: dt,
          dose: Decimal.parse('5.0'),
          takenDateTime: dt,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.gel,
        );

        final result = provider.getLastIntakeDateFromList([intake1, intake2]);
        // TODO use local date
        expect(result, Date.fromDateTime(dt));
      });
    });
  });
}
