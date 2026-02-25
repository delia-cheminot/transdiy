import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mona/controllers/medication_intake_manager.dart';
import 'package:mona/controllers/schedule_manager.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
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

    String getDaysUntilIntake() {
      return schedule
          .getNextDate()
          .difference(DateTime.now())
          .inDays
          .toString();
    }

    String? getDaysSinceLastTaken() {
      return context
          .watch<MedicationIntakeProvider>()
          .getLastIntakeDateForSchedule(schedule.id)
          ?.difference(DateTime.now())
          .inDays
          .abs()
          .toString();
    }

    String? getDaysSinceLastScheduled() {
      return schedule
          .getLastDate()
          ?.difference(DateTime.now())
          .inDays
          .abs()
          .toString();
    }

    String getIntakeInfo() {
      InjectionSide nextSide = MedicationIntakeManager(
        context.watch<MedicationIntakeProvider>(),
        context.watch<SupplyItemProvider>(),
      ).getNextSide();
      return "${schedule.dose} mg • ${nextSide.name} side";
    }

    String getScheduledTime() {
      switch (status) {
        case ScheduleStatus.today:
        case ScheduleStatus.todayOverdue:
          return "Today";

        case ScheduleStatus.overdue:
          final lastScheduledText =
              DateFormat.MMMMd().format(schedule.getLastDate()!);
          return "$lastScheduledText - ${getDaysSinceLastScheduled()} days ago";

        case ScheduleStatus.upcoming:
          final nextDateText =
              DateFormat.MMMMd().format(schedule.getNextDate());
          return "$nextDateText - in ${getDaysUntilIntake()} days";
      }
    }

    String? getWarningText() {
      switch (status) {
        case ScheduleStatus.today:
          final lastTaken = context
              .watch<MedicationIntakeProvider>()
              .getLastIntakeDateForSchedule(schedule.id);
          final lastScheduled = schedule.getLastDate();
          if (lastTaken != null && lastTaken != lastScheduled) {
            return "Last taken ${getDaysSinceLastTaken()} days ago (${DateFormat.MMMd().format(lastTaken)})";
          }
          return null;

        case ScheduleStatus.upcoming:
          return null;

        case ScheduleStatus.overdue:
        case ScheduleStatus.todayOverdue:
          final lastTaken = context
              .watch<MedicationIntakeProvider>()
              .getLastIntakeDateForSchedule(schedule.id);
          final lastTakenText = lastTaken != null
              ? "Last taken ${getDaysSinceLastTaken()} days ago (${DateFormat.MMMd().format(lastTaken)})"
              : "Never taken yet";
          return lastTakenText;
      }
    }

    Color? getTileColor() {
      switch (status) {
        case ScheduleStatus.today:
          return Theme.of(context).colorScheme.primaryContainer;
        case ScheduleStatus.overdue:
          return Theme.of(context).colorScheme.primaryContainer;
        case ScheduleStatus.todayOverdue:
          return Theme.of(context).colorScheme.primaryContainer;
        default:
          return null;
      }
    }

    CircleAvatar getTileIcon() {
      switch (status) {
        case ScheduleStatus.today:
          return CircleAvatar(
            backgroundColor: theme.colorScheme.onPrimaryContainer,
            child: Icon(Symbols.syringe,
                color: theme.colorScheme.primaryContainer),
          );
        case ScheduleStatus.overdue:
          return CircleAvatar(
              backgroundColor: theme.colorScheme.onPrimaryContainer,
              child: Icon(Symbols.schedule,
                  color: theme.colorScheme.primaryContainer));
        case ScheduleStatus.todayOverdue:
          return CircleAvatar(
              backgroundColor: theme.colorScheme.onPrimaryContainer,
              child: Icon(Symbols.schedule,
                  color: theme.colorScheme.primaryContainer));
        case ScheduleStatus.upcoming:
          return CircleAvatar(
              backgroundColor: theme.colorScheme.secondary,
              child: Text(getDaysUntilIntake(),
                  style: TextStyle(
                      color: theme.colorScheme.onSecondary,
                      fontWeight: FontWeight.bold)));
      }
    }

    return Card.filled(
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getScheduledTime(),
                style: theme.textTheme.labelMedium,
              ),
              Text(schedule.name, style: theme.textTheme.titleMedium),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (status != ScheduleStatus.upcoming) Text(getIntakeInfo()),
              if (getWarningText() != null)
                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.error_outline, size: 16),
                      ),
                      const TextSpan(text: " "),
                      TextSpan(text: getWarningText()!),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
