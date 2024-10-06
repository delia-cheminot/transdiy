import 'medication_intake.dart';
import 'medication_intake_state.dart';

class MedicationIntakeManager {
  final MedicationIntakeState _medicationIntakeState;

  MedicationIntakeManager(this._medicationIntakeState);

  static MedicationIntakeManager create(
      MedicationIntakeState medicationIntakeState) {
    return MedicationIntakeManager(medicationIntakeState);
  }

  Future<void> takeMedication(MedicationIntake intake,
      {DateTime? takenDate}) async {
    if (intake.isTaken) {
      throw ArgumentError('Medication already taken');
    }

    intake.takenDateTime = takenDate ?? DateTime.now();
    await _medicationIntakeState.updateIntake(intake);
  }
}
