import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mona/controllers/medication_intake_manager.dart';
import 'package:mona/controllers/schedule_manager.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/date.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/l10n/build_context_extensions.dart';
import 'package:mona/l10n/helpers/administration_route_l10n.dart';
import 'package:mona/l10n/helpers/injection_side_l10n.dart';
import 'package:mona/l10n/helpers/molecule_l10n.dart';
import 'package:mona/ui/views/home/take_medication_page.dart';
import 'package:provider/provider.dart';

class IntakeTile extends StatelessWidget {
  const IntakeTile({
    super.key,
    required this.schedule,
    required this.status,
  });

  final MedicationSchedule schedule;
  final ScheduleStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final medicationIntakeProvider = context.watch<MedicationIntakeProvider>();
    final supplyItemProvider = context.watch<SupplyItemProvider>();
    final localizations = context.l10n;
    final now = DateTime.now();

    final viewModel = IntakeTileViewModel(
      schedule: schedule,
      status: status,
      intakeProvider: medicationIntakeProvider,
      supplyProvider: supplyItemProvider,
      now: now,
      theme: Theme.of(context),
      localizations: localizations,
      languageTag: context.languageTag,
    );

    final textColor =
        viewModel.isActive ? theme.colorScheme.onPrimaryContainer : null;

    return Card.filled(
      color: viewModel.isActive ? theme.colorScheme.primaryContainer : null,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (context) =>
                  TakeMedicationPage(schedule, DateTime.now()),
            ),
          );
        },
        child: ListTile(
          leading: viewModel.tileIcon,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.scheduledText,
                style: theme.textTheme.labelMedium?.copyWith(color: textColor),
              ),
              Text(
                schedule.name,
                style: theme.textTheme.titleMedium?.copyWith(color: textColor),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (status != ScheduleStatus.upcoming)
                Text(
                  viewModel.intakeInfo,
                  style: TextStyle(color: textColor),
                ),
              if (viewModel.warningText != null)
                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.error_outline,
                          size: 16,
                          color: textColor,
                        ),
                      ),
                      const TextSpan(text: " "),
                      TextSpan(
                        text: viewModel.warningText!,
                        style: TextStyle(color: textColor),
                      ),
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

class IntakeTileViewModel {
  IntakeTileViewModel(
      {required this.schedule,
      required this.status,
      required this.intakeProvider,
      required this.supplyProvider,
      required this.now,
      required this.theme,
      required this.localizations,
      required this.languageTag});

  final MedicationSchedule schedule;
  final ScheduleStatus status;
  final MedicationIntakeProvider intakeProvider;
  final SupplyItemProvider supplyProvider;
  final DateTime now;
  final ThemeData theme;
  final AppLocalizations localizations;
  final String languageTag;

  Date get nextScheduled => schedule.nextDate;

  Date? get lastScheduled => schedule.previousDate;

  Date? get lastTaken =>
      intakeProvider.getLastIntakeDateForSchedule(schedule.id);

  int get daysUntilIntake => nextScheduled.daysAwayFromToday;

  int? get daysSinceLastTaken => lastTaken?.daysAwayFromToday;

  int? get daysSinceLastScheduled => lastScheduled?.daysAwayFromToday;

  String get intakeInfo {
    final nextSide = MedicationIntakeManager(
      intakeProvider,
      supplyProvider,
    ).getNextSide();

    return "${schedule.dose} ${schedule.molecule.unit} • ${schedule.molecule.localizedNameWithEster(schedule.ester, localizations)} • "
        "${schedule.administrationRoute.localizedName(localizations)}"
        "${schedule.administrationRoute == AdministrationRoute.injection ? " • ${nextSide.localizedSummary(localizations)}" : ""}";
  }

  String get scheduledText {
    switch (status) {
      case ScheduleStatus.today:
      case ScheduleStatus.todayOverdue:
        return localizations.today;

      case ScheduleStatus.overdue:
        final formatted = lastScheduled!.format(DateFormat.MMMMd(languageTag));
        return "$formatted - ${localizations.daysAgoCount(daysSinceLastScheduled!)}";

      case ScheduleStatus.upcoming:
        final formatted = nextScheduled.format(DateFormat.MMMMd(languageTag));
        return "$formatted - ${localizations.inDaysCount(daysUntilIntake)}";

      case ScheduleStatus.taken:
        return localizations.taken;
    }
  }

  String? get warningText {
    switch (status) {
      case ScheduleStatus.today:
        if (lastTaken != null &&
            lastScheduled != null &&
            !lastTaken!.isSameDayAs(lastScheduled!)) {
          final formatted = lastTaken!.format(DateFormat.MMMd(languageTag));
          return "${localizations.lastTaken} ${localizations.daysAgoCount(daysSinceLastTaken!)} ($formatted)";
        }
        return null;

      case ScheduleStatus.upcoming:
      case ScheduleStatus.taken:
        return null;

      case ScheduleStatus.overdue:
      case ScheduleStatus.todayOverdue:
        if (lastTaken == null) {
          return localizations.neverTakenYet;
        }

        final formatted = lastTaken!.format(DateFormat.MMMd(languageTag));
        return "${localizations.lastTaken} ${localizations.daysAgoCount(daysSinceLastTaken!)} ($formatted)";
    }
  }

  bool get isActive =>
      status == ScheduleStatus.today ||
      status == ScheduleStatus.overdue ||
      status == ScheduleStatus.todayOverdue;

  Widget get tileIcon {
    if (status == ScheduleStatus.upcoming) {
      return CircleAvatar(
        backgroundColor: theme.colorScheme.secondary,
        child: Text(
          daysUntilIntake.toString(),
          style: TextStyle(
            color: theme.colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final icon = status == ScheduleStatus.today
        ? schedule.administrationRoute.icon
        : Symbols.schedule;

    return CircleAvatar(
      backgroundColor: theme.colorScheme.primary,
      child: Icon(
        icon,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }
}
