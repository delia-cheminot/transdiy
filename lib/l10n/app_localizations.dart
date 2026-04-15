import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('pt', 'BR')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Mona'**
  String get appTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileTitle;

  /// No description provided for @intakesTitle.
  ///
  /// In en, this message translates to:
  /// **'Intakes'**
  String get intakesTitle;

  /// No description provided for @levelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Levels'**
  String get levelsTitle;

  /// No description provided for @suppliesTitle.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get suppliesTitle;

  /// No description provided for @empty_home.
  ///
  /// In en, this message translates to:
  /// **'Start by adding a schedule in Settings'**
  String get empty_home;

  /// No description provided for @empty_intakes.
  ///
  /// In en, this message translates to:
  /// **'Taken instakes will appear here'**
  String get empty_intakes;

  /// No description provided for @empty_levels.
  ///
  /// In en, this message translates to:
  /// **'Estradiol injections will display in this tab'**
  String get empty_levels;

  /// No description provided for @empty_supplies.
  ///
  /// In en, this message translates to:
  /// **'No supplies. Add an item to get started.'**
  String get empty_supplies;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Mona'**
  String get nav_home;

  /// No description provided for @nav_intakes.
  ///
  /// In en, this message translates to:
  /// **'Intakes'**
  String get nav_intakes;

  /// No description provided for @nav_levels.
  ///
  /// In en, this message translates to:
  /// **'Levels'**
  String get nav_levels;

  /// No description provided for @nav_supplies.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get nav_supplies;

  /// No description provided for @schedules.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get schedules;

  /// No description provided for @noSchedules.
  ///
  /// In en, this message translates to:
  /// **'No schedules'**
  String get noSchedules;

  /// No description provided for @schedulesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} created'**
  String schedulesCount(Object count);

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled at {time}'**
  String notificationsEnabled(Object time);

  /// No description provided for @notificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get notificationsDisabled;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @schedulesCreated.
  ///
  /// In en, this message translates to:
  /// **'{count} created'**
  String schedulesCreated(Object count);

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get enableNotifications;

  /// No description provided for @notificationsDisabledTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications are disabled'**
  String get notificationsDisabledTitle;

  /// No description provided for @clickToOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Click to open settings'**
  String get clickToOpenSettings;

  /// No description provided for @exactRemindersDisabled.
  ///
  /// In en, this message translates to:
  /// **'Exact reminder times are disabled'**
  String get exactRemindersDisabled;

  /// No description provided for @remindersDelayed.
  ///
  /// In en, this message translates to:
  /// **'Reminders may be slightly delayed. Tap to open settings.'**
  String get remindersDelayed;

  /// No description provided for @autoUpdate.
  ///
  /// In en, this message translates to:
  /// **'Auto-Update'**
  String get autoUpdate;

  /// No description provided for @autoUpdateDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically check new updates when app is launched'**
  String get autoUpdateDescription;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get checkForUpdates;

  /// No description provided for @checkForUpdatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Check for the latest version manually\nThis will connect you to Internet\n(No data will be sent)'**
  String get checkForUpdatesDescription;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Mona version {version}'**
  String appVersion(Object version);

  /// No description provided for @notificationsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Notifications have been updated!'**
  String get notificationsUpdated;

  /// No description provided for @notificationsUpdatedDescription.
  ///
  /// In en, this message translates to:
  /// **'Each schedule now has its own notifications.\n\nPlease set up notifications for your schedules to make sure you don\'t miss anything.'**
  String get notificationsUpdatedDescription;

  /// No description provided for @dontShowAgain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get dontShowAgain;

  /// No description provided for @scheduleSettings.
  ///
  /// In en, this message translates to:
  /// **'Schedule settings'**
  String get scheduleSettings;

  /// No description provided for @newItem.
  ///
  /// In en, this message translates to:
  /// **'New item'**
  String get newItem;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @molecule.
  ///
  /// In en, this message translates to:
  /// **'Molecule'**
  String get molecule;

  /// No description provided for @adminRoute.
  ///
  /// In en, this message translates to:
  /// **'Administration route'**
  String get adminRoute;

  /// No description provided for @estradiol.
  ///
  /// In en, this message translates to:
  /// **'Estradiol'**
  String get estradiol;

  /// No description provided for @progesterone.
  ///
  /// In en, this message translates to:
  /// **'Progesterone'**
  String get progesterone;

  /// No description provided for @testosterone.
  ///
  /// In en, this message translates to:
  /// **'Testosterone'**
  String get testosterone;

  /// No description provided for @nandrolone.
  ///
  /// In en, this message translates to:
  /// **'Nandrolone'**
  String get nandrolone;

  /// No description provided for @spironolactone.
  ///
  /// In en, this message translates to:
  /// **'Spironolactone'**
  String get spironolactone;

  /// No description provided for @cyproteroneAcetate.
  ///
  /// In en, this message translates to:
  /// **'Cyproterone acetate'**
  String get cyproteroneAcetate;

  /// No description provided for @leuprorelinAcetate.
  ///
  /// In en, this message translates to:
  /// **'Leuprorelin acetate'**
  String get leuprorelinAcetate;

  /// No description provided for @bicalutamide.
  ///
  /// In en, this message translates to:
  /// **'Bicalutamide'**
  String get bicalutamide;

  /// No description provided for @decapeptyl.
  ///
  /// In en, this message translates to:
  /// **'Decapeptyl'**
  String get decapeptyl;

  /// No description provided for @raloxifene.
  ///
  /// In en, this message translates to:
  /// **'Raloxifene'**
  String get raloxifene;

  /// No description provided for @tamoxifen.
  ///
  /// In en, this message translates to:
  /// **'Tamoxifen'**
  String get tamoxifen;

  /// No description provided for @finasteride.
  ///
  /// In en, this message translates to:
  /// **'Finasteride'**
  String get finasteride;

  /// No description provided for @dutasteride.
  ///
  /// In en, this message translates to:
  /// **'Dutasteride'**
  String get dutasteride;

  /// No description provided for @minoxidil.
  ///
  /// In en, this message translates to:
  /// **'Minoxidil'**
  String get minoxidil;

  /// No description provided for @pioglitazone.
  ///
  /// In en, this message translates to:
  /// **'Pioglitazone'**
  String get pioglitazone;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get totalAmount;

  /// No description provided for @concentration.
  ///
  /// In en, this message translates to:
  /// **'Concentration'**
  String get concentration;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get editItem;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @usedAmount.
  ///
  /// In en, this message translates to:
  /// **'Used amount'**
  String get usedAmount;

  /// No description provided for @ester.
  ///
  /// In en, this message translates to:
  /// **'Ester'**
  String get ester;

  /// No description provided for @deleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete this item?'**
  String get deleteItem;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'{amount} {unit} remaining'**
  String remaining(Object amount, Object unit);

  /// No description provided for @injection.
  ///
  /// In en, this message translates to:
  /// **'Injection'**
  String get injection;

  /// No description provided for @oral.
  ///
  /// In en, this message translates to:
  /// **'Oral'**
  String get oral;

  /// No description provided for @sublingual.
  ///
  /// In en, this message translates to:
  /// **'Sublingual'**
  String get sublingual;

  /// No description provided for @patch.
  ///
  /// In en, this message translates to:
  /// **'Patch'**
  String get patch;

  /// No description provided for @gel.
  ///
  /// In en, this message translates to:
  /// **'Gel'**
  String get gel;

  /// No description provided for @implant.
  ///
  /// In en, this message translates to:
  /// **'Implant'**
  String get implant;

  /// No description provided for @suppository.
  ///
  /// In en, this message translates to:
  /// **'Suppository'**
  String get suppository;

  /// No description provided for @transdermal.
  ///
  /// In en, this message translates to:
  /// **'Transdermal spray'**
  String get transdermal;

  /// No description provided for @chooseSchedule.
  ///
  /// In en, this message translates to:
  /// **'Choose a schedule'**
  String get chooseSchedule;

  /// No description provided for @addSchedulesFirst.
  ///
  /// In en, this message translates to:
  /// **'Add schedules first.'**
  String get addSchedulesFirst;

  /// No description provided for @editIntake.
  ///
  /// In en, this message translates to:
  /// **'Edit intake'**
  String get editIntake;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @supplyItem.
  ///
  /// In en, this message translates to:
  /// **'Supply item'**
  String get supplyItem;

  /// No description provided for @injectionSide.
  ///
  /// In en, this message translates to:
  /// **'Injection side'**
  String get injectionSide;

  /// No description provided for @deleteIntake.
  ///
  /// In en, this message translates to:
  /// **'Delete this intake?'**
  String get deleteIntake;

  /// No description provided for @todaySection.
  ///
  /// In en, this message translates to:
  /// **'Today - {date}'**
  String todaySection(Object date);

  /// No description provided for @allDone.
  ///
  /// In en, this message translates to:
  /// **'All done!'**
  String get allDone;

  /// No description provided for @noIntakesDue.
  ///
  /// In en, this message translates to:
  /// **'No intakes due today'**
  String get noIntakesDue;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @takeMedication.
  ///
  /// In en, this message translates to:
  /// **'Take {scheduleName}'**
  String takeMedication(Object scheduleName);

  /// No description provided for @takeIntake.
  ///
  /// In en, this message translates to:
  /// **'Take intake'**
  String get takeIntake;

  /// No description provided for @needleDeadSpace.
  ///
  /// In en, this message translates to:
  /// **'Needle dead space'**
  String get needleDeadSpace;

  /// No description provided for @microliters.
  ///
  /// In en, this message translates to:
  /// **'μL'**
  String get microliters;

  /// No description provided for @addSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add a schedule'**
  String get addSchedule;

  /// No description provided for @addScheduleToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Add a schedule to get started.'**
  String get addScheduleToGetStarted;

  /// No description provided for @newSchedule.
  ///
  /// In en, this message translates to:
  /// **'New schedule'**
  String get newSchedule;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @every.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get every;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @editScheduleInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit schedule info'**
  String get editScheduleInfo;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @notificationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} notifications'**
  String notificationsCount(Object count);

  /// No description provided for @editSchedule.
  ///
  /// In en, this message translates to:
  /// **'Edit schedule'**
  String get editSchedule;

  /// No description provided for @deleteSchedule.
  ///
  /// In en, this message translates to:
  /// **'Delete this schedule?'**
  String get deleteSchedule;

  /// No description provided for @scheduleNotifications.
  ///
  /// In en, this message translates to:
  /// **'Schedule notifications'**
  String get scheduleNotifications;

  /// No description provided for @addNotification.
  ///
  /// In en, this message translates to:
  /// **'Add a notification'**
  String get addNotification;

  /// No description provided for @noNotificationsForSchedule.
  ///
  /// In en, this message translates to:
  /// **'No notifications for {scheduleName}. You can add one using the Add button.'**
  String noNotificationsForSchedule(Object scheduleName);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @taken.
  ///
  /// In en, this message translates to:
  /// **'taken'**
  String get taken;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get daysAgo;

  /// No description provided for @inText.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get inText;

  /// No description provided for @lastTaken.
  ///
  /// In en, this message translates to:
  /// **'Last taken'**
  String get lastTaken;

  /// No description provided for @neverTakenYet.
  ///
  /// In en, this message translates to:
  /// **'Never taken yet'**
  String get neverTakenYet;

  /// No description provided for @side.
  ///
  /// In en, this message translates to:
  /// **'side'**
  String get side;

  /// No description provided for @enanthate.
  ///
  /// In en, this message translates to:
  /// **'Enanthate'**
  String get enanthate;

  /// No description provided for @valerate.
  ///
  /// In en, this message translates to:
  /// **'Valerate'**
  String get valerate;

  /// No description provided for @cypionate.
  ///
  /// In en, this message translates to:
  /// **'Cypionate'**
  String get cypionate;

  /// No description provided for @undecylate.
  ///
  /// In en, this message translates to:
  /// **'Undecylate'**
  String get undecylate;

  /// No description provided for @benzoate.
  ///
  /// In en, this message translates to:
  /// **'Benzoate'**
  String get benzoate;

  /// No description provided for @cypionateSuspension.
  ///
  /// In en, this message translates to:
  /// **'Cypionate suspension'**
  String get cypionateSuspension;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt': {
  switch (locale.countryCode) {
    case 'BR': return AppLocalizationsPtBr();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
