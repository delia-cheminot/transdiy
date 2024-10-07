import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/services/dialog_service.dart';
import 'package:transdiy/supply_item/supply_item.dart';
import 'package:transdiy/supply_item/supply_item_manager.dart';
import 'package:transdiy/supply_item/supply_item_state.dart';

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
        TextEditingController(text: widget.item.totalAmount.toString());
    _usedAmountController =
        TextEditingController(text: widget.item.usedAmount.toString());
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
    double? parseDouble(String text) {
      final sanitizedText = text.replaceAll(',', '.');
      return double.tryParse(sanitizedText);
    }

    if (!_isFormValid) return;
    final supplyItemState = Provider.of<SupplyItemState>(context, listen: false);
    SupplyItemManager(supplyItemState).setFields(
      widget.item,
      newName: _nameController.text,
      newTotalAmount: parseDouble(_totalAmountController.text)!,
      newUsedAmount: parseDouble(_usedAmountController.text)!,
      newDosePerUnit: parseDouble(_dosePerUnitController.text)!,
    );
    Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await DialogService.confirmDelete(context);

    if (confirmed == true) {
      if (!mounted) return;
      final supplyItemState = Provider.of<SupplyItemState>(context, listen: false);
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
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nom',
                    errorText: _fieldErrors['name'],
                    suffixIcon:
                        _fieldErrors['name'] != null ? Icon(Icons.error) : null,
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
                    labelText: 'Quantité totale',
                    suffixText: 'ml',
                    errorText: _fieldErrors['totalAmount'],
                    suffixIcon:
                        _fieldErrors['totalAmount'] != null ? Icon(Icons.error) : null,
                  ),
                  onChanged: (value) => _validateInputs(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: TextField(
                  controller: _usedAmountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Quantité utilisée',
                    suffixText: 'ml',
                    errorText: _fieldErrors['usedAmount'],
                    suffixIcon: _fieldErrors['usedAmount'] != null
                        ? Icon(Icons.error)
                        : null,
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
                    labelText: 'Dosage par unité',
                    suffixText: 'mg/ml',
                    errorText: _fieldErrors['dosePerUnit'],
                    suffixIcon: _fieldErrors['dosePerUnit'] != null
                        ? Icon(Icons.error)
                        : null,
                  ),
                  onChanged: (value) => _validateInputs(),
                ),
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
