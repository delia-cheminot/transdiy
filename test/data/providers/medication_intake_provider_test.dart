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

    test('addIntake inserts a new item', () async {
      // Arrange
      final newDate = DateTime(2025, 9, 13, 8, 0);
      final newDose = Decimal.parse('2.5');

      // Act
      await provider.addIntake(newDate, newDose);

      // Assert

      expect(
        [
          provider.intakes.length,
          provider.intakes.last.scheduledDateTime,
          provider.intakes.last.dose
        ],
        [3, newDate, newDose],
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
      expect(provider.intakes.first.dose, Decimal.parse('99.9'));
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
  });
}
