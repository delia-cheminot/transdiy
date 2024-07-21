import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/providers/supplies_state.dart';

class NewItemDialog extends StatefulWidget {
  @override
  _NewItemDialogState createState() => _NewItemDialogState();
}

class _NewItemDialogState extends State<NewItemDialog> {
  late TextEditingController _volumeController;

  @override
  void initState() {
    super.initState();
    _volumeController = TextEditingController();
  }

  @override
  void dispose() {
    _volumeController.dispose();
    super.dispose();
  }

  void _addItem() async {
    // check if text controller is empty
    if (_volumeController.text.isEmpty) return;
    // check if text controller is not empty
    final volume = double.parse(_volumeController.text.replaceAll(',', '.'));
    final suppliesState = Provider.of<SuppliesState>(context, listen: false);
    suppliesState.addItem(volume);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvel élément'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: _addItem,
              child: Text(
                'Ajouter',
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _volumeController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contenance',
                suffixText: 'ml',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
