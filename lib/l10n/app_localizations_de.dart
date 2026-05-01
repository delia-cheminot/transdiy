// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Mona';

  @override
  String get nav_home => 'Mona';

  @override
  String get nav_intakes => 'Einnahmen';

  @override
  String get nav_levels => 'Werte';

  @override
  String get nav_supplies => 'Vorräte';

  @override
  String get takeAnIntake => 'Eine Einnahme erfassen';

  @override
  String get addAnItem => 'Eintrag hinzufügen';

  @override
  String get empty_home =>
      'Beginne, indem du einen Zeitplan in den Einstellungen erstellst';

  @override
  String get allDone => 'Alles erledigt!';

  @override
  String get noIntakesDue => 'Heute sind keine Einnahmen fällig';

  @override
  String get upcoming => 'Bevorstehend';

  @override
  String get today => 'Heute';

  @override
  String get taken => 'genommen';

  @override
  String daysAgoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Tagen',
      one: 'gestern',
    );
    return '$_temp0';
  }

  @override
  String inDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count Tagen',
      one: 'morgen',
    );
    return '$_temp0';
  }

  @override
  String get lastTaken => 'Zuletzt genommen';

  @override
  String get neverTakenYet => 'Noch nie genommen';

  @override
  String get scheduleFrequencyDaily => 'Täglich';

  @override
  String scheduleFrequencyEveryNDays(num days) {
    return 'Alle $days Tage';
  }

  @override
  String get newUpdateAvailable => 'Ein neues Update ist verfügbar!';

  @override
  String get goToSettings => 'Zu den Einstellungen';

  @override
  String get deprecated => 'Veraltet';

  @override
  String get legacyVersionMessage =>
      'Du verwendest eine veraltete Version von Mona. Bitte aktualisiere sie. Tippe für mehr Informationen.';

  @override
  String get legacyDeprecationIntro =>
      'Diese Version von Mona ist veraltet. Um Mona weiter nutzen zu können und Updates zu erhalten, installiere bitte die neue Version, indem du die folgenden Schritte befolgst.';

  @override
  String get legacyStep1Title => 'Daten exportieren';

  @override
  String get legacyStep1Description =>
      'Tippe in den Einstellungen auf \'Daten exportieren\', um ein JSON-Backup deiner Daten zu speichern.';

  @override
  String get legacyStep2Title => 'Neue Version herunterladen';

  @override
  String get legacyStep2Description =>
      'Lade Mona aus dem Play Store herunter. Oder lade aus dem neuesten Release auf GitHub die Datei mit dem Namen mona-<version>.apk herunter.';

  @override
  String get legacyStep3Title => 'Diese Version deinstallieren';

  @override
  String get legacyStep3Description =>
      'Entferne diese App von deinem Gerät. Deine Backup-Datei bleibt erhalten.';

  @override
  String get legacyStep4Title => 'Neue APK installieren';

  @override
  String get legacyStep4Description =>
      'Öffne die heruntergeladene APK-Datei und folge den Anweisungen von Android, um sie zu installieren.';

  @override
  String get legacyStep5Title => 'Daten importieren';

  @override
  String get legacyStep5Description =>
      'Öffne das neue Mona, gehe zu den Einstellungen und tippe auf \'Daten importieren\', um dein Backup wiederherzustellen.';

  @override
  String get openLatestRelease => 'Auf GitHub anzeigen';

  @override
  String get openPlayStore => 'Im Play Store anzeigen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get schedulesAndNotifications => 'Zeitpläne und Benachrichtigungen';

  @override
  String get general => 'Allgemein';

  @override
  String get schedules => 'Zeitpläne';

  @override
  String get noSchedules => 'Keine Zeitpläne';

  @override
  String schedulesCreated(num count) {
    return '$count erstellt';
  }

  @override
  String get language => 'Sprache';

  @override
  String get languageFollowDevice => 'Gerätesprache verwenden';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get enableNotifications => 'Benachrichtigungen aktivieren';

  @override
  String get enableNotificationsDescription =>
      'Erinnerungen für Zeitpläne senden';

  @override
  String get notificationsDisabledTitle =>
      'Benachrichtigungen sind deaktiviert';

  @override
  String get clickToOpenSettings => 'Tippe, um die Einstellungen zu öffnen';

  @override
  String get exactRemindersDisabled =>
      'Exakte Erinnerungszeiten sind deaktiviert';

  @override
  String get remindersDelayed =>
      'Erinnerungen können sich leicht verzögern. Tippe, um die Einstellungen zu öffnen.';

  @override
  String get autoUpdate => 'Automatische Updates';

  @override
  String get autoUpdateDescription =>
      'Beim Start der App automatisch nach Updates suchen';

  @override
  String get checkForUpdates => 'Nach Updates suchen';

  @override
  String get checkForUpdatesDescription =>
      'Manuell nach der neuesten Version suchen\nDies stellt eine Internetverbindung her\n(Es werden keine Daten gesendet)';

  @override
  String appVersion(Object version) {
    return 'Mona Version $version';
  }

  @override
  String backupSavedTo(Object path) {
    return 'Backup gespeichert unter: $path';
  }

  @override
  String exportFailed(Object error) {
    return 'Export fehlgeschlagen: $error';
  }

  @override
  String get importDataTitle => 'Daten importieren';

  @override
  String get importDataSubtitle =>
      'Daten aus einer JSON-Sicherung wiederherstellen';

  @override
  String get importDataOverwriteWarning =>
      'Dadurch werden alle aktuellen Daten durch das Backup überschrieben. Diese Aktion kann nicht rückgängig gemacht werden. Möchtest du fortfahren?';

  @override
  String get importConfirm => 'Importieren';

  @override
  String get importSuccessfulTitle => 'Import erfolgreich';

  @override
  String get importRestartRequired =>
      'Bitte starte die App neu, um die wiederhergestellten Daten zu übernehmen.';

  @override
  String get closeApp => 'App schließen';

  @override
  String importFailed(Object error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String get updates => 'Aktualisierungen';

  @override
  String get dataManagement => 'Datenverwaltung';

  @override
  String get exportDataTitle => 'Daten exportieren';

  @override
  String get exportDataSubtitle => 'Daten in einer JSON-Datei speichern';

  @override
  String get updateNoCompatibleApk =>
      'Keine kompatible Aktualisierung für dein Gerät gefunden.';

  @override
  String get updateAppUpToDate => 'Deine App ist auf dem neuesten Stand!';

  @override
  String get updateCheckNetworkError =>
      'Aktualisierungen konnten gerade nicht geprüft werden.';

  @override
  String get updateDialogTitle => 'Aktualisierung verfügbar';

  @override
  String updateDialogBody(Object current, Object latest) {
    return 'Version $latest ist verfügbar! (Aktuell: $current)\n\nEine mit deinem Gerät kompatible Aktualisierung kann installiert werden.';
  }

  @override
  String get updateDownloadAndInstall => 'Herunterladen & installieren';

  @override
  String get updateInstallPermissionRequired =>
      'Zum Installieren von Aktualisierungen ist eine Berechtigung erforderlich.';

  @override
  String get updateDownloadingTitle => 'Aktualisierung wird heruntergeladen …';

  @override
  String updateFailedOpenInstaller(Object message) {
    return 'Installer konnte nicht geöffnet werden: $message';
  }

  @override
  String get updateDownloadFailed =>
      'Download fehlgeschlagen. Bitte prüfe deine Verbindung.';

  @override
  String notificationMedicationReminderTitle(Object scheduleName) {
    return 'Zeit, $scheduleName einzunehmen';
  }

  @override
  String notificationMedicationReminderBody(Object dateTime) {
    return 'Geplant für $dateTime';
  }

  @override
  String get addSchedule => 'Zeitplan hinzufügen';

  @override
  String get addScheduleToGetStarted =>
      'Füge einen Zeitplan hinzu, um zu beginnen.';

  @override
  String get newSchedule => 'Neuer Zeitplan';

  @override
  String get every => 'Alle';

  @override
  String get days => 'Tage';

  @override
  String get startDate => 'Startdatum';

  @override
  String get editScheduleInfo => 'Zeitplan bearbeiten';

  @override
  String get noNotifications => 'Keine Benachrichtigungen';

  @override
  String notificationsCount(num count) {
    return '$count Benachrichtigungen';
  }

  @override
  String get editSchedule => 'Zeitplan bearbeiten';

  @override
  String deleteSchedule(Object name) {
    return '$name löschen?';
  }

  @override
  String get scheduleNotifications => 'Benachrichtigungen für Zeitplan';

  @override
  String get addNotification => 'Benachrichtigung hinzufügen';

  @override
  String noNotificationsForSchedule(Object scheduleName) {
    return 'Keine Benachrichtigungen für $scheduleName. Du kannst eine über die Schaltfläche „Hinzufügen“ erstellen.';
  }

  @override
  String get notificationsUpdated => 'Benachrichtigungen wurden aktualisiert!';

  @override
  String get notificationsUpdatedDescription =>
      'Jeder Zeitplan hat jetzt eigene Benachrichtigungen.\n\nBitte richte Benachrichtigungen für deine Zeitpläne ein, damit du nichts verpasst.';

  @override
  String get dontShowAgain => 'Nicht mehr anzeigen';

  @override
  String get scheduleSettings => 'Zeitplan-Einstellungen';

  @override
  String get empty_intakes => 'Erfasste Einnahmen werden hier angezeigt';

  @override
  String get chooseSchedule => 'Zeitplan auswählen';

  @override
  String get addSchedulesFirst => 'Erstelle zuerst Zeitpläne.';

  @override
  String get editIntake => 'Einnahme bearbeiten';

  @override
  String get date => 'Datum';

  @override
  String get amount => 'Menge';

  @override
  String get none => 'Keine';

  @override
  String get supplyItem => 'Vorratselement';

  @override
  String get injectionSide => 'Injektionsseite';

  @override
  String get deleteIntake => 'Diese Einnahme löschen?';

  @override
  String takeMedication(Object scheduleName) {
    return '$scheduleName einnehmen';
  }

  @override
  String get takeIntake => 'Einnahme erfassen';

  @override
  String get needleDeadSpace => 'Totraum der Nadel';

  @override
  String get microliters => 'μL';

  @override
  String get empty_levels =>
      'Estradiol-Injektionen werden in diesem Tab angezeigt';

  @override
  String get bloodTestsTitle => 'Bluttests';

  @override
  String get empty_blood_tests =>
      'Erfasste Bluttests werden hier angezeigt. Starte mit der Schaltfläche „Hinzufügen“!';

  @override
  String get addBloodTest => 'Bluttest hinzufügen';

  @override
  String get editBloodTest => 'Bluttest bearbeiten';

  @override
  String get newBloodTest => 'Neuer Bluttest';

  @override
  String get deleteBloodTest => 'Diesen Bluttest löschen?';

  @override
  String get estradiolLevelLabel => 'Östradiolspiegel';

  @override
  String get testosteroneLevelLabel => 'Testosteronspiegel';

  @override
  String get bloodTestDateLabel => 'Testdatum';

  @override
  String chartNowConcentration(Object value) {
    return 'Jetzt $value';
  }

  @override
  String chartBloodTestLevelTooltip(Object date, Object level) {
    return '$date: $level';
  }

  @override
  String get empty_supplies =>
      'Keine Vorräte. Füge einen Eintrag hinzu, um zu beginnen.';

  @override
  String get newItem => 'Neuer Eintrag';

  @override
  String get adminRoute => 'Anwendungsart';

  @override
  String get totalAmount => 'Gesamtmenge';

  @override
  String get concentration => 'Konzentration';

  @override
  String get editItem => 'Eintrag bearbeiten';

  @override
  String get usedAmount => 'Verwendete Menge';

  @override
  String deleteItem(Object name) {
    return '$name löschen?';
  }

  @override
  String remaining(num amount, Object unit) {
    return '$amount $unit verbleibend';
  }

  @override
  String get add => 'Hinzufügen';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get next => 'Weiter';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteElement => 'Diesen Eintrag löschen?';

  @override
  String get irreversibleAction =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get name => 'Name';

  @override
  String get molecule => 'Wirkstoff';

  @override
  String get ester => 'Ester';

  @override
  String get estradiol => 'Estradiol';

  @override
  String get progesterone => 'Progesteron';

  @override
  String get testosterone => 'Testosteron';

  @override
  String get nandrolone => 'Nandrolon';

  @override
  String get spironolactone => 'Spironolacton';

  @override
  String get cyproteroneAcetate => 'Cyproteronacetat';

  @override
  String get leuprorelinAcetate => 'Leuprorelinacetat';

  @override
  String get bicalutamide => 'Bicalutamid';

  @override
  String get decapeptyl => 'Decapeptyl';

  @override
  String get raloxifene => 'Raloxifen';

  @override
  String get tamoxifen => 'Tamoxifen';

  @override
  String get finasteride => 'Finasterid';

  @override
  String get dutasteride => 'Dutasterid';

  @override
  String get minoxidil => 'Minoxidil';

  @override
  String get pioglitazone => 'Pioglitazon';

  @override
  String get enanthate => 'Enanthat';

  @override
  String get valerate => 'Valerat';

  @override
  String get cypionate => 'Cypionat';

  @override
  String get undecylate => 'Undecylat';

  @override
  String get benzoate => 'Benzoat';

  @override
  String get cypionateSuspension => 'Cypionat-Suspension';

  @override
  String get medicationEstradiolEnanthate => 'Estradiolenantat';

  @override
  String get medicationEstradiolValerate => 'Estradiolvalerat';

  @override
  String get medicationEstradiolCypionate => 'Estradiolcypionat';

  @override
  String get medicationEstradiolUndecylate => 'Estradiolundecylat';

  @override
  String get medicationEstradiolBenzoate => 'Estradiolbenzoat';

  @override
  String get medicationEstradiolCypionateSuspension =>
      'Estradiolcypionat-Suspension';

  @override
  String get medicationTestosteroneEnanthate => 'Testosteronenantat';

  @override
  String get medicationTestosteroneValerate => 'Testosteronvalerat';

  @override
  String get medicationTestosteroneCypionate => 'Testosteroncypionat';

  @override
  String get medicationTestosteroneUndecylate => 'Testosteronundecylat';

  @override
  String get medicationTestosteroneBenzoate => 'Testosteronbenzoat';

  @override
  String get medicationTestosteroneCypionateSuspension =>
      'Testosteroncypionat-Suspension';

  @override
  String get injection => 'Injektion';

  @override
  String get oral => 'Oral';

  @override
  String get sublingual => 'Sublingual';

  @override
  String get patch => 'Pflaster';

  @override
  String get gel => 'Gel';

  @override
  String get implant => 'Implantat';

  @override
  String get suppository => 'Zäpfchen';

  @override
  String get transdermal => 'Transdermales Spray';

  @override
  String administrationRouteUnitMl(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ml',
      one: 'ml',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitPill(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tabletten',
      one: 'Tablette',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitPatch(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pflaster',
      one: 'Pflaster',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitPump(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hübe',
      one: 'Hub',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitImplant(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Implantate',
      one: 'Implantat',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitSuppository(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zäpfchen',
      one: 'Zäpfchen',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitSpray(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sprays',
      one: 'Spray',
    );
    return '$_temp0';
  }

  @override
  String get injectionSideLeft => 'Links';

  @override
  String get injectionSideRight => 'Rechts';

  @override
  String get intakeSummaryInjectionSideLeft => 'Linke Seite';

  @override
  String get intakeSummaryInjectionSideRight => 'Rechte Seite';

  @override
  String get requiredField => 'Pflichtfeld';

  @override
  String get mustBePositiveNumber => 'Muss eine positive Zahl sein';

  @override
  String get invalidTotalAmount => 'Ungültige Gesamtmenge';

  @override
  String get cannotExceedTotalCapacity =>
      'Darf die Gesamtkapazität nicht überschreiten';

  @override
  String get units => 'Units';
}
