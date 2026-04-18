import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mona/controllers/schedule_manager.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/ui/constants/dimensions.dart';
import 'package:mona/ui/views/home/intake_tile.dart';
import 'package:mona/ui/widgets/main_page_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _monaAppStoreListingUri = Uri.parse(
  'https://apps.apple.com/app/mona-hrt-journal/id6757274628',
);

Future<void> _openMonaAppStoreListing(BuildContext context) async {
  final launched = await launchUrl(
    _monaAppStoreListingUri,
    mode: LaunchMode.externalApplication,
  );
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
              'Could not open. You can manually search for "Mona HRT" on the App Store.')),
    );
  }
}

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
      emptyMessage: 'Start by adding a schedule in Settings',
      child: SingleChildScrollView(
        child: Padding(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._buildUpdateSection(context),
              ..._buildTodaySection(context),
              ..._buildUpcomingSection(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildUpdateSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final end = DateTime(2026, 7, 17);
    final now = DateTime.now();
    final difference = end.difference(now).inDays;
    return [
      Card.filled(
        color: colorScheme.errorContainer,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _openMonaAppStoreListing(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.error,
                  child: Icon(
                    Symbols.warning,
                    color: theme.colorScheme.onError,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Important update',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Update Mona on the App Store to continue using the app.\n'
                        'This TestFlight version will expire in $difference days.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed: () => _openMonaAppStoreListing(context),
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.error,
                            foregroundColor: colorScheme.onError,
                          ),
                          child: const Text('Update'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ];
  }

  List<Widget> _buildScheduleSection(
    BuildContext context, {
    required String title,
    required List<ScheduleStatus> statuses,
    bool showAllDoneMessage = false,
  }) {
    final theme = Theme.of(context);
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
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.tertiary,
              child: Icon(
                Symbols.check,
                color: theme.colorScheme.onTertiary,
              ),
            ),
            title: Text("All done !", style: theme.textTheme.titleMedium),
            subtitle: Text("No intakes due today"),
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

  List<Widget> _buildTodaySection(BuildContext context) =>
      _buildScheduleSection(
        context,
        title: "Today - ${DateFormat.MMMMd().format(DateTime.now())}",
        statuses: [
          ScheduleStatus.overdue,
          ScheduleStatus.todayOverdue,
          ScheduleStatus.today
        ],
        showAllDoneMessage: true,
      );

  List<Widget> _buildUpcomingSection(BuildContext context) =>
      _buildScheduleSection(
        context,
        title: "Upcoming",
        statuses: [ScheduleStatus.upcoming],
      );
}
