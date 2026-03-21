import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mona/data/model/generic_supply.dart';
import 'package:mona/data/model/medication_supply.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
import 'package:mona/ui/constants/dimensions.dart';
import 'package:mona/ui/views/supplies/generic_supply_card.dart';
import 'package:mona/ui/views/supplies/medication_supply_card.dart';
import 'package:mona/ui/widgets/main_page_wrapper.dart';
import 'package:provider/provider.dart';

class PharmacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SupplyItemProvider>(
      builder: (context, supplyItemProvider, child) {
        return MainPageWrapper(
          isLoading: supplyItemProvider.isLoading,
          isEmpty: supplyItemProvider.medicationItems.isEmpty && supplyItemProvider.genericItems.isEmpty,
          emptyMessage: 'No supplies. Add an item to get started!',
          child: MasonryGridView.builder(
            padding: pagePadding,
            gridDelegate: SliverSimpleGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 300),
            itemCount: supplyItemProvider.medicationItems.length + supplyItemProvider.genericItems.length,
            itemBuilder: (context, index) {
              if (index < supplyItemProvider.medicationItems.length) {
                MedicationSupply item = supplyItemProvider.medicationItems[index];
                return MedicationSupplyCard(item: item);
              }
              else {
                List<GenericSupply> genericSupplies = supplyItemProvider.genericItems;
                GenericSupply item = genericSupplies[index - supplyItemProvider.medicationItems.length];
                return GenericSupplyCard(item: item);
              }
            },
          ),
        );
      },
    );
  }
}
