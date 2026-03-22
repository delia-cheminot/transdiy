// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mona';

  @override
  String get profileTitle => 'Settings';

  @override
  String get intakesTitle => 'Intakes';

  @override
  String get levelsTitle => 'Levels';

  @override
  String get suppliesTitle => 'Supplies';

  @override
  String get empty_home => 'Start by adding a schedule in Settings';

  @override
  String get empty_intakes => 'Taken instakes will appear here';

  @override
  String get empty_levels => 'Estradiol injections will display in this tab';

  @override
  String get empty_supplies => 'No supplies. Add an item to get started.';

  @override
  String get nav_home => 'Mona';

  @override
  String get nav_intakes => 'Intakes';

  @override
  String get nav_levels => 'Levels';

  @override
  String get nav_supplies => 'Supplies';

  @override
  String get schedules => 'Schedules';

  @override
  String get noSchedules => 'No schedules';

  @override
  String schedulesCount(Object count) {
    return '$count created';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String notificationsEnabled(Object time) {
    return 'Enabled at $time';
  }

  @override
  String get notificationsDisabled => 'Disabled';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get settingsTitle => 'Settings';

  @override
  String schedulesCreated(Object count) {
    return '$count created';
  }

  @override
  String get english => 'English';

  @override
  String get french => 'Français';

  @override
  String get enableNotifications => 'Enable notifications';

  @override
  String get notificationsDisabledTitle => 'Notifications are disabled';

  @override
  String get clickToOpenSettings => 'Click to open settings';

  @override
  String get exactRemindersDisabled => 'Exact reminder times are disabled';

  @override
  String get remindersDelayed => 'Reminders may be slightly delayed. Tap to open settings.';

  @override
  String get autoUpdate => 'Auto-Update';

  @override
  String get autoUpdateDescription => 'Automatically check new updates when app is launched';

  @override
  String get checkForUpdates => 'Check for Updates';

  @override
  String get checkForUpdatesDescription => 'Check for the latest version manually\nThis will connect you to Internet\nNo data will be sent)';

  @override
  String appVersion(Object version) {
    return 'Mona version $version';
  }

  @override
  String get notificationsUpdated => 'Notifications have been updated!';

  @override
  String get notificationsUpdatedDescription => 'Each schedule now has its own notifications.\n\nPlease set up notifications for your schedules to make sure you don\'t miss anything.';

  @override
  String get dontShowAgain => 'Don\'t show again';

  @override
  String get scheduleSettings => 'Schedule settings';

  @override
  String get newItem => 'New item';

  @override
  String get name => 'Name';

  @override
  String get molecule => 'Molecule';

  @override
  String get adminRoute => 'Administration route';

  @override
  String get totalAmount => 'Total amount';

  @override
  String get concentration => 'Concentration';

  @override
  String get editItem => 'Edit item';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get usedAmount => 'Used amount';

  @override
  String get ester => 'Ester';

  @override
  String get deleteItem => 'Delete this item?';

  @override
  String remaining(Object amount, Object unit) {
    return '$amount $unit remaining';
  }

  @override
  String get injection => 'Injection';

  @override
  String get oral => 'Oral';

  @override
  String get sublingual => 'Sublingual';

  @override
  String get patch => 'Patch';

  @override
  String get gel => 'Gel';

  @override
  String get implant => 'Implant';

  @override
  String get suppository => 'Suppository';

  @override
  String get transdermal => 'Transdermal spray';

  @override
  String get chooseSchedule => 'Choose a schedule';

  @override
  String get addSchedulesFirst => 'Add schedules first.';

  @override
  String get editIntake => 'Edit intake';

  @override
  String get date => 'Date';

  @override
  String get amount => 'Amount';

  @override
  String get none => 'None';

  @override
  String get supplyItem => 'Supply item';

  @override
  String get injectionSide => 'Injection side';

  @override
  String get deleteIntake => 'Delete this intake?';
}
