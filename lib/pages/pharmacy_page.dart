import 'package:flutter/material.dart';
import 'package:transdiy/data/supply_item_model.dart';

class PharmacyPage extends StatefulWidget {
  @override
  _PharmacyPageState createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  void _deleteItem(int id) async {
    await SupplyItem.deleteItem(id);
    setState(() {});
  }

  Widget _itemsList() {
    return FutureBuilder(
      future: SupplyItem.getItems(),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            SupplyItem item = snapshot.data![index];
            return ListTile(
              title: Text('Item numéro ${item.id.toString()}'),
              subtitle: Text(
                  'Volume: ${item.volume.toString()} (${item.usedVolume.toString()} utilisés)'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteItem(item.id!);
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _itemsList();
  }
}
