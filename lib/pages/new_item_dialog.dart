import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transdiy/data/supply_item_model.dart';

class NewItemDialog extends StatefulWidget {
  final Function() onItemAdded;

  NewItemDialog({required this.onItemAdded});

  @override
  _NewItemDialogState createState() => _NewItemDialogState();
}

class _NewItemDialogState extends State<NewItemDialog> {
  String? _volume;

  Future<void> _addItem() async {
    if (_volume != null && _volume!.isNotEmpty) {
      final formattedVolume = _volume!.replaceAll(',', '.');
      SupplyItem newItem = SupplyItem(volume: double.parse(formattedVolume));
      await SupplyItem.insertItem(newItem);
      widget.onItemAdded();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nouvel élément'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            onChanged: (value) {
              setState(() {
                _volume = value;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Volume',
              hintText: 'Mililitres',
            ),
          ),
          MaterialButton(
            color: Theme.of(context).colorScheme.primary,
            child: Text(
              'Ajouter',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            onPressed: _addItem,
          ),
        ],
      ),
    );
  }
}
