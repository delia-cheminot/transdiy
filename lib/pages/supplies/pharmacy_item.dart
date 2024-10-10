import 'package:flutter/material.dart';
import 'package:transdiy/pages/supplies/edit_item_dialog.dart';
import 'package:transdiy/models/supply_item/supply_item.dart';

class PharmacyItem extends StatelessWidget {
  final SupplyItem item;

  PharmacyItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text(
          'Contenance: ${item.totalAmount.toString()} (${(item.getRemainingAmount()).toString()} restant)'),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (context) => EditItemDialog(item: item),
        ));
      },
    );
  }
}
