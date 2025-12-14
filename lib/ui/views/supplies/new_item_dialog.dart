import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/data/providers/supply_item_provider.dart';
import 'package:transdiy/widgets/form_text_field.dart';

class NewItemDialog extends StatefulWidget {
  @override
  State<NewItemDialog> createState() => _NewItemDialogState();
}

class _NewItemDialogState extends State<NewItemDialog> {
  late TextEditingController _totalAmountController;
  late TextEditingController _nameController;
  late TextEditingController _dosePerUnitController;

  bool _isFormValid = false;

  Map<String, String?> _fieldErrors = {
    'name': null,
    'totalAmount': null,
    'dosePerUnit': null,
  };

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

  /// Updates the error messages for each field and the form validity.
  void _validateInputs() {
    setState(() {
      _fieldErrors['name'] = SupplyItem.validateName(_nameController.text);
      _fieldErrors['totalAmount'] =
          SupplyItem.validateTotalAmount(_totalAmountController.text);
      _fieldErrors['dosePerUnit'] =
          SupplyItem.validateDosePerUnit(_dosePerUnitController.text);

      _isFormValid = _fieldErrors.values.every((error) => error == null);
    });
  }

  void _addItem() async {
    final totalAmount =
        Decimal.parse(_totalAmountController.text.replaceAll(',', '.'));
    final dosePerUnit =
        Decimal.parse(_dosePerUnitController.text.replaceAll(',', '.'));
    final name = _nameController.text;
    final supplyItemProvider =
        Provider.of<SupplyItemProvider>(context, listen: false);
    supplyItemProvider.addItem(totalAmount, name, dosePerUnit);
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
              onPressed: _isFormValid ? _addItem : null,
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
            FormTextField(
              controller: _nameController,
              label: 'Nom',
              validator: _validateInputs,
              inputType: TextInputType.text,
              isFirst: true,
            ),
            FormTextField(
              controller: _totalAmountController,
              label: 'Contenance',
              validator: _validateInputs,
              inputType: TextInputType.number,
              suffixText: 'ml',
              regexFormatter: r'[0-9.,]',
            ),
            FormTextField(
              controller: _dosePerUnitController,
              label: 'Concentration',
              validator: _validateInputs,
              inputType: TextInputType.number,
              suffixText: 'mg/ml',
              regexFormatter: r'[0-9]',
            ),
          ],
        ),
      ),
    );
  }
}
