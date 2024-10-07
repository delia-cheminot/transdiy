import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/medication_intake/medication_intake.dart';
import 'package:transdiy/medication_intake/medication_intake_manager.dart';
import 'package:transdiy/medication_intake/medication_intake_state.dart';
import 'package:transdiy/supply_item/supply_item_state.dart';
import 'package:transdiy/supply_item/supply_item_manager.dart';

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
              MedicationIntakeManager(context.read<MedicationIntakeState>())
                  .takeMedication(
                      widget.intake,
                      context.read<SupplyItemState>().items[0],
                      SupplyItemManager(context.read<SupplyItemState>()));
              Navigator.of(context).pop();
            },
            child: Text('Prendre'),
          ),
        ],
      ),
    );
  }
}
