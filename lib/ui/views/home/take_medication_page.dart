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

  @override
  void initState() {
    super.initState();
    _takenDate = widget.scheduledDate;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _takeIntake(SupplyItemProvider supplyItemProvider,
      MedicationIntakeProvider medicationIntakeProvider, InjectionSide side) {
    MedicationIntakeManager(medicationIntakeProvider, supplyItemProvider)
        .takeMedication(widget.schedule.dose, widget.scheduledDate, _takenDate,
            supplyItemProvider.getMostUsedItem(), widget.schedule, side);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final supplyItemProvider = Provider.of<SupplyItemProvider>(context);
    final medicationIntakeProvider =
        Provider.of<MedicationIntakeProvider>(context);

    final side =
        MedicationIntakeManager(medicationIntakeProvider, supplyItemProvider)
            .getNextSide();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Take intake'),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: pagePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Take intake on ${side.label} side',
                ),
                SizedBox(height: 8),
                FormDateField(
                  date: _takenDate,
                  label: 'Date taken',
                  onChanged: (date) => setState(() {
                    _takenDate = date;
                  }),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  width: double.infinity,
                  child: supplyItemProvider.isLoading
                      ? CircularProgressIndicator()
                      : FilledButton(
                          onPressed: () => _takeIntake(supplyItemProvider,
                              medicationIntakeProvider, side),
                          child: Text('Take intake'),
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
