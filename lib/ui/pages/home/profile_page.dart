import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/providers/medication_schedule_state.dart';
import 'new_schedule_dialog.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationScheduleState = context.watch<MedicationScheduleState>();

    if (medicationScheduleState.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profil'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: medicationScheduleState.schedules.isEmpty
          ? Center(
              child: Text('Ajoutez un traitement pour commencer'),
            )
          : ListView.builder(
              itemCount: medicationScheduleState.schedules.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(medicationScheduleState.schedules[index].name),
                  subtitle: Text(
                      medicationScheduleState.schedules[index].dose.toString()),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (context) => NewScheduleDialog(),
          ));
        },
        tooltip: 'Ajouter un traitement',
        child: Icon(Icons.add),
      ),
    );
  }
}
