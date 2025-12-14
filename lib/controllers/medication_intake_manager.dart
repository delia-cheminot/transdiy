import 'package:transdiy/controllers/supply_item_manager.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/data/providers/supply_item_provider.dart';
import '../data/model/medication_intake.dart';
import '../data/providers/medication_intake_provider.dart';

class MedicationIntakeManager {
  final MedicationIntakeProvider _medicationIntakeProvider;
  final SupplyItemProvider _supplyItemProvider;

  MedicationIntakeManager(
      this._medicationIntakeProvider, this._supplyItemProvider);

  Future<void> takeMedication(MedicationIntake intake, SupplyItem supplyItem,
      {DateTime? takenDate}) async {
    if (intake.isTaken) {
      throw ArgumentError('Medication already taken');
    }

    MedicationIntake updatedIntake = intake;

    updatedIntake = await _checkDoseAndSplitIfNeeded(updatedIntake, supplyItem);

    updatedIntake =
        await _markIntakeTaken(updatedIntake, supplyItem, takenDate);
  }

  Future<MedicationIntake> _checkDoseAndSplitIfNeeded(
      MedicationIntake intake, SupplyItem supplyItem) async {
    if (supplyItem.canUseDose(intake.dose)) {
      return intake;
    }

    final remainingDose = supplyItem.getRemainingDose();
    final doseToAdd = intake.dose - remainingDose;
    final updatedIntake = intake.copyWith(dose: remainingDose);
    await _medicationIntakeProvider.addIntake(
        updatedIntake.scheduledDateTime, doseToAdd);

    return updatedIntake;
  }

  Future<MedicationIntake> _markIntakeTaken(MedicationIntake intake,
      SupplyItem supplyItem, DateTime? takenDate) async {
    SupplyItemManager(_supplyItemProvider).useDose(supplyItem, intake.dose);
    final updatedIntake = intake.copyWith(
      takenDateTime: takenDate ?? DateTime.now(),
    );

    await _medicationIntakeProvider.updateIntake(updatedIntake);

    return updatedIntake;
  }
}
