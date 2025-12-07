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
    final newItem = item.copyWith(
      name: newName,
      totalDose: newTotalDose,
      usedDose: newUsedDose,
      dosePerUnit: newDosePerUnit,
      quantity: newQuantity,
    );

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
    await _supplyItemState.updateItem(item.copyWith(
      usedDose: item.usedDose + doseToUse,
    ));
  }
}
