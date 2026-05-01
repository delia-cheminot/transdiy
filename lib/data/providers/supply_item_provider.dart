import 'package:flutter/material.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/medication_supply.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/data/model/supply.dart';
import 'package:mona/services/repository.dart';

class SupplyItemProvider extends ChangeNotifier {
  List<Supply> _items = [];
  bool _isLoading = true;
  final Repository<Supply> repository;

  static final defaultRepository = Repository<Supply>(
    tableName: 'supply_items',
    toMap: (item) => item.toMap(),
    fromMap: (map) => Supply.fromMap(map),
  );

  List<Supply> get items => _items;
  List<MedicationSupply> get medicationItems =>
      _items.where((item) => item.type == SupplyType.medication).toList()
          as List<MedicationSupply>;

  bool get isLoading => _isLoading;

  List<MedicationSupply> get orderedByRemainingDose =>
      [...medicationItems]..sort(
          (a, b) => a.getRatio().compareTo(b.getRatio()),
        );

  Supply? getItemById(int? id) {
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  SupplyItemProvider({Repository<Supply>? repository})
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

  MedicationSupply? getMostUsedItemForMedication(Molecule molecule,
      AdministrationRoute administrationRoute, Ester? ester) {
    if (medicationItems.isEmpty) return null;

    final filtered = orderedByRemainingDose.where(
      (item) =>
          item.molecule == molecule &&
          item.administrationRoute == administrationRoute &&
          item.ester == ester,
    );

    return filtered.isEmpty ? null : filtered.first;
  }

  List<MedicationSupply> getItemsForMedication(Molecule molecule,
      AdministrationRoute administrationRoute, Ester? ester) {
    if (medicationItems.isEmpty) return [];

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

  Future<void> deleteItem(Supply item) async {
    await repository.delete(item.id);
    await fetchItems();
  }

  Future<void> add(Supply supplyItem) async {
    await repository.insert(supplyItem);
    await fetchItems();
  }

  Future<void> updateItem(Supply item) async {
    await repository.update(item, item.id);
    await fetchItems();
  }
}
