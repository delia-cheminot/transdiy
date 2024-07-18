import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/providers/supplies_state.dart';

class NewItemDialog extends StatefulWidget {
  @override
  _NewItemDialogState createState() => _NewItemDialogState();
}

class _NewItemDialogState extends State<NewItemDialog> {
  String? _volume = null;

  void _addItem() async {
    if (_volume == null || _volume == '') return;
    final volume = double.parse(_volume!.replaceAll(',', '.'));
    final pharmacyState = Provider.of<SuppliesState>(context, listen: false);
    pharmacyState.addItem(volume);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nouvel élément'),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Ajouter',
          ),
          onPressed: _addItem,
        ),
      ],
    );
  }
}
