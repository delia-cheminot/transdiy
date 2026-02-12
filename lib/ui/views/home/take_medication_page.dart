import 'package:flutter/material.dart';
import 'package:mona/controllers/medication_intake_manager.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
import 'package:mona/ui/constants/dimensions.dart';
import 'package:mona/ui/widgets/forms/form_date_field.dart';
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
  InjectionSide _selectedSide = InjectionSide.left;

  @override
  void initState() {
    super.initState();
    _takenDate = widget.scheduledDate;
  }

  void _takeIntake(
    MedicationIntakeProvider medicationIntakeProvider,
    SupplyItemProvider supplyItemProvider,
  ) {
    MedicationIntakeManager(medicationIntakeProvider, supplyItemProvider)
        .takeMedication(
      widget.schedule.dose,
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
                    const SizedBox(height: 8),
                    DropdownButtonFormField<InjectionSide>(
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
                    const SizedBox(height: 16),
                    FormDateField(
                      date: _takenDate,
                      label: 'Date taken',
                      onChanged: (date) => setState(() {
                        _takenDate = date;
                      }),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      alignment: Alignment.center,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: () => _takeIntake(
                                    medicationIntakeProvider,
                                    supplyItemProvider),
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
