import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/model/medication_intake.dart';
import 'package:transdiy/data/providers/medication_intake_provider.dart';

class IntakesHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationIntakeState = context.watch<MedicationIntakeProvider>();

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
