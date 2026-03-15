import 'package:flutter/material.dart';
import 'package:mona/data/providers/locale_provider.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:mona/ui/views/home/profile/notifications_page.dart';
import 'package:mona/ui/views/home/profile/schedules_page.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationScheduleProvider =
        context.watch<MedicationScheduleProvider>();
    final preferencesService = context.watch<PreferencesService>();
    final localeProvider = context.watch<LocaleProvider>();
    final localizations = AppLocalizations.of(context)!;

    if (medicationScheduleProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(localizations.profileTitle)),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(localizations.profileTitle)),
      body: ListView(
        children: [
          ListTile(
            title: Text(localizations.schedules),
            subtitle: Text(
              medicationScheduleProvider.schedules.isEmpty
                  ? localizations.noSchedules
                  : '${medicationScheduleProvider.schedules.length} ${localizations.schedulesCount}',
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => SchedulesPage()),
              );
            },
          ),
          ListTile(
            title: Text(localizations.notifications),
            subtitle: Text(
              preferencesService.notificationsEnabled
                  ? '${localizations.notificationsEnabled} at ${preferencesService.notificationTime.format(context)}'
                  : localizations.notificationsDisabled,
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const NotificationsPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(localizations.language),
            subtitle: Text(localeProvider.locale.languageCode == 'en'
                ? 'English'
                : 'Français'),
            trailing: Icon(Icons.chevron_right),
            onTap: () =>
                _showLanguageDialog(context, localeProvider, localizations),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LocaleProvider provider,
      AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('English'),
              onTap: () {
                provider.setLocale(const Locale('en'));
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Français'),
              onTap: () {
                provider.setLocale(const Locale('fr'));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
