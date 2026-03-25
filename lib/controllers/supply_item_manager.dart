import 'package:decimal/decimal.dart';
import '../data/model/supply_item.dart';
import '../data/providers/supply_item_provider.dart';

class SupplyItemManager {
  final SupplyItemProvider _supplyItemProvider;

  SupplyItemManager(this._supplyItemProvider);

  /// Uses a portion of the amount of the [SupplyItem] and updates the database.
  Future<void> useDose(SupplyItem item, Decimal doseToUse) async {
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

  /// Switch doses between two [SupplyItem]
  void switchDoses(SupplyItem? previousItem, SupplyItem? nextItem,
      Decimal previousDose, Decimal nextDose) {
      // If there was a previous item, edit or put back dose.
      if (previousItem != null) {
        if(nextItem == previousItem) {
          // Same item so we calculate the difference
          Decimal doseDifference = previousDose - nextDose;
          useDose(previousItem, -doseDifference);
        } else {
          // Different item from the previous item so we put back the dose for the previous item
          useDose(previousItem, -previousDose);
        }
      }

    // If there is a new item and it isn't the same as the previous one, take the dose
    if (nextItem != null && (nextItem != previousItem)) {
      useDose(nextItem, nextDose);
    }
  }
}
