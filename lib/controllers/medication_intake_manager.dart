import 'package:decimal/decimal.dart';
import 'package:transdiy/controllers/supply_item_manager.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/data/providers/medication_schedule_provider.dart';
import 'package:transdiy/data/providers/supply_item_provider.dart';
import '../data/model/medication_intake.dart';
import '../data/providers/medication_intake_provider.dart';

class MedicationIntakeManager {
  final MedicationIntakeProvider _medicationIntakeState;
  final MedicationScheduleProvider _medicationScheduleProvider;
  final SupplyItemProvider _supplyItemProvider;

  MedicationIntakeManager(this._medicationIntakeState,
      this._medicationScheduleProvider, this._supplyItemProvider);

  static MedicationIntakeManager create(
      MedicationIntakeProvider medicationIntakeState,
      MedicationScheduleProvider medicationScheduleProvider,
      SupplyItemProvider supplyItemProvider) {
    return MedicationIntakeManager(
        medicationIntakeState, medicationScheduleProvider, supplyItemProvider);
  }

  Future<void> takeMedication(MedicationIntake intake, SupplyItem supplyItem,
      {DateTime? takenDate}) async {
    if (intake.isTaken) {
      throw ArgumentError('Medication already taken');
    }

    MedicationIntake updatedIntake = intake;

    if (!supplyItem.canUseDose(updatedIntake.dose)) {
      Decimal remainingDose = supplyItem.getRemainingDose();
      Decimal doseToAdd = updatedIntake.dose - remainingDose;
      updatedIntake = updatedIntake.copyWith(dose: remainingDose);
      await _medicationIntakeState.addIntake(
          updatedIntake.scheduledDateTime, doseToAdd);
    }

    SupplyItemManager(_supplyItemProvider)
        .useDose(supplyItem, updatedIntake.dose);
    updatedIntake = updatedIntake.copyWith(
      takenDateTime: takenDate ?? DateTime.now(),
    );
    await _medicationIntakeState.updateIntake(updatedIntake);

    final schedule = updatedIntake.scheduleId != null
        ? _medicationScheduleProvider.getScheduleById(updatedIntake.scheduleId!)
        : null;
    if (schedule != null) {
      await _medicationScheduleProvider.updateSchedule(
          schedule.copyWith(lastTaken: updatedIntake.takenDateTime!));
    }
  }
}
