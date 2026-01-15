import 'package:flutter/material.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:provider/provider.dart';

class IntakesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationIntakeProvider = context.watch<MedicationIntakeProvider>();

    return Column(
      children: [
        Expanded(
          child: medicationIntakeProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : medicationIntakeProvider.takenIntakes.isEmpty
                  ? Center(
                      child: Text('Taken intakes will appear here.'),
                    )
                  : ListView.builder(
                      itemCount: medicationIntakeProvider.takenIntakes.length,
                      itemBuilder: (context, index) {
                        MedicationIntake intake =
                            medicationIntakeProvider.takenIntakes[index];
                        return ListTile(
                          title: Text(intake.scheduledDateTime.toString()),
                          subtitle: Text(intake.takenDateTime.toString()),
                          onTap: () {
                            medicationIntakeProvider.deleteIntake(intake);
                          },
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
