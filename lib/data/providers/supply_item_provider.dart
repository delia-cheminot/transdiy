import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mona/data/model/supply_item.dart';
import 'package:mona/services/repository.dart';

class SupplyItemProvider extends ChangeNotifier {
  List<SupplyItem> _items = [];
  bool _isLoading = true;
  final Repository<SupplyItem> repository;

  static final defaultRepository = Repository<SupplyItem>(
    tableName: 'supply_items',
    toMap: (item) => item.toMap(),
    fromMap: (map) => SupplyItem.fromMap(map),
  );

  List<SupplyItem> get items => _items;
  bool get isLoading => _isLoading;
  List<SupplyItem> get orderedByRemainingDose => [..._items]..sort(
      (a, b) => a.getRatio().compareTo(b.getRatio()),
    );

  SupplyItemProvider({Repository<SupplyItem>? repository})
      : repository = repository ?? defaultRepository {
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
    await repository.delete(item.id);
    await fetchItems();
  }

  Future<void> addItem(
      Decimal totalDose, String name, Decimal dosePerUnit) async {
    await repository.insert(
        SupplyItem(totalDose: totalDose, dosePerUnit: dosePerUnit, name: name));
    await fetchItems();
  }

  Future<void> updateItem(SupplyItem item) async {
    await repository.update(item, item.id);
    await fetchItems();
  }
}
