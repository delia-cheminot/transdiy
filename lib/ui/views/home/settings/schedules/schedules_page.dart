import 'package:flutter/material.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/l10n/build_context_extensions.dart';
import 'package:mona/l10n/helpers/medication_schedule_l10n.dart';
import 'package:mona/ui/views/home/settings/schedules/edit_schedule/edit_schedule_page.dart';
import 'package:provider/provider.dart';
import 'new_schedule_page.dart';

class SchedulesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationScheduleProvider =
        context.watch<MedicationScheduleProvider>();
    final localizations = context.l10n;

    if (medicationScheduleProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(localizations.schedules),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.schedules),
      ),
      body: SafeArea(
        child: medicationScheduleProvider.schedules.isEmpty
            ? Center(
                child: Text(localizations.addScheduleToGetStarted),
              )
            : ListView.builder(
                itemCount: medicationScheduleProvider.schedules.length,
                itemBuilder: (context, index) {
                  final schedule = medicationScheduleProvider.schedules[index];
                  return ListTile(
                    title: Text(schedule.name),
                    subtitle: Text(
                      localizedMedicationScheduleSummary(
                        schedule,
                        localizations,
                      ),
                    ),
                    leading: CircleAvatar(
                      child: Icon(
                        schedule.administrationRoute.icon,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) =>
                              EditSchedulePage(schedule: schedule),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (context) => NewSchedulePage(),
          ));
        },
        tooltip: localizations.addSchedule,
        child: Icon(Icons.add),
      ),
    );
  }
}
