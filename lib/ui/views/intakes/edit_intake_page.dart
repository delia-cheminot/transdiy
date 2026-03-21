import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:mona/controllers/supply_item_manager.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/model/medication_supply.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
import 'package:mona/ui/views/intakes/intakes_page.dart';
import 'package:mona/ui/widgets/forms/form_datetime_field.dart';
import 'package:mona/ui/widgets/forms/form_dropdown_field.dart';
import 'package:mona/ui/widgets/forms/form_info_text.dart';
import 'package:mona/ui/widgets/forms/form_spacer.dart';
import 'package:mona/ui/widgets/forms/form_text_field.dart';
import 'package:mona/ui/widgets/forms/model_form.dart';
import 'package:mona/util/string_parsing.dart';
import 'package:provider/provider.dart';

class EditIntakePage extends StatefulWidget {
  final MedicationIntake intake;

  EditIntakePage(this.intake);

  @override
  State<EditIntakePage> createState() => _EditIntakePageState();
}

class _EditIntakePageState extends State<EditIntakePage> {
  late DateTime _takenDate;
  bool _takenDateChanged = false;
  late TextEditingController _takenDoseController;
  late Decimal _takenDose;
  InjectionSide? _selectedSide;
  bool _hasInitializedSide = false;
  MedicationSupply? _selectedSupplyItem;
  bool _hasInitializedSupplyItem = false;

  String? get _takenDoseError =>
      MedicationIntake.validateDose(_takenDoseController.text);

  bool get _isFormValid => _takenDoseError == null;

  bool get _isInjection =>
      widget.intake.administrationRoute == AdministrationRoute.injection;

  void _editIntake(
      MedicationIntakeProvider medicationIntakeProvider,
      SupplyItemProvider supplyItemProvider,
      MedicationIntake intake,
      MedicationSupply? medicationSupply) async {
    if (!_isFormValid) return;
    if (!mounted) return;

    // TODO create method in manager for this
    if (medicationSupply != null) {
      Decimal doseDifference = intake.dose - _takenDose;
      SupplyItemManager(supplyItemProvider)
          .useDose(medicationSupply, -doseDifference);
    }

    final timezone =
        _takenDateChanged ? await FlutterTimezone.getLocalTimezone() : null;

    MedicationIntake updatedIntake = intake.copyWith(
      takenDateTime: _takenDate.toUtc(),
      takenTimeZone: timezone?.identifier,
      dose: _takenDose,
      side: _selectedSide,
    );

    medicationIntakeProvider.updateIntake(updatedIntake);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _deleteIntake(
    MedicationIntakeProvider medicationIntakeProvider,
      SupplyItemProvider supplyItemProvider,
    MedicationIntake intake,
    MedicationSupply? medicationSupply,
  ) async {
    if (!mounted) return;

    // TODO create method in manager for this
    if (medicationSupply != null) {
      SupplyItemManager(supplyItemProvider).useDose(medicationSupply, -intake.dose);
    }

    medicationIntakeProvider.deleteIntake(intake);
    Navigator.of(context).pop();
  }

  void _onInjectionSideChanged(InjectionSide? side) {
    if (side != null) {
      setState(() {
        _selectedSide = side;
      });
    }
  }

  void _onTakenDateChanged(DateTime date) {
    setState(() {
      _takenDate = date;
      _takenDateChanged = true;
    });
  }

  void _onTakenDoseChanged() {
    final dose = _takenDoseController.text.toDecimalOrNull;

    if (dose != null) {
      setState(() {
        _takenDose = dose;
      });
    }
  }

  void _onMedicationSupplyChanged(MedicationSupply? item) {
    setState(() {
      _selectedSupplyItem = item;
    });
  }

  @override
  void initState() {
    super.initState();
    _takenDate = widget.intake.takenDateTime?.toLocal() ?? DateTime.now();
    _takenDose = widget.intake.dose;
    _takenDoseController =
        TextEditingController(text: widget.intake.dose.toString());
  }

  @override
  void dispose() {
    _takenDoseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MedicationIntakeProvider, SupplyItemProvider>(
      builder: (context, medicationIntakeProvider, supplyItemProvider, child) {
        final bool isLoading =
            medicationIntakeProvider.isLoading || supplyItemProvider.isLoading;

        if (!isLoading && !_hasInitializedSide && _isInjection) {
          _selectedSide = widget.intake.side;
          _hasInitializedSide = true;
        }

        if (!isLoading && !_hasInitializedSupplyItem) {
          _selectedSupplyItem = supplyItemProvider.getMostUsedItemForMedication(
            widget.intake.molecule,
            widget.intake.administrationRoute,
            widget.intake.ester,
          );
          _hasInitializedSupplyItem = true;
        }

        final medicationSupplyOptions = supplyItemProvider.getItemsForMedication(
          widget.intake.molecule,
          widget.intake.administrationRoute,
          widget.intake.ester,
        );

        final medicationSupplyDropdownItems = [
          const DropdownMenuItem<MedicationSupply?>(
            value: null,
            child: Text('None'),
          ),
          ...medicationSupplyOptions.map(
            (item) => DropdownMenuItem<MedicationSupply?>(
              value: item,
              child: Text(item.name),
            ),
          ),
        ];

        return ModelForm(
          title: 'Edit intake',
          avatar: widget.intake.administrationRoute.icon,
          submitButtonLabel: 'Save',
          isFormValid: _isFormValid,
          saveChanges: (!isLoading && _isFormValid)
              ? () => _editIntake(medicationIntakeProvider, supplyItemProvider,
                  widget.intake, _selectedSupplyItem)
              : () {},
          onDelete: () async {
            final confirmed = await IntakesPage.confirmDeleteIntake(context);
            if (confirmed == false) return;
            _deleteIntake(medicationIntakeProvider, supplyItemProvider,
                widget.intake, _selectedSupplyItem);
          },
          fields: [
            FormDateTimeField(
              label: 'Date',
              datetime: _takenDate,
              onChanged: _onTakenDateChanged,
            ),
            FormSpacer(),
            FormTextField(
              controller: _takenDoseController,
              label: 'Amount',
              onChanged: _onTakenDoseChanged,
              inputType: TextInputType.number,
              suffixText: widget.intake.molecule.unit,
              errorText: _takenDoseError,
              regexFormatter: r'[0-9.,]',
            ),
            if (_selectedSupplyItem != null)
              FormInfoText(
                infoText:
                    ' $_takenDose ${widget.intake.molecule.unit} = ${_selectedSupplyItem!.getAmount(_takenDose)} ${_selectedSupplyItem!.administrationRoute.unit}',
              ),
            FormSpacer(),
            FormDropdownField<MedicationSupply?>(
              value: _selectedSupplyItem,
              items: medicationSupplyDropdownItems,
              onChanged: _onMedicationSupplyChanged,
              label: 'Supply item',
              required: false,
            ),
            if (_isInjection)
              FormDropdownField<InjectionSide>(
                value: _selectedSide,
                items: InjectionSideDropdown.menuItems,
                onChanged: _onInjectionSideChanged,
                label: 'Injection side',
                required: false,
              ),
          ],
        );
      },
    );
  }
}
