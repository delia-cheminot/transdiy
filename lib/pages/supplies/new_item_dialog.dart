import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/supply_item/supply_item_state.dart';

class NewItemDialog extends StatefulWidget {
  @override
  State<NewItemDialog> createState() => _NewItemDialogState();
}

class _NewItemDialogState extends State<NewItemDialog> {
  late TextEditingController _totalAmountController;
  late TextEditingController _nameController;
  late TextEditingController _dosePerUnitController;

  @override
  void initState() {
    super.initState();
    _totalAmountController = TextEditingController();
    _nameController = TextEditingController();
    _dosePerUnitController = TextEditingController();
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _nameController.dispose();
    _dosePerUnitController.dispose();
    super.dispose();
  }

  double? _parseDouble(String text) {
    final sanitizedText = text.replaceAll(',', '.');
    return double.tryParse(sanitizedText);
  }

  void _addItem() async {
    final totalAmount = double.parse(_totalAmountController.text.replaceAll(',', '.'));
    final dosePerUnit = double.parse(_dosePerUnitController.text.replaceAll(',', '.'));
    final name = _nameController.text;
    final supplyItemState = Provider.of<SupplyItemState>(context, listen: false);
    supplyItemState.addItem(totalAmount, name, dosePerUnit);
    Navigator.pop(context);
  }

  bool _validateInputs() {
    if (!_isNameValid()) {
      setState(() {});
      return false;
    }

    if (!_isTotalAmountValid()) {
      setState(() {});
      return false;
    }

    if (!_isDosePerUnitValid()) {
      setState(() {});
      return false;
    }

    setState(() {});
    return true;
  }

  bool _isTotalAmountValid() {
    return _parseDouble(_totalAmountController.text) != null;
  }

  bool _isNameValid() {
    return _nameController.text.isNotEmpty;
  }

  bool _isDosePerUnitValid() {
    return _parseDouble(_dosePerUnitController.text) != null;
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
                controller: _totalAmountController,
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
                controller: _dosePerUnitController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Concentration',
                  suffixText: 'mg/ml',
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
