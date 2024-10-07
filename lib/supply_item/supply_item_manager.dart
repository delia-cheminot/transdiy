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
    double? newDosagePerUnit,
    int? newQuantity,
  }) async {
    SupplyItem newItem = item.copy();

    newItem.totalAmount = newTotalAmount ?? item.totalAmount;
    newItem.usedAmount = newUsedAmount ?? item.usedAmount;
    newItem.dosagePerUnit = newDosagePerUnit ?? item.dosagePerUnit;
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
    if (item.usedAmount + amountToUse > item.totalAmount) {
      throw ArgumentError('Item capacity exceeded');
    }
    item.usedAmount += amountToUse;
    await _supplyItemState.updateItem(item);
  }
}
