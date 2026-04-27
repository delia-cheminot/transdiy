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

    if (item.usedDose + doseToUse < Decimal.fromInt(0)) {
      doseToUse = -item.usedDose;
    }

    await _supplyItemProvider.updateItem(item.copyWith(
      usedDose: item.usedDose + doseToUse,
    ));
  }

  /// Switch doses between two [SupplyItem]
  void switchDoses(SupplyItem? previousItem, SupplyItem? nextItem,
      Decimal previousDose, Decimal nextDose) {
    bool sameItems = nextItem == previousItem;

    if (previousItem != null) {
      if(sameItems) {
        Decimal doseDifference = nextDose - previousDose;
        useDose(previousItem, doseDifference);
      } else {
        useDose(previousItem, -previousDose);
      }
    }

    if (nextItem != null && !sameItems) {
      useDose(nextItem, nextDose);
    }
  }
}
