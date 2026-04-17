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
  String get nav_home => 'Mona';

  @override
  String get nav_intakes => 'Intakes';

  @override
  String get nav_levels => 'Levels';

  @override
  String get nav_supplies => 'Supplies';

  @override
  String get takeAnIntake => 'Take an intake';

  @override
  String get addAnItem => 'Add an item';

  @override
  String get empty_home => 'Start by adding a schedule in Settings';

  @override
  String todaySection(Object date) {
    return 'Today - $date';
  }

  @override
  String get allDone => 'All done!';

  @override
  String get noIntakesDue => 'No intakes due today';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get today => 'Today';

  @override
  String get taken => 'taken';

  @override
  String get daysAgo => 'days ago';

  @override
  String get inText => 'in';

  @override
  String get lastTaken => 'Last taken';

  @override
  String get neverTakenYet => 'Never taken yet';

  @override
  String get scheduleFrequencyDaily => 'Every day';

  @override
  String scheduleFrequencyEveryNDays(Object days) {
    return 'Every $days days';
  }

  @override
  String get newUpdateAvailable => 'A new update is available!';

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get schedulesAndNotifications => 'Schedules & notifications';

  @override
  String get general => 'General';

  @override
  String get schedules => 'Schedules';

  @override
  String get noSchedules => 'No schedules';

  @override
  String schedulesCreated(Object count) {
    return '$count created';
  }

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get enableNotifications => 'Enable notifications';

  @override
  String get enableNotificationsDescription => 'Send reminders for schedules';

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
  String get checkForUpdatesDescription => 'Check for the latest version manually\nThis will connect you to Internet\n(No data will be sent)';

  @override
  String appVersion(Object version) {
    return 'Mona version $version';
  }

  @override
  String backupSavedTo(Object path) {
    return 'Backup saved to: $path';
  }

  @override
  String exportFailed(Object error) {
    return 'Failed to export: $error';
  }

  @override
  String get importDataTitle => 'Import Data';

  @override
  String get importDataSubtitle => 'Restore data from a JSON backup';

  @override
  String get importDataOverwriteWarning => 'This will overwrite all your current data with the backup. This action cannot be undone. Do you want to continue?';

  @override
  String get importConfirm => 'Import';

  @override
  String get importSuccessfulTitle => 'Import Successful';

  @override
  String get importRestartRequired => 'Please restart the app to apply the restored data.';

  @override
  String get closeApp => 'Close App';

  @override
  String importFailed(Object error) {
    return 'Failed to import: $error';
  }

  @override
  String get updates => 'Updates';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get exportDataTitle => 'Export Data';

  @override
  String get exportDataSubtitle => 'Save your data to a JSON file';

  @override
  String get updateNoCompatibleApk => 'No compatible update found for your device.';

  @override
  String get updateAppUpToDate => 'Your app is up to date!';

  @override
  String get updateCheckNetworkError => 'Could not check for updates right now.';

  @override
  String get updateDialogTitle => 'Update Available';

  @override
  String updateDialogBody(Object current, Object latest) {
    return 'Version $latest is available! (Current: $current)\n\nAn update compatible with your device is ready to be installed.';
  }

  @override
  String get updateDownloadAndInstall => 'Download & Install';

  @override
  String get updateInstallPermissionRequired => 'Permission is required to install updates.';

  @override
  String get updateDownloadingTitle => 'Downloading Update...';

  @override
  String updateFailedOpenInstaller(Object message) {
    return 'Failed to open installer: $message';
  }

  @override
  String get updateDownloadFailed => 'Download failed. Please check your connection.';

  @override
  String get addSchedule => 'Add a schedule';

  @override
  String get addScheduleToGetStarted => 'Add a schedule to get started.';

  @override
  String get newSchedule => 'New schedule';

  @override
  String get every => 'Every';

  @override
  String get days => 'days';

  @override
  String get startDate => 'Start date';

  @override
  String get editScheduleInfo => 'Edit schedule info';

  @override
  String get noNotifications => 'No notifications';

  @override
  String notificationsCount(Object count) {
    return '$count notifications';
  }

  @override
  String get editSchedule => 'Edit schedule';

  @override
  String deleteSchedule(Object name) {
    return 'Delete $name?';
  }

  @override
  String get scheduleNotifications => 'Schedule notifications';

  @override
  String get addNotification => 'Add a notification';

  @override
  String noNotificationsForSchedule(Object scheduleName) {
    return 'No notifications for $scheduleName. You can add one using the Add button.';
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
  String get empty_intakes => 'Taken instakes will appear here';

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

  @override
  String takeMedication(Object scheduleName) {
    return 'Take $scheduleName';
  }

  @override
  String get takeIntake => 'Take intake';

  @override
  String get needleDeadSpace => 'Needle dead space';

  @override
  String get microliters => 'μL';

  @override
  String get empty_levels => 'Estradiol injections will display in this tab';

  @override
  String get bloodTestsTitle => 'Blood Tests';

  @override
  String get empty_blood_tests => 'Taken blood tests will appear here. Start by using the Add button!';

  @override
  String get addBloodTest => 'Add a blood test';

  @override
  String get editBloodTest => 'Edit blood test';

  @override
  String get newBloodTest => 'New blood test';

  @override
  String get estradiolLevelLabel => 'Estradiol level';

  @override
  String get testosteroneLevelLabel => 'Testosterone level';

  @override
  String get bloodTestDateLabel => 'Test date';

  @override
  String chartNowConcentration(Object value) {
    return 'Now $value';
  }

  @override
  String chartBloodTestLevelTooltip(Object date, Object level) {
    return '$date: $level';
  }

  @override
  String get empty_supplies => 'No supplies. Add an item to get started.';

  @override
  String get newItem => 'New item';

  @override
  String get adminRoute => 'Administration route';

  @override
  String get totalAmount => 'Total amount';

  @override
  String get concentration => 'Concentration';

  @override
  String get editItem => 'Edit item';

  @override
  String get usedAmount => 'Used amount';

  @override
  String deleteItem(Object name) {
    return 'Delete $name?';
  }

  @override
  String remaining(Object amount, Object unit) {
    return '$amount $unit remaining';
  }

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get next => 'Next';

  @override
  String get delete => 'Delete';

  @override
  String get deleteElement => 'Delete this item?';

  @override
  String get irreversibleAction => 'This action can\'t be undone.';

  @override
  String get name => 'Name';

  @override
  String get molecule => 'Molecule';

  @override
  String get ester => 'Ester';

  @override
  String get estradiol => 'Estradiol';

  @override
  String get progesterone => 'Progesterone';

  @override
  String get testosterone => 'Testosterone';

  @override
  String get nandrolone => 'Nandrolone';

  @override
  String get spironolactone => 'Spironolactone';

  @override
  String get cyproteroneAcetate => 'Cyproterone acetate';

  @override
  String get leuprorelinAcetate => 'Leuprorelin acetate';

  @override
  String get bicalutamide => 'Bicalutamide';

  @override
  String get decapeptyl => 'Decapeptyl';

  @override
  String get raloxifene => 'Raloxifene';

  @override
  String get tamoxifen => 'Tamoxifen';

  @override
  String get finasteride => 'Finasteride';

  @override
  String get dutasteride => 'Dutasteride';

  @override
  String get minoxidil => 'Minoxidil';

  @override
  String get pioglitazone => 'Pioglitazone';

  @override
  String get enanthate => 'Enanthate';

  @override
  String get valerate => 'Valerate';

  @override
  String get cypionate => 'Cypionate';

  @override
  String get undecylate => 'Undecylate';

  @override
  String get benzoate => 'Benzoate';

  @override
  String get cypionateSuspension => 'Cypionate suspension';

  @override
  String get medicationEstradiolEnanthate => 'Estradiol enanthate';

  @override
  String get medicationEstradiolValerate => 'Estradiol valerate';

  @override
  String get medicationEstradiolCypionate => 'Estradiol cypionate';

  @override
  String get medicationEstradiolUndecylate => 'Estradiol undecylate';

  @override
  String get medicationEstradiolBenzoate => 'Estradiol benzoate';

  @override
  String get medicationEstradiolCypionateSuspension => 'Estradiol cypionate suspension';

  @override
  String get medicationTestosteroneEnanthate => 'Testosterone enanthate';

  @override
  String get medicationTestosteroneValerate => 'Testosterone valerate';

  @override
  String get medicationTestosteroneCypionate => 'Testosterone cypionate';

  @override
  String get medicationTestosteroneUndecylate => 'Testosterone undecylate';

  @override
  String get medicationTestosteroneBenzoate => 'Testosterone benzoate';

  @override
  String get medicationTestosteroneCypionateSuspension => 'Testosterone cypionate suspension';

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
  String get injectionSideLeft => 'Left';

  @override
  String get injectionSideRight => 'Right';

  @override
  String get intakeSummaryInjectionSideLeft => 'Left side';

  @override
  String get intakeSummaryInjectionSideRight => 'Right side';
}
