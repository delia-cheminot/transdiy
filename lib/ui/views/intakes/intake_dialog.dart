import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/controllers/medication_intake_manager.dart';
import 'package:transdiy/data/model/medication_intake.dart';
import 'package:transdiy/data/providers/medication_intake_provider.dart';
import 'package:transdiy/data/providers/medication_schedule_provider.dart';
import 'package:transdiy/data/providers/supply_item_provider.dart';

class IntakeDialog extends StatefulWidget {
  final MedicationIntake intake;

  IntakeDialog({required this.intake});

  @override
  State<IntakeDialog> createState() => _IntakeDialogState();
}

class _IntakeDialogState extends State<IntakeDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prise'),
      ),
      body: Column(
        children: [
          Text(widget.intake.scheduledDateTime.toString()),
          Text(widget.intake.dose.toString()),
          // button to take medication
          ElevatedButton(
            onPressed: () {
              MedicationIntakeManager(
                      context.read<MedicationIntakeProvider>(),
                      context.read<MedicationScheduleProvider>(),
                      context.read<SupplyItemProvider>())
                  .takeMedication(widget.intake,
                      context.read<SupplyItemProvider>().items[0]);
              Navigator.of(context).pop();
            },
            child: Text('Prendre'),
          ),
        ],
      ),
    );
  }
}
