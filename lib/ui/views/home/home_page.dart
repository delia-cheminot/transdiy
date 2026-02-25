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
      widgets.add(_buildIntakeTile(context, schedule, ScheduleStatus.overdue));
    }

    for (final schedule in todayOverdueSchedules) {
      widgets.add(
          _buildIntakeTile(context, schedule, ScheduleStatus.todayOverdue));
    }

    for (final schedule in todaySchedules) {
      widgets.add(_buildIntakeTile(context, schedule, ScheduleStatus.today));
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
      widgets.add(_buildIntakeTile(context, schedule, ScheduleStatus.upcoming));
    }

    return widgets;
  }

  Widget _buildIntakeTile(BuildContext context, MedicationSchedule schedule,
      ScheduleStatus status) {
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
