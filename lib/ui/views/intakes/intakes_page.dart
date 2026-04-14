import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/ui/views/intakes/edit_intake_page.dart';
import 'package:mona/ui/widgets/dialogs.dart';
import 'package:mona/ui/widgets/main_page_wrapper.dart';
import 'package:provider/provider.dart';

class IntakesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Consumer<MedicationIntakeProvider>(
      builder: (context, medicationIntakeProvider, child) {
        return MainPageWrapper(
          isLoading: medicationIntakeProvider.isLoading,
          isEmpty: medicationIntakeProvider.takenIntakes.isEmpty,
          emptyMessage: localizations.empty_intakes,
          child: ListView.builder(
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
    final locale = Localizations.localeOf(context).toString();
    final dateText = DateFormat.yMMMd(locale).format(intake.takenDateTime!);

    return ListTile(
      title: Text(dateText),
      subtitle: Text('$intake'),
      leading: CircleAvatar(
        child: Icon(
          intake.administrationRoute.icon,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () async {
          final confirmed = await confirmDeleteIntake(context);
          if (confirmed == true) {
            // TODO track supply item id in intake to put the quantity back
            medicationIntakeProvider.deleteIntake(intake);
          }
        },
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => EditIntakePage(intake),
            fullscreenDialog: true,
          ),
        );
      },
    );
  }

  static Future<bool?> confirmDeleteIntake(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Dialogs.confirmDialog(
        context: context, title: localizations.deleteIntake);
  }
}
