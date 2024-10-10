import 'package:transdiy/models/supply_item/supply_item.dart';
import 'package:transdiy/models/supply_item/supply_item_manager.dart';
import 'medication_intake.dart';
import 'medication_intake_state.dart';

class MedicationIntakeManager {
  final MedicationIntakeState _medicationIntakeState;

  MedicationIntakeManager(this._medicationIntakeState);

  static MedicationIntakeManager create(
      MedicationIntakeState medicationIntakeState) {
    return MedicationIntakeManager(medicationIntakeState);
  }

  Future<void> takeMedication(MedicationIntake intake, SupplyItem supplyItem,
      SupplyItemManager supplyItemManager,
      {DateTime? takenDate}) async {
    if (intake.isTaken) {
      throw ArgumentError('Medication already taken');
    }

    double amountToUse = intake.dose / supplyItem.dosePerUnit;

    if (!supplyItem.canUseAmount(amountToUse)) {
      // Uses only possible amount and creates a new intake with the remaining dose
      double remainingDose = MedicationIntake.roundDose(
          supplyItem.getRemainingAmount() * supplyItem.dosePerUnit);
      double doseToAdd =
          MedicationIntake.roundDose(intake.dose - remainingDose);
      // Rounded to avoid floating point errors
      intake.dose = remainingDose;
      await _medicationIntakeState.addIntake(
          intake.scheduledDateTime, doseToAdd);
      amountToUse = supplyItem.getRemainingAmount();
    }

    supplyItemManager.useAmount(supplyItem, amountToUse);
    intake.takenDateTime = takenDate ?? DateTime.now();
    await _medicationIntakeState.updateIntake(intake);
  }
}
