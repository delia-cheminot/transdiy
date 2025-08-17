import 'package:flutter/material.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/data/repositories/supply_item_repository.dart';

class SupplyItemProvider extends ChangeNotifier {
  List<SupplyItem> _items = [];
  bool _isLoading = true;

  List<SupplyItem> get items => _items;
  bool get isLoading => _isLoading;

  SupplyItemProvider() {
    _init();
  }

  Future<void> _init() async {
    _items = await SupplyItemRepository.getItems();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchItems() async {
    _items = await SupplyItemRepository.getItems();
    notifyListeners();
  }

  Future<void> deleteItemFromId(int id) async {
    await SupplyItemRepository.deleteItemFromId(id);
    fetchItems();
  }

  Future<void> deleteItem(SupplyItem item) async {
    await SupplyItemRepository.deleteItem(item);
    fetchItems();
  }

  Future<void> addItem(double totalAmount, String name, double dosePerUnit) async {
    await SupplyItemRepository.insertItem(
        SupplyItem(totalAmount: totalAmount, dosePerUnit: dosePerUnit, name: name));
    fetchItems();
  }

  Future<void> updateItem(SupplyItem item) async {
    await SupplyItemRepository.updateItem(item);
    fetchItems();
  }
}
