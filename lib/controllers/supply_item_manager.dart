import 'package:decimal/decimal.dart';
import 'package:mona/data/model/medication_supply.dart';
import 'package:mona/data/model/supply_item.dart';
import 'package:mona/data/model/supply_type.dart';
import 'package:mona/data/providers/supply_item_provider.dart';

class SupplyItemManager {
  final SupplyItemProvider _supplyItemProvider;

  SupplyItemManager(this._supplyItemProvider);

  /// Uses a portion of the amount of the [SupplyItem] and updates the database.
  Future<void> useDose(SupplyItem item, Decimal doseToUse) async {
    if (item.getType() == SupplyType.medication) {
      item = item as MedicationSupply;
      if (doseToUse == Decimal.zero) {
        return;
      }

      if (item.usedDose + doseToUse > item.totalDose) {
        doseToUse = item.totalDose - item.usedDose;
      }

      if(item.usedDose + doseToUse < Decimal.fromInt(0)) {
        doseToUse = -item.usedDose;
      }

      await _supplyItemProvider.updateItem(item.copyWith(
        usedDose: item.usedDose + doseToUse,
      ));
    }
  }
}
