import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/ui/constants/dimensions.dart';
import 'package:mona/ui/views/intakes/edit_intake_page.dart';
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
          emptyMessage: 'Taken intakes will appear here',
          child: ListView.builder(
            padding: pagePadding,
            itemCount: medicationIntakeProvider.takenIntakes.length,
            itemBuilder: (context, index) {
              MedicationIntake intake =
                  medicationIntakeProvider.takenIntakesSortedDesc[index];
              return _buildIntakeTile(
                  context, intake, medicationIntakeProvider);
            },
          ),
        );
      },
    );
  }

  Widget _buildIntakeTile(BuildContext context, MedicationIntake intake,
      MedicationIntakeProvider medicationIntakeProvider) {
    final dateText = DateFormat.yMMMd().format(intake.takenDateTime!);

    final theme = Theme.of(context);

    return Card.filled(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        title: Text(dateText),
        subtitle: Text('$intake'),
        leading:
        CircleAvatar(
          backgroundColor: theme.colorScheme.primary,
          child: Icon(
            intake.administrationRoute.icon,
            color: theme.colorScheme.primaryContainer,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () async {
            final confirmed = await Dialogs.confirmDelete(context);
            if (confirmed == true) {
              medicationIntakeProvider.deleteIntake(intake);
            }
          },
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) =>
                  EditIntakePage(intake),
            ),
          );
        },
      ),
    );
  }
}
