import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/ui/widgets/dialogs.dart';
import 'package:mona/ui/widgets/main_page_wrapper.dart';
import 'package:provider/provider.dart';

class IntakesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MedicationIntakeProvider>(
      builder: (context, medicationIntakeProvider, child) {
        return MainPageWrapper(
          isLoading: medicationIntakeProvider.isLoading,
          isEmpty: medicationIntakeProvider.takenIntakes.isEmpty,
          emptyMessage: 'Taken intakes will appear here.',
          child: ListView.builder(
            itemCount: medicationIntakeProvider.takenIntakes.length,
            itemBuilder: (context, index) {
              MedicationIntake intake =
                  medicationIntakeProvider.takenIntakes[index];
              final intakeDate =
                  intake.takenDateTime ?? intake.scheduledDateTime;
              // TODO make taken non nullable and remove scheduled
              final dateText = DateFormat.yMMMd().format(intakeDate);
              final sideText =
                  intake.side?.label != null ? ' • ${intake.side!.label}' : '';
              return ListTile(
                title: Text(dateText),
                subtitle: Text('${intake.dose} mg$sideText'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    final confirmed = await Dialogs.confirmDelete(context);
                    if (confirmed == true) {
                      medicationIntakeProvider.deleteIntake(intake);
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
