import '../models/supply_item.dart';
import '../providers/supplies_state.dart';

class SupplyItemManager {
  final SuppliesState _suppliesState;

  SupplyItemManager(this._suppliesState);

  static SupplyItemManager create(SuppliesState suppliesState) {
    return SupplyItemManager(suppliesState);
  }

  Future<void> setFields(
    SupplyItem item, {
    double? newVolume,
    double? newUsedVolume,
    String? newName,
    DateTime? newExpirationDate,
  }) async {
    if (newVolume != null) {
      item.volume = newVolume;
    }
    if (newUsedVolume != null) {
      if (newUsedVolume > item.volume) {
        throw ArgumentError('Used volume cannot exceed total volume');
      }
      item.usedVolume = newUsedVolume;
    }

    await _suppliesState.updateItem(item);
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
