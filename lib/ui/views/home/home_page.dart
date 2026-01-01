import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/model/medication_schedule.dart';
import 'package:transdiy/data/providers/medication_schedule_provider.dart';
import 'package:transdiy/ui/views/home/take_medication_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationScheduleProvider =
        context.watch<MedicationScheduleProvider>();

    return ListView(
      children: <Widget>[
        for (final schedule in medicationScheduleProvider.schedules)
          _buildTile(schedule, context),
      ],
    );
  }

  ListTile _buildTile(MedicationSchedule schedule, BuildContext context) {
    final nextDate = schedule.getNextDate();

    return ListTile(
      leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: SvgPicture.asset("assets/pharmacie/tablets/full_tablet.svg")),
      title: Text(schedule.name),
      subtitle: Text(
          "prochaine prise le ${nextDate.day} ${nextDate.month} ${nextDate.year}"),
      trailing: IconButton(
        icon: const Icon(Icons.play_circle),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (context) => TakeMedicationPage(schedule, nextDate),
            ),
          );
        },
      ),
    );
  }
}
