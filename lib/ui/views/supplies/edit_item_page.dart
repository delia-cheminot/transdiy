import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/controllers/supply_item_manager.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/data/providers/supply_item_provider.dart';
import 'package:transdiy/ui/widgets/dialogs.dart';
import 'package:transdiy/widgets/form_text_field.dart';

class EditItemPage extends StatefulWidget {
  final SupplyItem item;

  EditItemPage({required this.item});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController _totalDosesController;
  late TextEditingController _usedDoseController;
  late TextEditingController _dosePerUnitController;
  late TextEditingController _nameController;

  String? get _nameError => SupplyItem.validateName(_nameController.text);
  String? get _totalAmountError =>
      SupplyItem.validateTotalAmount(_totalDosesController.text);
  String? get _usedAmountError => SupplyItem.validateUsedAmount(
        _usedDoseController.text,
        _totalDosesController.text,
      );
  String? get _dosePerUnitError =>
      SupplyItem.validateDosePerUnit(_dosePerUnitController.text);

  bool get _isFormValid =>
      _nameError == null &&
      _totalAmountError == null &&
      _usedAmountError == null &&
      _dosePerUnitError == null;

  @override
  void initState() {
    super.initState();
    _totalDosesController =
        TextEditingController(text: widget.item.totalDose.toString());
    _usedDoseController =
        TextEditingController(text: widget.item.usedDose.toString());
    _dosePerUnitController =
        TextEditingController(text: widget.item.dosePerUnit.toString());
    _nameController = TextEditingController(text: widget.item.name);
  }

  @override
  void dispose() {
    _totalDosesController.dispose();
    _usedDoseController.dispose();
    _dosePerUnitController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  void _saveChanges() {
    Decimal? parseDecimal(String text) {
      final sanitizedText = text.replaceAll(',', '.');
      return Decimal.tryParse(sanitizedText);
    }

    if (!_isFormValid) return;
    if (!mounted) return;
    final supplyItemProvider =
        Provider.of<SupplyItemProvider>(context, listen: false);
    SupplyItemManager(supplyItemProvider).setFields(
      widget.item,
      newName: _nameController.text,
      newTotalDose: parseDecimal(_totalDosesController.text)!,
      newUsedDose: parseDecimal(_usedDoseController.text)!,
      newDosePerUnit: parseDecimal(_dosePerUnitController.text)!,
    );
    Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await Dialogs.confirmDelete(context);

    if (confirmed == true) {
      if (!mounted) return;
      final supplyItemProvider =
          Provider.of<SupplyItemProvider>(context, listen: false);
      supplyItemProvider.deleteItem(widget.item);
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
                  errorText: _nameError,
                ),
                FormTextField(
                  controller: _totalDosesController,
                  label: 'Dose totale',
                  onChanged: _refresh,
                  inputType: TextInputType.number,
                  suffixText: 'mg',
                  errorText: _totalAmountError,
                  regexFormatter: r'[0-9.,]',
                ),
                FormTextField(
                  controller: _usedDoseController,
                  label: 'Dose utilisée',
                  onChanged: _refresh,
                  inputType: TextInputType.number,
                  suffixText: 'mg',
                  errorText: _usedAmountError,
                  regexFormatter: r'[0-9.,]',
                ),
                FormTextField(
                  controller: _dosePerUnitController,
                  label: 'Dosage par unité',
                  onChanged: _refresh,
                  inputType: TextInputType.number,
                  suffixText: 'mg/ml',
                  errorText: _dosePerUnitError,
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
      ),
    );
  }
}
