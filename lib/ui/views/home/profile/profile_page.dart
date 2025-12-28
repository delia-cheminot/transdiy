import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/providers/medication_schedule_provider.dart';
import 'package:transdiy/ui/views/home/profile/edit_schedule_page.dart';
import 'new_schedule_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationScheduleProvider =
        context.watch<MedicationScheduleProvider>();

    if (medicationScheduleProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            Text('Profil'),
          ],
        )),
        body: Center(
          child:
              CircularProgressIndicator(), // TODO use material 3 progress indicator
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Profil'),
          ],
        ),
      ),
      body: medicationScheduleProvider.schedules.isEmpty
          ? Center(
              child: Text('Ajoutez un traitement pour commencer'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: medicationScheduleProvider.schedules.length,
              itemBuilder: (context, index) {
                final schedule = medicationScheduleProvider.schedules[index];
                return ListTile(
                  title: Text(schedule.name),
                  subtitle: Text("${schedule.dose.toString()} mg "
                      "tous les ${schedule.intervalDays.toString()} jours"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        fullscreenDialog: true,
                        builder: (context) =>
                            EditSchedulePage(schedule: schedule),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (context) => NewSchedulePage(),
          ));
        },
        tooltip: 'Ajouter un traitement',
        child: Icon(Icons.add),
      ),
    );
  }
}
