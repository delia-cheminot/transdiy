import 'package:decimal/decimal.dart';
import 'package:mona/controllers/supply_item_manager.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/model/medication_supply.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/supply_item_provider.dart';

class MedicationIntakeManager {
  final MedicationIntakeProvider _medicationIntakeProvider;
  final SupplyItemProvider _supplyItemProvider;

  MedicationIntakeManager(
      this._medicationIntakeProvider, this._supplyItemProvider);

  Future<void> takeMedication({
    required Decimal dose,
    required DateTime scheduledDateTime,
    required DateTime takenDateTime,
    required String takenTimeZone,
    MedicationSupply? supplyItem,
    required MedicationSchedule schedule,
    InjectionSide? side,
    Decimal? deadSpace, //in μL
  }) async {
    if (!takenDateTime.isUtc) {
      throw ArgumentError('takenDateTime must be in UTC');
    }

    await _medicationIntakeProvider.add(MedicationIntake(
      dose: dose,
      scheduledDateTime: scheduledDateTime,
      takenDateTime: takenDateTime,
      takenTimeZone: takenTimeZone,
      side: side,
      scheduleId: schedule.id,
      molecule: schedule.molecule,
      administrationRoute: schedule.administrationRoute,
      ester: schedule.ester,
    ));

    if (supplyItem == null) return;

    if (deadSpace != null && deadSpace > Decimal.zero) {
      final deadSpaceMl = deadSpace * Decimal.parse('0.001');
      dose += supplyItem.getDose(deadSpaceMl);
    }

    await SupplyItemManager(_supplyItemProvider).useDose(supplyItem, dose);
  }

  InjectionSide getNextSide() {
    final lastIntake = _medicationIntakeProvider.getLastTakenIntake();
    if (lastIntake == null || lastIntake.side == null) {
      return InjectionSide.left;
    }
    return lastIntake.side == InjectionSide.left
        ? InjectionSide.right
        : InjectionSide.left;
  }
}
