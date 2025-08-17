import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/model/medication_intake.dart';
import 'package:transdiy/data/providers/medication_intake_provider.dart';
import 'package:transdiy/ui/views/intakes/intake_dialog.dart';

class IntakesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationIntakeState = context.watch<MedicationIntakeProvider>();

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            medicationIntakeState.addIntake(DateTime.now(), 4);
          },
          child: Text('ajouter une prise'),
        ),
        Expanded(
          child: medicationIntakeState.isLoading
              ? Center(child: CircularProgressIndicator())
              : medicationIntakeState.notTakenIntakes.isEmpty
                  ? Center(
                      child: Text('No intakes yet'),
                    )
                  : ListView.builder(
                      itemCount: medicationIntakeState.notTakenIntakes.length,
                      itemBuilder: (context, index) {
                        MedicationIntake intake =
                            medicationIntakeState.notTakenIntakes[index];
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
