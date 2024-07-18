import 'package:flutter/material.dart';
import 'package:transdiy/data/supply_item_model.dart';

class SuppliesState extends ChangeNotifier {
  List<SupplyItem> _items = [];
  bool _isLoading = true;

  List<SupplyItem> get items => _items;
  bool get isLoading => _isLoading;

  SuppliesState() {
    print('PharmacyState init');
    _init();
  }

  Future<void> _init() async {
    _items = await SupplyItem.getItems();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchItems() async {
    _items = await SupplyItem.getItems();
    notifyListeners();
  }

  Future<void> deleteItem(int id) async {
    await SupplyItem.deleteItem(id);
    fetchItems();
  }

  Future<void> addItem(double volume) async {
    await SupplyItem.insertItem(SupplyItem(volume: volume));
    fetchItems();
  }
}
