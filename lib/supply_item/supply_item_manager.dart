import 'supply_item.dart';
import 'supply_item_state.dart';

class SupplyItemManager {
  final SupplyItemState _supplyItemState;

  SupplyItemManager(this._supplyItemState);

  static SupplyItemManager create(SupplyItemState supplyItemState) {
    return SupplyItemManager(supplyItemState);
  }

  Future<SupplyItem> setFields(
    SupplyItem item, {
    String? newName,
    double? newTotalAmount,
    double? newUsedAmount,
    double? newDosePerUnit,
    int? newQuantity,
  }) async {
    SupplyItem newItem = item.copy();

    newItem.totalAmount = newTotalAmount ?? item.totalAmount;
    newItem.usedAmount = newUsedAmount ?? item.usedAmount;
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
  Future<void> useAmount(SupplyItem item, double amountToUse) async {
    if (amountToUse == 0) {
      return;
    }
    if (!item.canUseAmount(amountToUse)) {
      throw ArgumentError('Item capacity exceeded');
    }
    item.usedAmount = SupplyItem.roundAmount(item.usedAmount + amountToUse);
    // Rounded to avoid floating point errors
    await _supplyItemState.updateItem(item);
  }
}
