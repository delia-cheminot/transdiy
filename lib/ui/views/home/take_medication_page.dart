import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mona/controllers/medication_intake_manager.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/model/supply_item.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
import 'package:mona/ui/widgets/forms/form_date_field.dart';
import 'package:mona/ui/widgets/forms/form_dropdown_field.dart';
import 'package:mona/ui/widgets/forms/form_spacer.dart';
import 'package:mona/ui/widgets/forms/form_text_field.dart';
import 'package:mona/ui/widgets/forms/model_form.dart';
import 'package:mona/util/validators.dart';
import 'package:provider/provider.dart';

class TakeMedicationPage extends StatefulWidget {
  final MedicationSchedule schedule;
  final DateTime scheduledDate;

  TakeMedicationPage(this.schedule, this.scheduledDate);

  @override
  State<TakeMedicationPage> createState() => _TakeMedicationPageState();
}

class _TakeMedicationPageState extends State<TakeMedicationPage> {
  late DateTime _takenDate;
  late TextEditingController _takenDoseController;
  late Decimal _takenDose;
  InjectionSide? _selectedSide;
  bool _hasInitializedSide = false;
  SupplyItem? _selectedSupplyItem;
  bool _hasInitializedSupplyItem = false;
  late TextEditingController _deadSpaceController;
  late Decimal _deadSpace;

  String? get _takenDoseError =>
      MedicationIntake.validateDose(_takenDoseController.text);

  String? get _deadSpaceError => positiveDecimal(_takenDoseController.text);

  bool get _isFormValid => _takenDoseError == null && _deadSpaceError == null;

  bool get _isInjection =>
      widget.schedule.administrationRoute == AdministrationRoute.injection;

  void _takeIntake(MedicationIntakeProvider medicationIntakeProvider,
      SupplyItemProvider supplyItemProvider) {
    if (!_isFormValid) return;
    if (!mounted) return;

    MedicationIntakeManager(medicationIntakeProvider, supplyItemProvider)
        .takeMedication(
      dose: _takenDose,
      scheduledDate: widget.scheduledDate,
      takenDate: _takenDate,
      supplyItem: _selectedSupplyItem,
      schedule: widget.schedule,
      side: _selectedSide,
      deadSpace: _deadSpace,
    );

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
    });
  }

  void _onTakenDoseChanged() {
    final dose = Decimal.tryParse(
      _takenDoseController.text.replaceAll(',', '.'),
    );
    if (dose != null) {
      setState(() {
        _takenDose = dose;
      });
    }
  }

// TODO implement tryParseDecimal
  void _onDeadSpaceChanged() {
    final deadSpace = Decimal.tryParse(
      _deadSpaceController.text.replaceAll(',', '.'),
    );
    if (deadSpace != null) {
      setState(() {
        _deadSpace = deadSpace;
      });
    }
  }

  void _onSupplyItemChanged(SupplyItem? item) {
    setState(() {
      _selectedSupplyItem = item;
    });
  }

  @override
  void initState() {
    super.initState();
    _takenDate = DateTime.now();
    _takenDose = widget.schedule.dose;
    _takenDoseController =
        TextEditingController(text: widget.schedule.dose.toString());
    _deadSpaceController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _takenDoseController.dispose();
    _deadSpaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MedicationIntakeProvider, SupplyItemProvider>(
      builder: (context, medicationIntakeProvider, supplyItemProvider, child) {
        final bool isLoading =
            medicationIntakeProvider.isLoading || supplyItemProvider.isLoading;

        if (!isLoading && !_hasInitializedSide && _isInjection) {
          _selectedSide = MedicationIntakeManager(
            medicationIntakeProvider,
            supplyItemProvider,
          ).getNextSide();
          _hasInitializedSide = true;
        }

        if (!isLoading && !_hasInitializedSupplyItem) {
          _selectedSupplyItem = supplyItemProvider.getMostUsedItemForMedication(
            widget.schedule.molecule,
            widget.schedule.administrationRoute,
            widget.schedule.ester,
          );
          _hasInitializedSupplyItem = true;
        }

        final supplyItemOptions = supplyItemProvider.getItemsForMedication(
          widget.schedule.molecule,
          widget.schedule.administrationRoute,
          widget.schedule.ester,
        );
        final supplyItemDropdownItems = [
          const DropdownMenuItem<SupplyItem?>(
            value: null,
            child: Text('None'),
          ),
          ...supplyItemOptions.map(
            (item) => DropdownMenuItem<SupplyItem?>(
              value: item,
              child: Text(item.name),
            ),
          ),
        ];

        return ModelForm(
          title: 'Take ${widget.schedule.name}',
          submitButtonLabel: 'Take intake',
          isFormValid: _isFormValid,
          saveChanges: (!isLoading && _isFormValid)
              ? () => _takeIntake(medicationIntakeProvider, supplyItemProvider)
              : () {},
          fields: [
            FormDateField(
              label: 'Date',
              date: _takenDate,
              onChanged: _onTakenDateChanged,
            ),
            FormSpacer(),
            FormTextField(
              controller: _takenDoseController,
              label: 'Amount',
              onChanged: _onTakenDoseChanged,
              inputType: TextInputType.numberWithOptions(decimal: true),
              suffixText: widget.schedule.molecule.unit,
              errorText: _takenDoseError,
              regexFormatter: r'[0-9.,]',
            ),
            if (_selectedSupplyItem != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      const WidgetSpan(
                        child: Icon(
                          Icons.info_outline,
                          size: 16,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' $_takenDose ${widget.schedule.molecule.unit} = ${_selectedSupplyItem!.getAmount(_takenDose)} ${_selectedSupplyItem!.administrationRoute.unit}',
                      ),
                    ],
                  ),
                ),
              ),
            FormDropdownField<SupplyItem?>(
              value: _selectedSupplyItem,
              items: supplyItemDropdownItems,
              onChanged: _onSupplyItemChanged,
              label: 'Supply item',
            ),
            if (_isInjection) ...[
              FormDropdownField<InjectionSide>(
                value: _selectedSide,
                items: InjectionSideDropdown.menuItems,
                onChanged: _onInjectionSideChanged,
                label: 'Injection side',
              ),
              FormTextField(
                controller: _deadSpaceController,
                label: 'Needle dead space',
                onChanged: _onDeadSpaceChanged,
                inputType: TextInputType.numberWithOptions(decimal: true),
                suffixText: 'μL',
                errorText: _deadSpaceError,
                regexFormatter: r'[0-9.,]',
              ),
            ],
          ],
        );
      },
    );
  }
}
