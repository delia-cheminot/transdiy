import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/providers/supplies_state.dart';

class NewItemDialog extends StatefulWidget {
  @override
  State<NewItemDialog> createState() => _NewItemDialogState();
}

class _NewItemDialogState extends State<NewItemDialog> {
  late TextEditingController _volumeController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _volumeController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _volumeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  double? _parseDouble(String text) {
    final sanitizedText = text.replaceAll(',', '.');
    return double.tryParse(sanitizedText);
  }

  void _addItem() async {
    final volume = double.parse(_volumeController.text.replaceAll(',', '.'));
    final name = _nameController.text;
    final suppliesState = Provider.of<SuppliesState>(context, listen: false);
    suppliesState.addItem(volume, name);
    Navigator.pop(context);
  }

  bool _validateInputs() {
    if (!_isNameValid()) {
      setState(() {});
      return false;
    }

    if (!_isVolumeValid()) {
      setState(() {});
      return false;
    }

    setState(() {});
    return true;
  }

  bool _isVolumeValid() {
    return _parseDouble(_volumeController.text) != null;
  }

  bool _isNameValid() {
    return _nameController.text.isNotEmpty;
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
              onPressed: _validateInputs() ? _addItem : null,
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
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom',
                ),
                onChanged: (value) => _validateInputs(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
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
                onChanged: (value) => _validateInputs(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
