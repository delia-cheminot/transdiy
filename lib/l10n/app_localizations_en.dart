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
}
