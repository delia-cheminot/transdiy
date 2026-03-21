import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/generic_supply.dart';
import 'package:mona/data/model/medication_supply.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/data/model/supply_item.dart';
import 'package:mona/data/model/supply_type.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:mona/ui/widgets/dialogs.dart';
import 'package:mona/ui/widgets/forms/form_dropdown_field.dart';
import 'package:mona/ui/widgets/forms/form_spacer.dart';
import 'package:mona/ui/widgets/forms/form_text_field.dart';
import 'package:mona/ui/widgets/forms/model_form.dart';
import 'package:mona/util/string_parsing.dart';
import 'package:provider/provider.dart';

class SupplyItemFormPage extends StatefulWidget {
  // null when creating, non null when editing
  final SupplyItem? item;

  SupplyItemFormPage(this.item);

  @override
  State createState() {
    return _SupplyItemFormPageState();
  }
}

class _SupplyItemFormPageState extends State<SupplyItemFormPage> {

  late TextEditingController _totalAmountController;
  late TextEditingController _usedAmountController;
  late TextEditingController _concentrationController;
  late TextEditingController _nameController;
  SupplyType? _type;
  Molecule? _molecule;
  AdministrationRoute? _administrationRoute;
  Ester? _ester;
  late PreferencesService _preferencesService;
  late SupplyItemProvider _supplyItemProvider;

  String? get _nameError => MedicationSupply.validateName(_nameController.text);

  String? get _totalAmountError =>
      MedicationSupply.validateTotalAmount(_totalAmountController.text);

  String? get _usedAmountError {
    final validator =
    MedicationSupply.usedAmountValidator(_totalAmountController.text);
    return validator(_usedAmountController.text);
  }

  String? get _concentrationError =>
      MedicationSupply.validateConcentration(_concentrationController.text);

  String? get _moleculeError => MedicationSupply.validateMolecule(_molecule);
  String? get _administrationRouteError =>
      MedicationSupply.validateAdministrationRoute(_administrationRoute);
  String? get _esterError {
    final validator =
    MedicationSupply.esterValidator(_molecule, _administrationRoute);
    return validator(_ester);
  }

  bool get _isFormValid {
    if (_type==SupplyType.medication) {
      return _nameError == null &&
          _totalAmountError == null &&
          (widget.item==null || _usedAmountError == null) &&
          _concentrationError == null &&
          _moleculeError == null &&
          _administrationRouteError == null &&
          _esterError == null;
    } else {
      return _nameError == null &&
          _totalAmountError == null;
    }
  }


  bool get _useEsterField =>
      _molecule == KnownMolecules.estradiol &&
          _administrationRoute == AdministrationRoute.injection;


  List<Widget> get _fields => [
    Visibility(
      visible: widget.item==null,
      child:
        FormDropdownField<SupplyType>(
          value: _type,
          items: SupplyType.values.map((type)=>DropdownMenuItem<SupplyType>(value: type, child: Text(type.name))).toList(),
          onChanged: (value)=>{
            setState(() {
              _type=value;
            })
          },
          label: 'Supply type',
          required: true
        ),
    ),
    FormTextField(
      controller: _nameController,
      label: 'Name',
      onChanged: _refresh,
      inputType: TextInputType.text,
      errorText: _nameError,
    ),
    if(_type==SupplyType.medication) ...[
      FormSpacer(),
      FormDropdownField<Molecule>(
        value: _molecule,
        items: _preferencesService.moleculeDropdownItems,
        onChanged: _onMoleculeChanged,
        label: 'Molecule',
        required: true,
      ),
      FormDropdownField<AdministrationRoute>(
        value: _administrationRoute,
        items: AdministrationRoute.menuItems,
        onChanged: _onAdministrationRouteChanged,
        label: 'Administration route',
        required: true,
      ),
      Visibility(
          visible: _useEsterField,
          child: FormDropdownField<Ester>(
            value: _ester,
            items: Ester.menuItems,
            onChanged: _onEsterChanged,
            label: 'Ester',
            required: true,
          )
      ),
      FormSpacer(),
    ],
    FormTextField(
      controller: _totalAmountController,
      label: 'Total amount',
      onChanged: _refresh,
      inputType: TextInputType.numberWithOptions(decimal: true),
      suffixText: _administrationRoute?.unit,
      errorText: _totalAmountError,
      regexFormatter: r'[0-9.,]',
    ),
    if(_type==SupplyType.medication) ...[
      Visibility(
          visible: widget.item != null,
          child: FormTextField(
            controller: _usedAmountController,
            label: 'Used amount',
            onChanged: _refresh,
            inputType: TextInputType.numberWithOptions(decimal: true),
            suffixText: _administrationRoute?.unit,
            errorText: _usedAmountError,
            regexFormatter: r'[0-9.,]',
          )
      ),
      FormTextField(
        controller: _concentrationController,
        label: 'Concentration',
        onChanged: _refresh,
        inputType: TextInputType.numberWithOptions(decimal: true),
        suffixText: _suffixText(),
        errorText: _concentrationError,
        regexFormatter: r'[0-9.,]',
      )
    ],
  ];

  String _suffixText() {
    var moleculeUnit = _molecule?.unit;
    var administrationUnit = _administrationRoute?.unit;
    if (moleculeUnit != null && administrationUnit != null) {
      return '$moleculeUnit/$administrationUnit';
    }
    else {
      return '';
    }
  }

  void _onMoleculeChanged(Molecule? molecule) {
    if (molecule != null) {
      setState(() {
        _molecule = molecule;

        if (!_useEsterField) {
          _ester = null;
        }
      });
    }
  }

  void _onAdministrationRouteChanged(AdministrationRoute? administrationRoute) {
    if (administrationRoute != null) {
      setState(() {
        _administrationRoute = administrationRoute;

        if (!_useEsterField) {
          _ester = null;
        }
      });
    }
  }

  void _onEsterChanged(Ester? ester) {
    if (ester != null) {
      setState(() {
        _ester = ester;
      });
    }
  }

  void _refresh() => setState(() {});

  Future<void> _confirmDelete() async {
    if (widget.item == null) {
      return;
    }

    final confirmed = await Dialogs.confirmDeleteDialog(
        context: context, title: "Delete this item?");

    if (confirmed == true) {
      if (!mounted) return;
      _supplyItemProvider.deleteItem(widget.item!);
      Navigator.of(context).pop();
    }
  }

  void _save() {
    if (widget.item != null) {
      _editItem();
    }
    else{
      _addItem();
    }
  }

  void _addItem() async {
    if (!_isFormValid || !mounted) return;

    final totalAmount = int.parse(_totalAmountController.text);
    final name = _nameController.text;
    SupplyItem item;
    if (_type==SupplyType.medication) {
      final concentration = _concentrationController.text.toDecimal;
      final totalDose = concentration * Decimal.fromInt(totalAmount);

      item = MedicationSupply(
        name: name,
        totalDose: totalDose,
        concentration: concentration,
        molecule: _molecule!,
        administrationRoute: _administrationRoute!,
        ester: _ester,
      );
    }
    else {
      item = GenericSupply(
          name: name,
          quantity: totalAmount
      );
    }

    final medicationSupplyProvider = Provider.of<SupplyItemProvider>(context, listen: false);
    medicationSupplyProvider.add(item);

    Navigator.pop(context);
  }

  void _editItem() {
    var item = widget.item;
    if (!_isFormValid || !mounted || item == null) {
      return;
    }

    SupplyItem updatedItem;
    if (_type==SupplyType.medication) {
      final concentration = _concentrationController.text.toDecimal;
      final totalDose = concentration * _totalAmountController.text.toDecimal;
      final usedDose = concentration * _usedAmountController.text.toDecimal;

      updatedItem = (item as MedicationSupply).copyWith(
        name: _nameController.text,
        totalDose: totalDose,
        concentration: concentration,
        usedDose: usedDose,
        molecule: _molecule,
        administrationRoute: _administrationRoute,
        ester: _ester,
        clearEster: !_useEsterField,
      );
    }
    else {
      updatedItem = (item as GenericSupply).copyWith(
        name: _nameController.text,
        quantity: int.parse(_totalAmountController.text)
      );
    }

    _supplyItemProvider.updateItem(updatedItem);

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    _type = widget.item?.getType() ?? SupplyType.medication;

    _supplyItemProvider =
        Provider.of<SupplyItemProvider>(context, listen: false);
    _preferencesService =
        Provider.of<PreferencesService>(context, listen: false);


    var item = widget.item;
    if (item != null) {
      if (_type==SupplyType.medication){
        item = item as MedicationSupply;
        final totalAmountText =
        item.getAmount(item.totalDose).toString();
        _totalAmountController = TextEditingController(text: totalAmountText);
        final usedAmountText =
        item.getAmount(item.usedDose).toString();
        _usedAmountController = TextEditingController(text: usedAmountText);
        var concentrationText = item.concentration.toString();
        _concentrationController =
            TextEditingController(text: concentrationText);
        _nameController = TextEditingController(text: item.name);
        _molecule = item.molecule;
        _administrationRoute = item.administrationRoute;
        _ester = item.ester;
      }
      else {
        item = item as GenericSupply;
        _totalAmountController = TextEditingController(text: item.quantity.toString());
        _nameController = TextEditingController(text: item.name);
      }
    }
    else {
      _usedAmountController = TextEditingController();
      _concentrationController = TextEditingController();
      _nameController = TextEditingController();
      _totalAmountController = TextEditingController();
      _molecule = null;
      _administrationRoute = null;
      _ester = null;
    }
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _nameController.dispose();
    if (_type==SupplyType.medication) {
      _usedAmountController.dispose();
      _concentrationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return ModelForm(
        title: widget.item != null ? 'Edit supply' : 'Create supply',
        avatar: _formAvatar,
        submitButtonLabel: 'Save',
        isFormValid: _isFormValid,
        saveChanges: _save,
        onDelete: _confirmDelete,
        fields: _fields
      );
  }

  IconData? get _formAvatar {
    var item = widget.item;
    if (item == null) {
      return null;
    }

    if (_type == SupplyType.medication) {
      return (item as MedicationSupply).administrationRoute.icon;
    }
    else {
      return Icons.healing_outlined;
    }
  }
}