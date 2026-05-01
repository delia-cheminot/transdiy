import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mona/controllers/schedule_manager.dart';
import 'package:mona/data/model/date.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/distribution.dart';
import 'package:mona/l10n/build_context_extensions.dart';
import 'package:mona/ui/constants/dimensions.dart';
import 'package:mona/ui/views/home/intake_tile.dart';
import 'package:mona/ui/views/home/legacy_deprecation_card.dart';
import 'package:mona/ui/widgets/main_page_wrapper.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationScheduleProvider =
        context.watch<MedicationScheduleProvider>();
    final medicationIntakeProvider = context.watch<MedicationIntakeProvider>();
    final localizations = context.l10n;

    return MainPageWrapper(
      isLoading: (medicationScheduleProvider.isLoading ||
          medicationIntakeProvider.isLoading),
      isEmpty: medicationScheduleProvider.schedules.isEmpty,
      emptyMessage: localizations.empty_home,
      child: SingleChildScrollView(
        child: Padding(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLegacyDistribution) const LegacyDeprecationCard(),
              ..._buildTodaySection(context),
              ..._buildUpcomingSection(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildScheduleSection(
    BuildContext context, {
    required String title,
    required List<ScheduleStatus> statuses,
    bool showAllDoneMessage = false,
  }) {
    final theme = Theme.of(context);
    final localizations = context.l10n;
    final scheduleManager = ScheduleManager(
      context.watch<MedicationScheduleProvider>(),
      context.watch<MedicationIntakeProvider>(),
    );

    final schedules = statuses
        .expand((status) => scheduleManager.getSchedulesByStatus(status))
        .toList();

    if (schedules.isEmpty && !showAllDoneMessage) return [];

    final widgets = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(title, style: theme.textTheme.headlineMedium),
      ),
    ];

    if (schedules.isEmpty && showAllDoneMessage) {
      widgets.add(
        Card.filled(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.tertiary,
              child: Icon(
                Symbols.check,
                color: theme.colorScheme.onTertiary,
              ),
            ),
            title:
                Text(localizations.allDone, style: theme.textTheme.titleMedium),
            subtitle: Text(localizations.noIntakesDue),
          ),
        ),
      );
      return widgets;
    }

    widgets.addAll(schedules.map((schedule) {
      final status = statuses.firstWhere(
        (s) => scheduleManager.getSchedulesByStatus(s).contains(schedule),
      );
      return IntakeTile(schedule: schedule, status: status);
    }));

    return widgets;
  }

  List<Widget> _buildTodaySection(BuildContext context) {
    final date = Date.today().format(DateFormat.MMMMEEEEd(context.languageTag));
    return _buildScheduleSection(
      context,
      title: date.replaceRange(0, 1, date.substring(0, 1).toUpperCase()),
      statuses: [
        ScheduleStatus.overdue,
        ScheduleStatus.todayOverdue,
        ScheduleStatus.today
      ],
      showAllDoneMessage: true,
    );
  }

  List<Widget> _buildUpcomingSection(BuildContext context) {
    return _buildScheduleSection(
      context,
      title: context.l10n.upcoming,
      statuses: [ScheduleStatus.upcoming],
    );
  }
}
