import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/models/medication_intake/medication_intake.dart';
import 'package:transdiy/models/medication_intake/medication_intake_state.dart';
import 'package:transdiy/pages/intakes/intake_dialog.dart';

class IntakesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationIntakeState = context.watch<MedicationIntakeState>();

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
