import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mona/controllers/medication_intake_manager.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
import 'package:mona/ui/constants/dimensions.dart';
import 'package:mona/ui/widgets/forms/form_date_field.dart';
import 'package:mona/ui/widgets/forms/form_text_field.dart';
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

  @override
  void initState() {
    super.initState();
    _takenDate = widget.scheduledDate;
    _takenDoseController =
        TextEditingController(text: widget.schedule.dose.toString());
  }

  @override
  void dispose() {
    _takenDoseController.dispose();
    super.dispose();
  }

  String? get _takenDoseError {
    final text = _takenDoseController.text.replaceAll(',', '.');
    final dose = Decimal.tryParse(text);
    if (dose == null || dose <= Decimal.zero) return 'Enter a dose';
    return null;
  }

  bool get _isFormValid => _takenDoseError == null;

  void _takeIntake(
    MedicationIntakeProvider medicationIntakeProvider,
    SupplyItemProvider supplyItemProvider,
  ) {
    if (!_isFormValid) return;
    if (!mounted) return;

    final dose = Decimal.parse(_takenDoseController.text.replaceAll(',', '.'));

    MedicationIntakeManager(medicationIntakeProvider, supplyItemProvider)
        .takeMedication(
      dose,
      widget.scheduledDate,
      _takenDate,
      supplyItemProvider.getMostUsedItem(),
      widget.schedule,
      _selectedSide,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MedicationIntakeProvider, SupplyItemProvider>(
      builder: (context, medicationIntakeProvider, supplyItemProvider, child) {
        final bool isLoading =
            medicationIntakeProvider.isLoading || supplyItemProvider.isLoading;

        if (!isLoading) {
          _selectedSide = MedicationIntakeManager(
            medicationIntakeProvider,
            supplyItemProvider,
          ).getNextSide();
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
                      onChanged: (date) => setState(() {
                        _takenDate = date;
                      }),
                    ),
                    FormTextField(
                      controller: _takenDoseController,
                      label: 'Amount',
                      onChanged: () => setState(() {}),
                      inputType: TextInputType.number,
                      suffixText: 'mg',
                      errorText: _takenDoseError,
                      regexFormatter: r'[0-9.,]',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 6),
                      child: DropdownButtonFormField<InjectionSide>(
                        initialValue: _selectedSide,
                        decoration: const InputDecoration(
                          labelText: 'Injection side',
                          border: OutlineInputBorder(),
                        ),
                        isExpanded: true,
                        items: InjectionSide.values
                            .map(
                              (side) => DropdownMenuItem<InjectionSide>(
                                value: side,
                                child: Text(
                                  side.label[0].toUpperCase() +
                                      side.label.substring(1),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (side) {
                          if (side != null) {
                            setState(() {
                              _selectedSide = side;
                            });
                          }
                        },
                      ),
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
