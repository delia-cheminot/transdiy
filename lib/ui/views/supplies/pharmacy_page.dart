import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/data/providers/supply_item_provider.dart';
import 'package:transdiy/ui/views/supplies/supply_item_card.dart';

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

    return MasonryGridView.builder(
      gridDelegate: SliverSimpleGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300),
      itemCount: supplyItemProvider.items.length,
      itemBuilder: (context, index) {
        SupplyItem item = supplyItemProvider.items[index];
        return SupplyItemCard(item: item);
      },
    );
  }


}
