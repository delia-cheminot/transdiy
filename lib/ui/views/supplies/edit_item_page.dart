import 'package:flutter/material.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/medication_supply_item.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/data/model/supply_item.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
import 'package:mona/l10n/build_context_extensions.dart';
import 'package:mona/l10n/helpers/administration_route_l10n.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:mona/ui/widgets/dialogs.dart';
import 'package:mona/ui/widgets/dropdowns/administration_route_dropdown.dart';
import 'package:mona/ui/widgets/dropdowns/ester_dropdown.dart';
import 'package:mona/ui/widgets/dropdowns/molecule_dropdown.dart';
import 'package:mona/ui/widgets/forms/form_dropdown_field.dart';
import 'package:mona/ui/widgets/forms/form_spacer.dart';
import 'package:mona/ui/widgets/forms/form_text_field.dart';
import 'package:mona/ui/widgets/forms/model_form.dart';
import 'package:mona/util/string_parsing.dart';
import 'package:provider/provider.dart';

class EditItemPage extends StatefulWidget {
  final MedicationSupplyItem item;

  EditItemPage({required this.item});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController _totalAmountController;
  late TextEditingController _usedAmountController;
  late TextEditingController _concentrationController;
  late TextEditingController _nameController;
  late Molecule _molecule;
  late AdministrationRoute _administrationRoute;
  late Ester? _ester;
  late PreferencesService _preferencesService;
  late SupplyItemProvider _supplyItemProvider;

  String? get _nameError =>
      SupplyItem.validateName(context.l10n, _nameController.text);

  String? get _totalAmountError => MedicationSupplyItem.validateTotalAmount(
      context.l10n, _totalAmountController.text);

  String? get _usedAmountError {
    final validator = MedicationSupplyItem.usedAmountValidator(
        context.l10n, _totalAmountController.text);
    return validator(_usedAmountController.text);
  }

  String? get _concentrationError => MedicationSupplyItem.validateConcentration(
      context.l10n, _concentrationController.text);

  String? get _moleculeError =>
      MedicationSupplyItem.validateMolecule(context.l10n, _molecule);
  String? get _administrationRouteError =>
      MedicationSupplyItem.validateAdministrationRoute(
          context.l10n, _administrationRoute);
  String? get _esterError {
    final validator = MedicationSupplyItem.esterValidator(
        context.l10n, _molecule, _administrationRoute);
    return validator(_ester);
  }

  bool get _isFormValid =>
      _nameError == null &&
      _totalAmountError == null &&
      _usedAmountError == null &&
      _concentrationError == null &&
      _moleculeError == null &&
      _administrationRouteError == null &&
      _esterError == null;

  bool get _useEsterField =>
      _molecule == KnownMolecules.estradiol &&
      _administrationRoute == AdministrationRoute.injection;

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

  void _saveChanges() {
    if (!_isFormValid) return;
    if (!mounted) return;

    final concentration = _concentrationController.text.toDecimal;
    final totalDose = concentration * _totalAmountController.text.toDecimal;
    final usedDose = concentration * _usedAmountController.text.toDecimal;

    final updatedItem = widget.item.copyWith(
      name: _nameController.text,
      totalDose: totalDose,
      concentration: concentration,
      usedDose: usedDose,
      molecule: _molecule,
      administrationRoute: _administrationRoute,
      ester: _ester,
      clearEster: !_useEsterField,
    );
    _supplyItemProvider.updateItem(updatedItem);

    Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final localizations = context.l10n;
    final confirmed = await Dialogs.confirmDeleteDialog(
      context: context,
      title: localizations.deleteItem(widget.item.name),
    );

    if (confirmed == true) {
      if (!mounted) return;
      _supplyItemProvider.deleteItem(widget.item);
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    final totalAmountText =
        widget.item.getAmount(widget.item.totalDose).toString();
    final usedAmountText =
        widget.item.getAmount(widget.item.usedDose).toString();
    _totalAmountController = TextEditingController(text: totalAmountText);
    _usedAmountController = TextEditingController(text: usedAmountText);
    _concentrationController =
        TextEditingController(text: widget.item.concentration.toString());
    _nameController = TextEditingController(text: widget.item.name);
    _molecule = widget.item.molecule;
    _administrationRoute = widget.item.administrationRoute;
    _ester = widget.item.ester;
    _supplyItemProvider =
        Provider.of<SupplyItemProvider>(context, listen: false);
    _preferencesService =
        Provider.of<PreferencesService>(context, listen: false);
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _usedAmountController.dispose();
    _concentrationController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return ModelForm(
      title: localizations.editItem,
      avatar: widget.item.administrationRoute.icon,
      submitButtonLabel: localizations.save,
      isFormValid: _isFormValid,
      saveChanges: _saveChanges,
      onDelete: _confirmDelete,
      fields: [
        FormTextField(
          controller: _nameController,
          label: localizations.name,
          onChanged: _refresh,
          inputType: TextInputType.text,
          errorText: _nameError,
        ),
        FormSpacer(),
        FormDropdownField<Molecule>(
          value: _molecule,
          items: moleculeDropdownMenuItems(
            _preferencesService.allMolecules,
            localizations,
          ),
          onChanged: _onMoleculeChanged,
          label: localizations.molecule,
        ),
        FormDropdownField<AdministrationRoute>(
          value: _administrationRoute,
          items: administrationRouteDropdownMenuItems(localizations),
          onChanged: _onAdministrationRouteChanged,
          label: localizations.adminRoute,
        ),
        if (_useEsterField)
          FormDropdownField<Ester>(
            value: _ester,
            items: esterDropdownMenuItems(localizations),
            onChanged: _onEsterChanged,
            label: localizations.ester,
          ),
        FormSpacer(),
        FormTextField(
          controller: _totalAmountController,
          label: localizations.totalAmount,
          onChanged: _refresh,
          inputType: TextInputType.numberWithOptions(decimal: true),
          suffixText: _administrationRoute.localizedUnit(localizations, 1),
          errorText: _totalAmountError,
          regexFormatter: r'[0-9.,]',
        ),
        FormTextField(
          controller: _usedAmountController,
          label: localizations.usedAmount,
          onChanged: _refresh,
          inputType: TextInputType.numberWithOptions(decimal: true),
          suffixText: _administrationRoute.localizedUnit(localizations, 1),
          errorText: _usedAmountError,
          regexFormatter: r'[0-9.,]',
        ),
        FormTextField(
          controller: _concentrationController,
          label: localizations.concentration,
          onChanged: _refresh,
          inputType: TextInputType.numberWithOptions(decimal: true),
          suffixText:
              '${_molecule.unit}/${_administrationRoute.localizedUnit(localizations, 1)}',
          errorText: _concentrationError,
          regexFormatter: r'[0-9.,]',
        ),
      ],
    );
  }
}
