import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/data/providers/supply_item_state.dart';
import 'package:transdiy/ui/pages/supplies/pharmacy_item.dart';

class PharmacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pharmacyState = context.watch<SupplyItemState>();

    if (pharmacyState.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (pharmacyState.items.isEmpty) {
      return Center(
        child: Text('Ajoutez un élément pour commencer'),
      );
    }

    return ListView.builder(
      itemCount: pharmacyState.items.length,
      itemBuilder: (context, index) {
        SupplyItem item = pharmacyState.items[index];
        return PharmacyItem(
          item: item,
        );
      },
    );
  }
}
