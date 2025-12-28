import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/data/providers/supply_item_provider.dart';
import 'package:transdiy/widgets/form_text_field.dart';

class NewItemPage extends StatefulWidget {
  @override
  State<NewItemPage> createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  late TextEditingController _totalAmountController;
  late TextEditingController _nameController;
  late TextEditingController _dosePerUnitController;

  String? get _nameError => SupplyItem.validateName(_nameController.text);
  String? get _totalAmountError =>
      SupplyItem.validateTotalAmount(_totalAmountController.text);
  String? get _dosePerUnitError =>
      SupplyItem.validateDosePerUnit(_dosePerUnitController.text);

  bool get _isFormValid =>
      _nameError == null &&
      _totalAmountError == null &&
      _dosePerUnitError == null;

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

  void _refresh() {
    setState(() {});
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormTextField(
                  controller: _nameController,
                  label: 'Nom',
                  onChanged: _refresh,
                  inputType: TextInputType.text,
                ),
                FormTextField(
                  controller: _totalAmountController,
                  label: 'Contenance',
                  onChanged: _refresh,
                  inputType: TextInputType.number,
                  suffixText: 'ml',
                  regexFormatter: r'[0-9.,]',
                ),
                FormTextField(
                  controller: _dosePerUnitController,
                  label: 'Concentration',
                  onChanged: _refresh,
                  inputType: TextInputType.number,
                  suffixText: 'mg/ml',
                  regexFormatter: r'[0-9]',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
