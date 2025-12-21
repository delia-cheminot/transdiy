import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/data/providers/supply_item_provider.dart';
import 'package:transdiy/ui/views/supplies/pharmacy_item.dart';

class PharmacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final supplyItemProvider = context.watch<SupplyItemProvider>();

    if (supplyItemProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (supplyItemProvider.items.isEmpty) {
      return Center(
        child: Text('Ajoutez un élément pour commencer'),
      );
    }

    return ListView.builder(
      itemCount: supplyItemProvider.items.length,
      itemBuilder: (context, index) {
        SupplyItem item = supplyItemProvider.items[index];
        return PharmacyItem(
          item: item,
        );
      },
    );
  }
}
