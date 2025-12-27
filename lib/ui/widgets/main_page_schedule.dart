import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/model/medication_schedule.dart';
import 'package:transdiy/data/providers/medication_schedule_provider.dart';

class MainPageSchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationScheduleProvider =
        context.watch<MedicationScheduleProvider>();

    return ListView(
      children: <Widget>[
        for (final schedule in medicationScheduleProvider.schedules)
          _buildTile(schedule),
      ],
    );
  }

  String _getPharmacyAsset(MedicationSchedule schedule) {
    // for now uniquely estradiol enenthate, add more treatments later and do a switch
    // on the treatment to get the correct asset
    return "assets/pharmacie/tablets/full_tablet.svg";
  }

  String _getTreatmentName(MedicationSchedule schedule) {
    return schedule.name;
  }

  String _getTreatmentDate(MedicationSchedule schedule) {
    final date = schedule.getNextDate()!;
    return "${date.day} ${date.month} ${date.year}";
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
