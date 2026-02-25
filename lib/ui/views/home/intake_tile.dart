import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mona/controllers/schedule_manager.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/ui/views/home/take_medication_page.dart';
import 'package:mona/util/date_helpers.dart';
import 'package:provider/provider.dart';

class IntakeTile extends StatelessWidget {
  const IntakeTile({
    super.key,
    required this.context,
    required this.schedule,
    required this.status,
  });

  final BuildContext context;
  final MedicationSchedule schedule;
  final ScheduleStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<String> buildSubtitle() {
      switch (status) {
        case ScheduleStatus.today:
          return ["Next intake today"];

        case ScheduleStatus.overdue:
          final lastTaken = context
              .watch<MedicationIntakeProvider>()
              .getLastIntakeDateForSchedule(schedule.id);
          final lastTakenText = lastTaken != null
              ? "Last taken ${DateFormat.MMMMd().format(lastTaken)}"
              : "Never taken yet";
          final lastScheduledText =
              DateFormat.MMMMd().format(schedule.getLastDate()!);
          return [
            "Due $lastScheduledText",
            lastTakenText,
          ];

        case ScheduleStatus.todayOverdue:
          final lastTaken = context
              .watch<MedicationIntakeProvider>()
              .getLastIntakeDateForSchedule(schedule.id);
          final lastTakenText = lastTaken != null
              ? "Last taken ${DateFormat.MMMMd().format(lastTaken)}"
              : "Never taken yet";
          return [
            "Scheduled today",
            lastTakenText,
          ];

        case ScheduleStatus.upcoming:
          final nextDateText =
              DateFormat.MMMMd().format(schedule.getNextDate());
          return ["Next intake on $nextDateText"];
      }
    }

    Color? getTileColor() {
      switch (status) {
        case ScheduleStatus.today:
          return Theme.of(context).colorScheme.primaryContainer;
        case ScheduleStatus.overdue:
          return Theme.of(context).colorScheme.errorContainer;
        case ScheduleStatus.todayOverdue:
          return Theme.of(context).colorScheme.errorContainer;
        default:
          return null;
      }
    }

    CircleAvatar getTileIcon() {
      switch (status) {
        case ScheduleStatus.today:
          return CircleAvatar(
            backgroundColor: theme.colorScheme.onPrimaryContainer,
            child: SvgPicture.asset("assets/pharmacie/tablets/full_tablet.svg"),
          );
        case ScheduleStatus.overdue:
          return CircleAvatar(
              backgroundColor: theme.colorScheme.onErrorContainer,
              child: Icon(Icons.error_outline));
        case ScheduleStatus.todayOverdue:
          return CircleAvatar(
              backgroundColor: theme.colorScheme.onErrorContainer,
              child: Icon(Icons.error_outline));
        default:
          return CircleAvatar(
            backgroundColor: Colors.transparent,
            child: SvgPicture.asset("assets/pharmacie/tablets/full_tablet.svg"),
          );
      }
    }

    return Card(
      color: getTileColor(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (context) =>
                  TakeMedicationPage(schedule, normalizedToday()),
            ),
          );
        },
        child: ListTile(
          leading: getTileIcon(),
          title: Text(schedule.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildSubtitle().map((text) => Text(text)).toList(),
          ),
        ),
      ),
    );
  }
}
