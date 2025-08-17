import 'package:decimal/decimal.dart';
import 'package:transdiy/controllers/supply_item_manager.dart';
import 'package:transdiy/data/model/supply_item.dart';
import '../data/model/medication_intake.dart';
import '../data/providers/medication_intake_provider.dart';

class MedicationIntakeManager {
  final MedicationIntakeProvider _medicationIntakeState;

  MedicationIntakeManager(this._medicationIntakeState);

  static MedicationIntakeManager create(
      MedicationIntakeProvider medicationIntakeState) {
    return MedicationIntakeManager(medicationIntakeState);
  }

  Future<void> takeMedication(MedicationIntake intake, SupplyItem supplyItem,
      SupplyItemManager supplyItemManager,
      {DateTime? takenDate}) async {
    if (intake.isTaken) {
      throw ArgumentError('Medication already taken');
    }

    if (!supplyItem.canUseDose(intake.dose)) {
      Decimal remainingDose = supplyItem.getRemainingDose();
      Decimal doseToAdd = intake.dose - remainingDose;
      intake.dose = remainingDose;
      await _medicationIntakeState.addIntake(
          intake.scheduledDateTime, doseToAdd);
    }

    supplyItemManager.useDose(supplyItem, intake.dose);
    intake.takenDateTime = takenDate ?? DateTime.now();
    await _medicationIntakeState.updateIntake(intake);
  }
}
