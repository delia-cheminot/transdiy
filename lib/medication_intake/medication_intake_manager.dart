import 'package:transdiy/supply_item/supply_item.dart';
import 'package:transdiy/supply_item/supply_item_manager.dart';

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

    double volumeToUse = intake.quantity / supplyItem.concentration;

    if (supplyItem.usedVolume + volumeToUse > supplyItem.volume) {
      // Uses only possible volume and creates a new intake with the remaining quantity
      double remainingQuantity = (supplyItem.volume - supplyItem.usedVolume) *
          supplyItem.concentration; // remaining quantity in mg in the supply
      double quantityToAdd = intake.quantity - remainingQuantity;
      intake.quantity = remainingQuantity;
      await _medicationIntakeState.addIntake(
          intake.scheduledDateTime, quantityToAdd);
      volumeToUse = supplyItem.volume - supplyItem.usedVolume;
    }

    // use volume
    supplyItemManager.useVolume(supplyItem, volumeToUse);
    intake.takenDateTime = takenDate ?? DateTime.now();
    await _medicationIntakeState.updateIntake(intake);
  }
}
