import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/providers/medication_schedule_provider.dart';
import 'new_schedule_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationScheduleProvider = context.watch<MedicationScheduleProvider>();

    if (medicationScheduleProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            Text('Profil'),
            Image.asset(
              'assets/global/logo.png',
              width: 100,
              height: 100,
            ),
          ],
        )),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Profil'),
            Image.asset(
              'assets/global/logo.png',
              width: 100,
              height: 100,
            ),
          ],
        ),
      ),
      body: medicationScheduleProvider.schedules.isEmpty
          ? Center(
              child: Text('Ajoutez un traitement pour commencer'),
            )
          : ListView.builder(
              itemCount: medicationScheduleProvider.schedules.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(medicationScheduleProvider.schedules[index].name),
                    subtitle: Text(
                        "${medicationScheduleProvider.schedules[index].dose.toString()} mg "
                        "tous les ${medicationScheduleProvider.schedules[index].intervalDays.toString()} jours"));
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
