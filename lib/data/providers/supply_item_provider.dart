import 'package:flutter/material.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/generic_supply.dart';
import 'package:mona/data/model/medication_supply.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/data/model/supply_item.dart';
import 'package:mona/data/model/supply_type.dart';
import 'package:mona/services/repository.dart';

class SupplyItemProvider extends ChangeNotifier {
  List<MedicationSupply> _medicationItems = [];
  List<GenericSupply> _genericItems = [];
  bool _isLoading = true;
  final Repository<SupplyItem> repository;

  static final defaultRepository = Repository<SupplyItem>(
    tableName: 'supply_items',
    toMap: (item) => item.toMap(),
    fromMap: (map) => SupplyItem.fromMap(map),
  );

  List<MedicationSupply> get medicationItems => _medicationItems..sort(
        (a, b) => a.name.compareTo(b.name),
  );
  List<GenericSupply> get genericItems => _genericItems..sort(
        (a, b) => a.name.compareTo(b.name),
  );

  bool get isLoading => _isLoading;

  List<MedicationSupply> get medicationSuppliesOrderedByRemainingDose => [..._medicationItems]..sort(
      (a, b) => a.getRatio().compareTo(b.getRatio()),
    );

  SupplyItemProvider({Repository<SupplyItem>? repository})
      : repository = repository ?? defaultRepository {
    fetchAll();
  }

  Future<void> fetchAll() async {
    fetchMedicationItems();
    fetchGenericItems();
    notifyListeners();
    _isLoading = false;
  }

  Future<void> fetchMedicationItems() async {
    _medicationItems = (await repository.getAll())
      .where((item) =>
          item.getType()==SupplyType.medication
      )
      .map((item)=>item as MedicationSupply)
      .toList();
    notifyListeners();
  }

  Future<void> fetchGenericItems() async {
    _genericItems = (await repository.getAll())
      .where((item) =>
          item.getType()==SupplyType.generic
      )
      .map((item)=>item as GenericSupply)
      .toList();
    notifyListeners();
  }

  MedicationSupply? getMostUsedItemForMedication(Molecule molecule,
      AdministrationRoute administrationRoute, Ester? ester) {
    if (_medicationItems.isEmpty) return null;

    final filtered = medicationSuppliesOrderedByRemainingDose.where(
      (item) =>
          item.molecule == molecule &&
          item.administrationRoute == administrationRoute &&
          item.ester == ester,
    );

    return filtered.isEmpty ? null : filtered.first;
  }

  List<MedicationSupply> getItemsForMedication(Molecule molecule,
      AdministrationRoute administrationRoute, Ester? ester) {
    if (_medicationItems.isEmpty) return [];

    return medicationSuppliesOrderedByRemainingDose
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
    await fetchAll();
  }

  Future<void> deleteItem(SupplyItem item) async {
    await repository.delete(item.getId());
    await fetchAll();
  }

  Future<void> add(SupplyItem medicationSupply) async {
    await repository.insert(medicationSupply);
    await fetchAll();
  }

  Future<void> updateItem(SupplyItem item) async {
    await repository.update(item, item.getId());
    await fetchAll();
  }
}
