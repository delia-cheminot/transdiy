import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:transdiy/medication_intake/medication_intake.dart';
import 'package:transdiy/medication_intake/medication_intake_manager.dart';
import 'mocks.mocks.dart';

void main() {
  late MedicationIntakeManager manager;
  late MockMedicationIntakeState mockMedicationIntakeState;

  setUp(() {
    mockMedicationIntakeState = MockMedicationIntakeState();
    manager = MedicationIntakeManager(mockMedicationIntakeState);
  });

  group('MedicationIntakeManager', () {
    test('should take medication correctly', () async {
      final intake = MedicationIntake(
        id: 1,
        scheduledDateTime: DateTime.now(),
      );

      await manager.takeMedication(intake);

      expect(intake.isTaken, true);
      verify(mockMedicationIntakeState.updateIntake(intake)).called(1);
    });

    test('should throw ArgumentError when taking medication already taken', () {
      final intake = MedicationIntake(
        id: 1,
        scheduledDateTime: DateTime.now(),
        takenDateTime: DateTime.now(),
      );

      expect(() => manager.takeMedication(intake), throwsArgumentError);
    });

    test('should take medication with custom date', () async {
      final intake = MedicationIntake(
        id: 1,
        scheduledDateTime: DateTime.now(),
      );
      final customDate = DateTime.now().add(Duration(days: 1));

      await manager.takeMedication(intake, takenDate: customDate);

      expect(intake.isTaken, true);
      expect(intake.takenDateTime, customDate);
      verify(mockMedicationIntakeState.updateIntake(intake)).called(1);
    });
  });
}