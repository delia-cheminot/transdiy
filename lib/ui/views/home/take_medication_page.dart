import 'package:flutter/material.dart';
import 'package:mona/controllers/medication_intake_manager.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
import 'package:mona/ui/constants/dimensions.dart';
import 'package:mona/ui/widgets/forms/form_date_field.dart';
import 'package:mona/ui/widgets/forms/form_dropdown_field.dart';
import 'package:mona/ui/widgets/forms/form_text_field.dart';
import 'package:mona/util/decimal_helpers.dart';
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
  InjectionSide? _selectedSide;
  bool _hasInitializedSide = false;

  String? get _takenDoseError =>
      MedicationIntake.validateDose(_takenDoseController.text);

  bool get _isFormValid => _takenDoseError == null;

  bool get _isInjection =>
      widget.schedule.administrationRoute == AdministrationRoute.injection;

  void _takeIntake(MedicationIntakeProvider medicationIntakeProvider,
      SupplyItemProvider supplyItemProvider) {
    if (!_isFormValid) return;
    if (!mounted) return;

    final dose = parseDecimal(_takenDoseController.text);
    final itemToUse = supplyItemProvider.getMostUsedItemForMedication(
      widget.schedule.molecule,
      widget.schedule.administrationRoute,
      widget.schedule.ester,
    );

    MedicationIntakeManager(medicationIntakeProvider, supplyItemProvider)
        .takeMedication(
      dose: dose,
      scheduledDate: widget.scheduledDate,
      takenDate: _takenDate,
      supplyItem: itemToUse,
      schedule: widget.schedule,
      side: _selectedSide,
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
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _takenDate = DateTime.now();
    _takenDoseController =
        TextEditingController(text: widget.schedule.dose.toString());
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
          _selectedSide = MedicationIntakeManager(
            medicationIntakeProvider,
            supplyItemProvider,
          ).getNextSide();
          _hasInitializedSide = true;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Take intake'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormDateField(
                      date: _takenDate,
                      label: 'Date',
                      onChanged: _onTakenDateChanged,
                    ),
                    FormTextField(
                      controller: _takenDoseController,
                      label: 'Amount',
                      onChanged: _onTakenDoseChanged,
                      inputType: TextInputType.number,
                      suffixText: widget.schedule.molecule.unit,
                      errorText: _takenDoseError,
                      regexFormatter: r'[0-9.,]',
                    ),
                    if (_isInjection)
                      FormDropdownField<InjectionSide>(
                        value: _selectedSide,
                        items: InjectionSideDropdown.menuItems,
                        onChanged: _onInjectionSideChanged,
                        label: 'Injection side',
                      ),
                    const SizedBox(height: 16),
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: (!isLoading && _isFormValid)
                              ? () => _takeIntake(
                                  medicationIntakeProvider, supplyItemProvider)
                              : null, // null = bouton grisé
                          child: const Text('Take intake'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
