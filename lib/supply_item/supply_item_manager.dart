import 'supplies_state.dart';
import 'supply_item.dart';

class SupplyItemManager {
  final SuppliesState _suppliesState;

  SupplyItemManager(this._suppliesState);

  static SupplyItemManager create(SuppliesState suppliesState) {
    return SupplyItemManager(suppliesState);
  }

  Future<SupplyItem> setFields(
    SupplyItem item, {
    String? newName,
    double? newVolume,
    double? newUsedVolume,
    int? newQuantity,
  }) async {
    SupplyItem newItem = item.copy();

    newItem.volume = newVolume ?? item.volume;
    newItem.usedVolume = newUsedVolume ?? item.usedVolume;
    newItem.quantity = newQuantity ?? item.quantity;
    newItem.name = newName ?? item.name;

    if (!newItem.isValid()) { 
      throw ArgumentError('Invalid item');
    }

    await _suppliesState.updateItem(newItem);
    return newItem;
  }

  /// Uses a portion of the volume of the [SupplyItem] and updates the database.
  Future<void> useVolume(SupplyItem item, double volumeToUse) async {
    if (volumeToUse == 0) {
      return;
    }
    if (item.usedVolume + volumeToUse > item.volume) {
      throw ArgumentError('Volume exceeded');
    }
    item.usedVolume += volumeToUse;
    await _suppliesState.updateItem(item);
  }
}
