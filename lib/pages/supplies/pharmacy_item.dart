import 'package:flutter/material.dart';
import 'package:transdiy/data/supply_item_model.dart';

class PharmacyItem extends StatelessWidget {
  final SupplyItem item;
  final VoidCallback onDelete;

  PharmacyItem({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Item numéro ${item.id.toString()}'),
      subtitle: Text(
        'Volume: ${item.volume.toString()} (${item.usedVolume.toString()} utilisés)',
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
