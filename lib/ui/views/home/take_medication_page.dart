import 'package:flutter/material.dart';
import 'package:mona/controllers/medication_intake_manager.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/model/molecule.dart';
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
  InjectionSide _selectedSide = InjectionSide.left;
  bool _hasInitializedSide = false;

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

  String? get _takenDoseError =>
      MedicationIntake.validateDose(_takenDoseController.text);

  bool get _isFormValid => _takenDoseError == null;

  void _takeIntake(
    MedicationIntakeProvider medicationIntakeProvider,
    SupplyItemProvider supplyItemProvider,
  ) {
    if (!_isFormValid) return;
    if (!mounted) return;

    final dose = parseDecimal(_takenDoseController.text);

    MedicationIntakeManager(medicationIntakeProvider, supplyItemProvider)
        .takeMedication(
      dose: dose,
      scheduledDate: widget.scheduledDate,
      takenDate: _takenDate,
      supplyItem: supplyItemProvider.getMostUsedItem(),
      schedule: widget.schedule,
      side: _selectedSide,
      // TODO update
      molecule: KnownMolecules.estradiol,
      administrationRoute: AdministrationRoute.injection,
      ester: Ester.enanthate,
    );
    Navigator.of(context).pop();
  }

  late final List<DropdownMenuItem<InjectionSide>> _injectionSideItems =
      InjectionSide.values
          .map(
            (side) => DropdownMenuItem<InjectionSide>(
              value: side,
              child: Text(
                side.name[0].toUpperCase() + side.name.substring(1),
              ),
            ),
          )
          .toList();

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
  Widget build(BuildContext context) {
    return Consumer2<MedicationIntakeProvider, SupplyItemProvider>(
      builder: (context, medicationIntakeProvider, supplyItemProvider, child) {
        final bool isLoading =
            medicationIntakeProvider.isLoading || supplyItemProvider.isLoading;

        if (!isLoading && !_hasInitializedSide) {
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
                      suffixText: 'mg',
                      errorText: _takenDoseError,
                      regexFormatter: r'[0-9.,]',
                    ),
                    FormDropdownField<InjectionSide>(
                      value: _selectedSide,
                      items: _injectionSideItems,
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
