import 'package:decimal/decimal.dart';
import '../data/model/supply_item.dart';
import '../data/providers/supply_item_provider.dart';

class SupplyItemManager {
  final SupplyItemProvider _supplyItemProvider;

  SupplyItemManager(this._supplyItemProvider);

  static SupplyItemManager create(SupplyItemProvider supplyItemProvider) {
    return SupplyItemManager(supplyItemProvider);
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

    await _supplyItemProvider.updateItem(newItem);
    return newItem;
  }

  /// Uses a portion of the amount of the [SupplyItem] and updates the database.
  Future<void> useDose(SupplyItem item, Decimal doseToUse) async {
    print('Using dose: $doseToUse from item: ${item.name}');
    if (doseToUse == Decimal.zero) {
      return;
    }

    if (item.usedDose + doseToUse > item.totalDose) {
      doseToUse = item.totalDose - item.usedDose;
    }

    await _supplyItemProvider.updateItem(item.copyWith(
      usedDose: item.usedDose + doseToUse,
    ));
  }
}
