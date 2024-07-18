import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/supply_item_model.dart';
import 'package:transdiy/pages/supplies/pharmacy_item.dart';
import 'package:transdiy/providers/supplies_state.dart';

class PharmacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pharmacyState = context.watch<SuppliesState>();

    if (pharmacyState.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (pharmacyState.items.isEmpty) {
      return Center(
        child: Text('No items in pharmacy'),
      );
    }

    return ListView.builder(
      itemCount: pharmacyState.items.length,
      itemBuilder: (context, index) {
        SupplyItem item = pharmacyState.items[index];
        return PharmacyItem(
          item: item,
          onDelete: () async {
            await pharmacyState.deleteItem(item.id!);
          },
        );
      },
    );
  }
}
