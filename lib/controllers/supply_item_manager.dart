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
    double? newTotalAmount,
    double? newUsedAmount,
    double? newDosePerUnit,
    int? newQuantity,
  }) async {
    SupplyItem newItem = item.copy();

    if (newTotalAmount != null) {
      newTotalAmount = SupplyItem.roundAmount(newTotalAmount);
    }
    if (newUsedAmount != null) {
      newUsedAmount = SupplyItem.roundAmount(newUsedAmount);
    }

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
