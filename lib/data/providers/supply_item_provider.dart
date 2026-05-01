import 'package:flutter/material.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/data/model/medication_supply_item.dart';
import 'package:mona/services/repository.dart';

class SupplyItemProvider extends ChangeNotifier {
  List<MedicationSupplyItem> _items = [];
  bool _isLoading = true;
  final Repository<MedicationSupplyItem> repository;

  static final defaultRepository = Repository<MedicationSupplyItem>(
    tableName: 'supply_items',
    toMap: (item) => item.toMap(),
    fromMap: (map) => MedicationSupplyItem.fromMap(map),
  );

  List<MedicationSupplyItem> get items => _items;

  bool get isLoading => _isLoading;

  List<MedicationSupplyItem> get orderedByRemainingDose => [..._items]..sort(
      (a, b) => a.getRatio().compareTo(b.getRatio()),
    );

  MedicationSupplyItem? getItemById(int? id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  SupplyItemProvider({Repository<MedicationSupplyItem>? repository})
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

  MedicationSupplyItem? getMostUsedItemForMedication(Molecule molecule,
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

  List<MedicationSupplyItem> getItemsForMedication(Molecule molecule,
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

  Future<void> deleteItem(MedicationSupplyItem item) async {
    await repository.delete(item.id);
    await fetchItems();
  }

  Future<void> add(MedicationSupplyItem supplyItem) async {
    await repository.insert(supplyItem);
    await fetchItems();
  }

  Future<void> updateItem(MedicationSupplyItem item) async {
    await repository.update(item, item.id);
    await fetchItems();
  }
}
