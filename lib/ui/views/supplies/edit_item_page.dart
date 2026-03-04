import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mona/controllers/supply_item_manager.dart';
import 'package:mona/data/model/supply_item.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
import 'package:mona/ui/widgets/dialogs.dart';
import 'package:mona/ui/widgets/forms/form_text_field.dart';
import 'package:mona/ui/widgets/forms/model_form.dart';
import 'package:provider/provider.dart';

class EditItemPage extends StatefulWidget {
  final SupplyItem item;

  EditItemPage({required this.item});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController _totalDoseController;
  late TextEditingController _usedDoseController;
  late TextEditingController _concentrationController;
  late TextEditingController _nameController;
  late SupplyItemProvider _supplyItemProvider;

  String? get _nameError => SupplyItem.validateName(_nameController.text);

  String? get _totalDoseError =>
      SupplyItem.validateTotalAmount(_totalDoseController.text);

  String? get _usedDoseError {
    final validator = SupplyItem.usedAmountValidator(_totalDoseController.text);
    return validator(_usedDoseController.text);
  }

  String? get _concentrationError =>
      SupplyItem.validateConcentration(_concentrationController.text);

  bool get _isFormValid =>
      _nameError == null &&
      _totalDoseError == null &&
      _usedDoseError == null &&
      _concentrationError == null;

  void _refresh() => setState(() {});

  void _saveChanges() {
    Decimal? parseDecimal(String text) {
      final sanitizedText = text.replaceAll(',', '.');
      return Decimal.tryParse(sanitizedText);
    }

    if (!_isFormValid) return;
    if (!mounted) return;

    SupplyItemManager(_supplyItemProvider).setFields(
      widget.item,
      newName: _nameController.text,
      newTotalDose: parseDecimal(_totalDoseController.text)!,
      newUsedDose: parseDecimal(_usedDoseController.text)!,
      newConcentration: parseDecimal(_concentrationController.text)!,
    );

    Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await Dialogs.confirmDelete(context);

    if (confirmed == true) {
      if (!mounted) return;
      _supplyItemProvider.deleteItem(widget.item);
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _totalDoseController =
        TextEditingController(text: widget.item.totalDose.toString());
    _usedDoseController =
        TextEditingController(text: widget.item.usedDose.toString());
    _concentrationController =
        TextEditingController(text: widget.item.concentration.toString());
    _nameController = TextEditingController(text: widget.item.name);
    _supplyItemProvider =
        Provider.of<SupplyItemProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _totalDoseController.dispose();
    _usedDoseController.dispose();
    _concentrationController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModelForm(
      title: 'Edit item',
      submitButtonLabel: 'Save',
      isFormValid: _isFormValid,
      saveChanges: _saveChanges,
      onDelete: _confirmDelete,
      fields: [
        FormTextField(
          controller: _nameController,
          label: 'Name',
          onChanged: _refresh,
          inputType: TextInputType.text,
          errorText: _nameError,
        ),
        FormTextField(
          controller: _totalDoseController,
          label: 'Total amount',
          onChanged: _refresh,
          inputType: TextInputType.number,
          suffixText: 'mg',
          errorText: _totalDoseError,
          regexFormatter: r'[0-9.,]',
        ),
        FormTextField(
          controller: _usedDoseController,
          label: 'Used amount',
          onChanged: _refresh,
          inputType: TextInputType.number,
          suffixText: 'mg',
          errorText: _usedDoseError,
          regexFormatter: r'[0-9.,]',
        ),
        FormTextField(
          controller: _concentrationController,
          label: 'Concentration',
          onChanged: _refresh,
          inputType: TextInputType.number,
          suffixText: 'mg/ml',
          errorText: _concentrationError,
          regexFormatter: r'[0-9]',
        ),
      ],
    );
  }
}
