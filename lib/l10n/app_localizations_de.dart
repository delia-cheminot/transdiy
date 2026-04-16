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
  String get empty_home => 'Beginne, indem du einen Zeitplan in den Einstellungen erstellst';

  @override
  String todaySection(Object date) {
    return 'Heute – $date';
  }

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
  String get daysAgo => 'Tage her';

  @override
  String get inText => 'in';

  @override
  String get lastTaken => 'Zuletzt genommen';

  @override
  String get neverTakenYet => 'Noch nie genommen';

  @override
  String get side => 'Seite';

  @override
  String get scheduleFrequencyDaily => 'Täglich';

  @override
  String scheduleFrequencyEveryNDays(Object days) {
    return 'Alle $days Tage';
  }

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get schedules => 'Zeitpläne';

  @override
  String get noSchedules => 'Keine Zeitpläne';

  @override
  String schedulesCreated(Object count) {
    return '$count erstellt';
  }

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get enableNotifications => 'Benachrichtigungen aktivieren';

  @override
  String get enableNotificationsDescription => 'Erinnerungen für Zeitpläne senden';

  @override
  String get notificationsDisabledTitle => 'Benachrichtigungen sind deaktiviert';

  @override
  String get clickToOpenSettings => 'Tippe, um die Einstellungen zu öffnen';

  @override
  String get exactRemindersDisabled => 'Exakte Erinnerungszeiten sind deaktiviert';

  @override
  String get remindersDelayed => 'Erinnerungen können sich leicht verzögern. Tippe, um die Einstellungen zu öffnen.';

  @override
  String get autoUpdate => 'Automatische Updates';

  @override
  String get autoUpdateDescription => 'Beim Start der App automatisch nach Updates suchen';

  @override
  String get checkForUpdates => 'Nach Updates suchen';

  @override
  String get checkForUpdatesDescription => 'Manuell nach der neuesten Version suchen\nDies stellt eine Internetverbindung her\n(Es werden keine Daten gesendet)';

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
  String get importDataSubtitle => 'Daten aus einer JSON-Sicherung wiederherstellen';

  @override
  String get importDataOverwriteWarning => 'Dadurch werden alle aktuellen Daten durch das Backup überschrieben. Diese Aktion kann nicht rückgängig gemacht werden. Möchtest du fortfahren?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get importConfirm => 'Importieren';

  @override
  String get importSuccessfulTitle => 'Import erfolgreich';

  @override
  String get importRestartRequired => 'Bitte starte die App neu, um die wiederhergestellten Daten zu übernehmen.';

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
  String get addSchedule => 'Zeitplan hinzufügen';

  @override
  String get addScheduleToGetStarted => 'Füge einen Zeitplan hinzu, um zu beginnen.';

  @override
  String get newSchedule => 'Neuer Zeitplan';

  @override
  String get next => 'Weiter';

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
  String notificationsCount(Object count) {
    return '$count Benachrichtigungen';
  }

  @override
  String get editSchedule => 'Zeitplan bearbeiten';

  @override
  String get deleteSchedule => 'Diesen Zeitplan löschen?';

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
  String get notificationsUpdatedDescription => 'Jeder Zeitplan hat jetzt eigene Benachrichtigungen.\n\nBitte richte Benachrichtigungen für deine Zeitpläne ein, damit du nichts verpasst.';

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
  String get empty_levels => 'Estradiol-Injektionen werden in diesem Tab angezeigt';

  @override
  String get empty_supplies => 'Keine Vorräte. Füge einen Eintrag hinzu, um zu beginnen.';

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
  String get deleteItem => 'Diesen Eintrag löschen?';

  @override
  String remaining(Object amount, Object unit) {
    return '$amount $unit verbleibend';
  }

  @override
  String get add => 'Hinzufügen';

  @override
  String get save => 'Speichern';

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
  String get medicationEstradiolCypionateSuspension => 'Estradiolcypionat-Suspension';

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
  String get medicationTestosteroneCypionateSuspension => 'Testosteroncypionat-Suspension';

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
  String get injectionSideLeft => 'Links';

  @override
  String get injectionSideRight => 'Rechts';
}
