import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/models/medication_intake/medication_intake.dart';
import 'package:transdiy/models/medication_intake/medication_intake_state.dart';

class IntakesHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationIntakeState = context.watch<MedicationIntakeState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Historique'),
      ),
      body: Column(
        children: [
          Expanded(
            child: medicationIntakeState.isLoading
                ? Center(child: CircularProgressIndicator())
                : medicationIntakeState.takenIntakes.isEmpty
                    ? Center(
                        child: Text('Les prises effectuées apparaîtront ici'),
                      )
                    : ListView.builder(
                        itemCount: medicationIntakeState.takenIntakes.length,
                        itemBuilder: (context, index) {
                          MedicationIntake intake =
                              medicationIntakeState.takenIntakes[index];
                          return ListTile(
                            title: Text(intake.scheduledDateTime.toString()),
                            subtitle: Text(intake.takenDateTime.toString()),
                            onTap: () {
                              medicationIntakeState.deleteIntake(intake);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
