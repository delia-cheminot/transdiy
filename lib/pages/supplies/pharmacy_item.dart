import 'package:flutter/material.dart';
import 'package:transdiy/data/supply_item_model.dart';
import 'package:transdiy/pages/supplies/edit_item_dialog.dart';

class PharmacyItem extends StatelessWidget {
  final SupplyItem item;

  PharmacyItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Fiole d\'œstrogène (id ${item.id.toString()})'),
      subtitle: Text(
        'Volume: ${item.volume.toString()} (${(item.volume - item.usedVolume).toString()} restant)',
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (context) => EditItemDialog(item: item),
        ));
      },
    );
  }
}
