import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/model/medication_intake.dart';
import 'package:transdiy/data/providers/medication_intake_provider.dart';
import 'package:transdiy/ui/views/intakes/intake_dialog.dart';

class IntakesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationIntakeProvider = context.watch<MedicationIntakeProvider>();

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            medicationIntakeProvider.addIntake(
                DateTime.now(), Decimal.parse('4'));
          },
          child: Text('ajouter une prise'),
        ),
        Expanded(
          child: medicationIntakeProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : medicationIntakeProvider.notTakenIntakes.isEmpty
                  ? Center(
                      child: Text('No intakes yet'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount:
                          medicationIntakeProvider.notTakenIntakes.length,
                      itemBuilder: (context, index) {
                        MedicationIntake intake =
                            medicationIntakeProvider.notTakenIntakes[index];
                        return ListTile(
                          title: Text(intake.scheduledDateTime.toString()),
                          subtitle: Text('Prévue'),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                //fullscreenDialog: true,
                                builder: (context) =>
                                    IntakeDialog(intake: intake),
                              ),
                            );
                          },
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
