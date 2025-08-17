import 'package:decimal/decimal.dart';
import '../data/model/supply_item.dart';
import '../data/providers/supply_item_provider.dart';

class SupplyItemManager {
  final SupplyItemProvider _supplyItemState;

  SupplyItemManager(this._supplyItemState);

  static SupplyItemManager create(SupplyItemProvider supplyItemState) {
    return SupplyItemManager(supplyItemState);
  }

  Future<SupplyItem> setFields(
    SupplyItem item, {
    String? newName,
    Decimal? newTotalDose,
    Decimal? newUsedDose,
    Decimal? newDosePerUnit,
    int? newQuantity,
  }) async {
    SupplyItem newItem = item.copy();

    newItem.totalDose = newTotalDose ?? item.totalDose;
    newItem.usedDose = newUsedDose ?? item.usedDose;
    newItem.dosePerUnit = newDosePerUnit ?? item.dosePerUnit;
    newItem.quantity = newQuantity ?? item.quantity;
    newItem.name = newName ?? item.name;

    if (!newItem.isValid()) {
      throw ArgumentError('Invalid item');
    }

    await _supplyItemState.updateItem(newItem);
    return newItem;
  }

  /// Uses a portion of the amount of the [SupplyItem] and updates the database.
  Future<void> useDose(SupplyItem item, Decimal doseToUse) async {
    if (doseToUse == Decimal.zero) {
      return;
    }
    if (!item.canUseDose(doseToUse)) {
      throw ArgumentError('Item capacity exceeded');
    }
    item.usedDose = item.usedDose + doseToUse;
    await _supplyItemState.updateItem(item);
  }
}
