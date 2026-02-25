import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mona/controllers/schedule_manager.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/ui/views/home/intake_tile.dart';
import 'package:mona/ui/widgets/main_page_wrapper.dart';
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
      widgets.add(IntakeTile(
          context: context,
          schedule: schedule,
          status: ScheduleStatus.overdue));
    }

    for (final schedule in todayOverdueSchedules) {
      widgets.add(IntakeTile(
          context: context,
          schedule: schedule,
          status: ScheduleStatus.todayOverdue));
    }

    for (final schedule in todaySchedules) {
      widgets.add(IntakeTile(
          context: context, schedule: schedule, status: ScheduleStatus.today));
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
      widgets.add(IntakeTile(
          context: context,
          schedule: schedule,
          status: ScheduleStatus.upcoming));
    }

    return widgets;
  }
}
