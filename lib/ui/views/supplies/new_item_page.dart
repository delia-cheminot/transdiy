import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mona/data/model/supply_item.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
import 'package:mona/ui/widgets/forms/form_text_field.dart';
import 'package:mona/ui/widgets/forms/model_form.dart';
import 'package:provider/provider.dart';

class NewItemPage extends StatefulWidget {
  @override
  State<NewItemPage> createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  late TextEditingController _totalDoseController;
  late TextEditingController _nameController;
  late TextEditingController _concentrationController;

  String? get _nameError => SupplyItem.validateName(_nameController.text);
  String? get _totalDoseError =>
      SupplyItem.validateTotalAmount(_totalDoseController.text);
  String? get _concentrationError =>
      SupplyItem.validateConcentration(_concentrationController.text);

  bool get _isFormValid =>
      _nameError == null &&
      _totalDoseError == null &&
      _concentrationError == null;

  @override
  void initState() {
    super.initState();
    _totalDoseController = TextEditingController();
    _nameController = TextEditingController();
    _concentrationController = TextEditingController();
  }

  @override
  void dispose() {
    _totalDoseController.dispose();
    _nameController.dispose();
    _concentrationController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  void _addItem() async {
    final totalDose =
        Decimal.parse(_totalDoseController.text.replaceAll(',', '.'));
    final concentration =
        Decimal.parse(_concentrationController.text.replaceAll(',', '.'));
    final name = _nameController.text;
    final supplyItemProvider =
        Provider.of<SupplyItemProvider>(context, listen: false);
    supplyItemProvider.addItem(totalDose, name, concentration);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ModelForm(
      title: 'New item',
      submitButtonLabel: 'Add',
      isFormValid: _isFormValid,
      saveChanges: _addItem,
      fields: [
        FormTextField(
          controller: _nameController,
          label: 'Name',
          onChanged: _refresh,
          inputType: TextInputType.text,
        ),
        FormTextField(
          controller: _totalDoseController,
          label: 'Total amount',
          onChanged: _refresh,
          inputType: TextInputType.number,
          suffixText: 'mg',
          regexFormatter: r'[0-9.,]',
        ),
        FormTextField(
          controller: _concentrationController,
          label: 'Concentration',
          onChanged: _refresh,
          inputType: TextInputType.number,
          suffixText: 'mg/ml',
          regexFormatter: r'[0-9]',
        ),
      ],
    );
  }
}
