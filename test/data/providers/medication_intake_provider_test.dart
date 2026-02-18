import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/medication_intake.dart';
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
      ),
    );
    provider = MedicationIntakeProvider(repository: repo);
    repo.insert(MedicationIntake(
        id: 1,
        scheduledDateTime: DateTime(2025, 9, 12, 8, 0),
        dose: Decimal.parse('10.5'),
        takenDateTime: DateTime(2025, 9, 12, 8, 15)));
    repo.insert(MedicationIntake(
        id: 2,
        scheduledDateTime: DateTime(2025, 9, 12, 20, 0),
        dose: Decimal.parse('5.0')));
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
          takenDateTime: intakeToUpdate.takenDateTime);

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
      ));
      provider.add(MedicationIntake(
        id: 101,
        scheduledDateTime: DateTime(2025, 9, 15, 8, 0),
        dose: Decimal.parse('1.0'),
      ));
      provider.add(MedicationIntake(
        id: 102,
        scheduledDateTime: DateTime(2025, 9, 16, 8, 0),
        dose: Decimal.parse('1.0'),
        takenDateTime: DateTime(2025, 9, 16, 8, 10),
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
  });
}
