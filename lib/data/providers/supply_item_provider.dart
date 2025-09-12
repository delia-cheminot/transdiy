import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/services/generic_repository.dart';

class SupplyItemProvider extends ChangeNotifier {
  List<SupplyItem> _items = [];
  bool _isLoading = true;
  final GenericRepository<SupplyItem> repository;

  List<SupplyItem> get items => _items;
  bool get isLoading => _isLoading;

  SupplyItemProvider({GenericRepository<SupplyItem>? repository})
      : repository = repository ??
            GenericRepository<SupplyItem>(
              tableName: 'supply_items',
              toMap: (item) => item.toMap(),
              fromMap: (map) => SupplyItem.fromMap(map),
            ) {
    _init();
  }

  Future<void> _init() async {
    _items = await repository.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchItems() async {
    _items = await repository.getAll();
    notifyListeners();
  }

  Future<void> deleteItemFromId(int id) async {
    await repository.delete(id);
    await fetchItems();
  }

  Future<void> deleteItem(SupplyItem item) async {
    assert(item.id != null);
    await repository.delete(item.id!);
    await fetchItems();
  }

  Future<void> addItem(
      Decimal totalDose, String name, Decimal dosePerUnit) async {
    await repository.insert(
        SupplyItem(totalDose: totalDose, dosePerUnit: dosePerUnit, name: name));
    await fetchItems();
  }

  Future<void> updateItem(SupplyItem item) async {
    assert(item.id != null);
    await repository.update(item, item.id!);
    await fetchItems();
  }
}
