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

  Future<void> takeMedication(
      MedicationIntake intake, SupplyItem supplyItem,
      {DateTime? takenDate}) async {
    final updatedIntake = intake.copyWith(
      takenDateTime: takenDate ?? DateTime.now(),
    );

    await _medicationIntakeProvider.add(updatedIntake);
    await SupplyItemManager(_supplyItemProvider)
        .useDose(supplyItem, updatedIntake.dose);
  }
}
