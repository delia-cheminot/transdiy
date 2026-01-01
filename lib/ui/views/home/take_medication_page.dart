import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/controllers/medication_intake_manager.dart';
import 'package:transdiy/data/model/medication_intake.dart';
import 'package:transdiy/data/providers/medication_intake_provider.dart';
import 'package:transdiy/data/providers/supply_item_provider.dart';
import 'package:transdiy/widgets/form_date_field.dart';

class TakeMedicationPage extends StatefulWidget {
  final MedicationIntake intake;

  TakeMedicationPage({required this.intake});

  @override
  State<TakeMedicationPage> createState() => _TakeMedicationPageState();
}

class _TakeMedicationPageState extends State<TakeMedicationPage> {
  late DateTime _takenDate;

  @override
  void initState() {
    super.initState();
    _takenDate = widget.intake.scheduledDateTime;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _takeIntake(SupplyItemProvider supplyItemProvider) {
    MedicationIntakeManager(
      context.read<MedicationIntakeProvider>(),
      supplyItemProvider,
    ).takeMedicationSimple(
        widget.intake, supplyItemProvider.orderedByRemainingDose.first,
        takenDate: _takenDate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final supplyItemProvider = Provider.of<SupplyItemProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Prendre le traitement'),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormDateField(
                  date: _takenDate,
                  label: 'Date de prise',
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
                          onPressed: () => _takeIntake(supplyItemProvider),
                          child: Text('Prendre'),
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
