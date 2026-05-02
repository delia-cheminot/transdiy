import 'package:flutter/material.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/molecule.dart';
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

  SupplyItem? getItemById(int? id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

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

  SupplyItem? getMostUsedItemForMedication(Molecule molecule,
      AdministrationRoute administrationRoute, Ester? ester) {
    if (_items.isEmpty) return null;

    final filtered = orderedByRemainingDose.where(
      (item) =>
          item.molecule == molecule &&
          item.administrationRoute == administrationRoute &&
          item.ester == ester,
    );

    return filtered.isEmpty ? null : filtered.first;
  }

  List<SupplyItem> getItemsForMedication(Molecule molecule,
      AdministrationRoute administrationRoute, Ester? ester) {
    if (_items.isEmpty) return [];

    return orderedByRemainingDose
        .where(
          (item) =>
              item.molecule == molecule &&
              item.administrationRoute == administrationRoute &&
              item.ester == ester,
        )
        .toList();
  }

  Future<void> deleteItemFromId(int id) async {
    await repository.delete(id);
    await fetchItems();
  }

  Future<void> deleteItem(SupplyItem item) async {
    await repository.delete(item.id);
    await fetchItems();
  }

  Future<void> add(SupplyItem supplyItem) async {
    await repository.insert(supplyItem);
    await fetchItems();
  }

  Future<void> updateItem(SupplyItem item) async {
    await repository.update(item, item.id);
    await fetchItems();
  }
}
