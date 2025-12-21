import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/model/medication_schedule.dart';
import 'package:transdiy/data/providers/medication_schedule_provider.dart';

class BrickTile extends StatelessWidget {
  const BrickTile({super.key});

  @override
  Widget build(BuildContext context) {
    final medicationScheduleProvider =
        context.watch<MedicationScheduleProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('à venir')),
      body: ListView(
        children: <Widget>[
          for (final schedule in medicationScheduleProvider.schedules)
            _buildTile(schedule),
          Divider(height: 0),
        ],
      ),
    );
  }

  String _getPharmacyAsset(MedicationSchedule schedule) {
    return "assets/pharmacie/tablets/full_tablet.svg";
  }

  String _getTreatmentName(MedicationSchedule schedule) {
    return "Oestradiol Enanthate";
  }

  String _getTreatmentDate(MedicationSchedule schedule) {
    return "fuck that shit bro";
  }

  ListTile _buildTile(MedicationSchedule schedule) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: SvgPicture.asset(_getPharmacyAsset(schedule))),
      title: Text(_getTreatmentName(schedule)),
      subtitle: Text(_getTreatmentDate(schedule)),
      trailing: Icon(Icons.favorite_rounded),
    );
  }
}
