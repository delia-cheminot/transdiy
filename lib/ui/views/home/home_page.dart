import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mona/controllers/schedule_manager.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/ui/views/home/take_medication_page.dart';
import 'package:mona/ui/widgets/main_page_wrapper.dart';
import 'package:mona/util/date_helpers.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationScheduleProvider =
        context.watch<MedicationScheduleProvider>();
    final medicationIntakeProvider = context.watch<MedicationIntakeProvider>();

    return MainPageWrapper(
      isLoading: (medicationScheduleProvider.isLoading ||
          medicationIntakeProvider.isLoading),
      isEmpty: medicationScheduleProvider.schedules.isEmpty,
      emptyMessage: 'Add a schedule in your profile to get started!',
      child: SingleChildScrollView(
        child: Column(
          children: [
            ..._buildTodaySection(context),
            ..._buildUpcomingSection(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTodaySection(BuildContext context) {
    final theme = Theme.of(context);
    final medicationScheduleProvider =
        context.watch<MedicationScheduleProvider>();
    final medicationIntakeProvider = context.watch<MedicationIntakeProvider>();
    final scheduleManager =
        ScheduleManager(medicationScheduleProvider, medicationIntakeProvider);

    final overdueSchedules =
        scheduleManager.getSchedulesByStatus(ScheduleStatus.overdue);

    final todayOverdueSchedules =
        scheduleManager.getSchedulesByStatus(ScheduleStatus.todayOverdue);

    final todaySchedules =
        scheduleManager.getSchedulesByStatus(ScheduleStatus.today);

    final hasSchedulesToday = overdueSchedules.isNotEmpty ||
        todayOverdueSchedules.isNotEmpty ||
        todaySchedules.isNotEmpty;

    final widgets = <Widget>[];

    widgets.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Today - ${DateFormat.MMMMd().format(DateTime.now())}",
          style: theme.textTheme.headlineMedium,
        ),
      ),
    );

    if (!hasSchedulesToday) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.check_circle_outline,
                  color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text("All done for today!", style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      );
      return widgets;
    }

    for (final schedule in overdueSchedules) {
      widgets.add(_buildOverdueTile(context, schedule));
    }

    for (final schedule in todayOverdueSchedules) {
      widgets.add(_buildTodayOverdueTile(context, schedule));
    }

    for (final schedule in todaySchedules) {
      widgets.add(_buildTodayTile(context, schedule));
    }

    return widgets;
  }

  List<Widget> _buildUpcomingSection(BuildContext context) {
    final theme = Theme.of(context);
    final medicationScheduleProvider =
        context.watch<MedicationScheduleProvider>();
    final medicationIntakeProvider = context.watch<MedicationIntakeProvider>();
    final scheduleManager =
        ScheduleManager(medicationScheduleProvider, medicationIntakeProvider);

    final upcomingSchedules =
        scheduleManager.getSchedulesByStatus(ScheduleStatus.upcoming);

    if (upcomingSchedules.isEmpty) {
      return [];
    }

    final widgets = <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Upcoming",
          style: theme.textTheme.headlineMedium,
        ),
      ),
    ];

    for (final schedule in upcomingSchedules) {
      widgets.add(_buildUpcomingTile(context, schedule));
    }

    return widgets;
  }

  Widget _buildTodayTile(
    BuildContext context,
    MedicationSchedule schedule,
  ) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
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
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: SvgPicture.asset("assets/pharmacie/tablets/full_tablet.svg"),
          ),
          title: Text(schedule.name),
          subtitle: Text("Next intake today"),
          trailing: const Icon(Icons.play_circle),
        ),
      ),
    );
  }

  Widget _buildTodayOverdueTile(
    BuildContext context,
    MedicationSchedule schedule,
  ) {
    final theme = Theme.of(context);

    final medicationIntakeProvider = context.watch<MedicationIntakeProvider>();

    final lastTaken =
        medicationIntakeProvider.getLastIntakeDateForSchedule(schedule.id);
    final lastTakenText = lastTaken != null
        ? "Last taken ${DateFormat.MMMMd().format(lastTaken)}"
        : "Never taken yet";

    return Card(
      color: theme.colorScheme.errorContainer,
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
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(Icons.access_time, color: theme.colorScheme.onErrorContainer),
          ),
          title: Text(schedule.name),
          subtitle: Text("Scheduled today\n$lastTakenText"),
          trailing: const Icon(Icons.play_circle),
        ),
      ),
    );
  }

  Widget _buildOverdueTile(
    BuildContext context,
    MedicationSchedule schedule,
  ) {
    final theme = Theme.of(context);
    final intakeProvider = context.watch<MedicationIntakeProvider>();

    final lastTaken = intakeProvider.getLastIntakeDateForSchedule(schedule.id);
    final lastScheduledText =
        DateFormat.MMMMd().format(schedule.getLastDate()!);
    final lastTakenText =
        lastTaken != null ? DateFormat.MMMMd().format(lastTaken) : "Never";

    return Card(
      color: theme.colorScheme.errorContainer,
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
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(Icons.error_outline, color: theme.colorScheme.onErrorContainer),
          ),
          title: Text(schedule.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Due $lastScheduledText"),
              Text("Last taken: $lastTakenText"),
            ],
          ),
          trailing: const Icon(Icons.play_circle),
        ),
      ),
    );
  }

  Widget _buildUpcomingTile(
    BuildContext context,
    MedicationSchedule schedule,
  ) {
    final nextDate = schedule.getNextDate();
    final nextDateText = DateFormat.MMMMd().format(nextDate);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: SvgPicture.asset("assets/pharmacie/tablets/full_tablet.svg"),
          ),
          title: Text(schedule.name),
          subtitle: Text("Next intake on $nextDateText"),
          trailing: const Icon(Icons.play_circle),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                fullscreenDialog: true,
                builder: (context) =>
                    TakeMedicationPage(schedule, normalizedToday()),
              ),
            );
          },
        ),
      ),
    );
  }
}
