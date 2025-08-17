import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/controllers/supply_item_manager.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/data/providers/supply_item_provider.dart';
import 'package:transdiy/ui/widgets/dialogs.dart';
import 'package:transdiy/widgets/form_text_field.dart';

class EditItemDialog extends StatefulWidget {
  final SupplyItem item;

  EditItemDialog({required this.item});

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late TextEditingController _totalAmountController;
  late TextEditingController _usedAmountController;
  late TextEditingController _dosePerUnitController;
  late TextEditingController _nameController;

  bool _isFormValid = false;

  Map<String, String?> _fieldErrors = {
    'name': null,
    'totalAmount': null,
    'usedAmount': null,
    'dosePerUnit': null,
  };

  @override
  void initState() {
    super.initState();
    _totalAmountController =
        TextEditingController(text: widget.item.totalDose.toString());
    _usedAmountController =
        TextEditingController(text: widget.item.usedDose.toString());
    _dosePerUnitController =
        TextEditingController(text: widget.item.dosePerUnit.toString());
    _nameController = TextEditingController(text: widget.item.name);
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _usedAmountController.dispose();
    _dosePerUnitController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _fieldErrors['name'] = SupplyItem.validateName(_nameController.text);
      _fieldErrors['totalAmount'] =
          SupplyItem.validateTotalAmount(_totalAmountController.text);
      _fieldErrors['usedAmount'] = SupplyItem.validateUsedAmount(
        _usedAmountController.text,
        _totalAmountController.text,
      );
      _fieldErrors['dosePerUnit'] =
          SupplyItem.validateDosePerUnit(_dosePerUnitController.text);

      _isFormValid = _fieldErrors.values.every((error) => error == null);
    });
  }

  void _saveChanges() {
    Decimal? parseDecimal(String text) {
      final sanitizedText = text.replaceAll(',', '.');
      return Decimal.tryParse(sanitizedText);
    }

    if (!_isFormValid) return;
    final supplyItemState =
        Provider.of<SupplyItemProvider>(context, listen: false);
    SupplyItemManager(supplyItemState).setFields(
      widget.item,
      newName: _nameController.text,
      newTotalDose: parseDecimal(_totalAmountController.text)!,
      newUsedDose: parseDecimal(_usedAmountController.text)!,
      newDosePerUnit: parseDecimal(_dosePerUnitController.text)!,
    );
    Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await Dialogs.confirmDelete(context);

    if (confirmed == true) {
      if (!mounted) return;
      final supplyItemState =
          Provider.of<SupplyItemProvider>(context, listen: false);
      supplyItemState.deleteItem(widget.item);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier'),
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
              onPressed: _isFormValid ? _saveChanges : null,
              child: Text('Sauvegarder'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                errorText: _fieldErrors['name'],
              ),
              FormTextField(
                controller: _totalAmountController,
                label: 'Quantité totale',
                validator: _validateInputs,
                inputType: TextInputType.number,
                suffixText: 'ml',
                errorText: _fieldErrors['totalAmount'],
                regexFormatter: r'[0-9.,]',
              ),
              FormTextField(
                controller: _usedAmountController,
                label: 'Quantité utilisée',
                validator: _validateInputs,
                inputType: TextInputType.number,
                suffixText: 'ml',
                errorText: _fieldErrors['usedAmount'],
                regexFormatter: r'[0-9.,]',
              ),
              FormTextField(
                controller: _dosePerUnitController,
                label: 'Dosage par unité',
                validator: _validateInputs,
                inputType: TextInputType.number,
                suffixText: 'mg/ml',
                errorText: _fieldErrors['dosePerUnit'],
                regexFormatter: r'[0-9]',
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Divider(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _confirmDelete,
                  child: Text('Supprimer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
