import 'package:flutter/material.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/ui/widgets/main_page_wrapper.dart';
import 'package:provider/provider.dart';

class IntakesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationIntakeProvider = context.watch<MedicationIntakeProvider>();

    return MainPageWrapper(
      isLoading: medicationIntakeProvider.isLoading,
      isEmpty: medicationIntakeProvider.takenIntakes.isEmpty,
      emptyMessage: 'Les prises effectuées apparaîtront ici',
      child: ListView.builder(
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
    );
  }
}
