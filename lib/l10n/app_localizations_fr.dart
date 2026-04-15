// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Mona';

  @override
  String get profileTitle => 'Paramètres';

  @override
  String get intakesTitle => 'Prises';

  @override
  String get levelsTitle => 'Niveaux';

  @override
  String get suppliesTitle => 'Fournitures';

  @override
  String get empty_home => 'Commencez par ajouter un planning dans les paramètres';

  @override
  String get empty_intakes => 'Les prises enregistrées apparaîtront ici';

  @override
  String get empty_levels => 'Les injections d’estradiol s’afficheront dans cet onglet';

  @override
  String get empty_supplies => 'Aucune fourniture. Ajoutez un élément pour commencer.';

  @override
  String get nav_home => 'Mona';

  @override
  String get nav_intakes => 'Prises';

  @override
  String get nav_levels => 'Niveaux';

  @override
  String get nav_supplies => 'Fournitures';

  @override
  String get schedules => 'Plannings';

  @override
  String get noSchedules => 'Aucun planning';

  @override
  String schedulesCount(Object count) {
    return '$count créés';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String notificationsEnabled(Object time) {
    return 'Activées à $time';
  }

  @override
  String get notificationsDisabled => 'Désactivées';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String schedulesCreated(Object count) {
    return '$count créés';
  }

  @override
  String get enableNotifications => 'Activer les notifications';

  @override
  String get notificationsDisabledTitle => 'Les notifications sont désactivées';

  @override
  String get clickToOpenSettings => 'Cliquez pour ouvrir les paramètres';

  @override
  String get exactRemindersDisabled => 'Les heures de rappel exactes sont désactivées';

  @override
  String get remindersDelayed => 'Les rappels peuvent être légèrement retardés. Appuyez pour ouvrir les paramètres.';

  @override
  String get autoUpdate => 'Mise à jour automatique';

  @override
  String get autoUpdateDescription => 'Vérifier automatiquement les nouvelles mises à jour au lancement de l\'application';

  @override
  String get checkForUpdates => 'Vérifier les mises à jour';

  @override
  String get checkForUpdatesDescription => 'Vérifier manuellement la dernière version\nCela vous connectera à Internet\n(Aucune donnée ne sera envoyée)';

  @override
  String appVersion(Object version) {
    return 'Mona version $version';
  }

  @override
  String get notificationsUpdated => 'Les notifications ont été mises à jour !';

  @override
  String get notificationsUpdatedDescription => 'Chaque planning a désormais ses propres notifications.\n\nVeuillez configurer les notifications pour vos plannings pour vous assurer de ne rien manquer.';

  @override
  String get dontShowAgain => 'Ne plus afficher';

  @override
  String get scheduleSettings => 'Paramètres des plannings';

  @override
  String get newItem => 'Nouvel article';

  @override
  String get name => 'Nom';

  @override
  String get molecule => 'Molécule';

  @override
  String get adminRoute => 'Voie d\'administration';

  @override
  String get estradiol => 'Œstradiol';

  @override
  String get progesterone => 'Progestérone';

  @override
  String get testosterone => 'Testostérone';

  @override
  String get nandrolone => 'Nandrolone';

  @override
  String get spironolactone => 'Spironolactone';

  @override
  String get cyproteroneAcetate => 'Acétate de cyprotérone';

  @override
  String get leuprorelinAcetate => 'Acétate de leuproréline';

  @override
  String get bicalutamide => 'Bicalutamide';

  @override
  String get decapeptyl => 'Décapéptyl';

  @override
  String get raloxifene => 'Raloxifène';

  @override
  String get tamoxifen => 'Tamoxifène';

  @override
  String get finasteride => 'Finastéride';

  @override
  String get dutasteride => 'Dutastéride';

  @override
  String get minoxidil => 'Minoxidil';

  @override
  String get pioglitazone => 'Pioglitazone';

  @override
  String get totalAmount => 'Quantité totale';

  @override
  String get concentration => 'Concentration';

  @override
  String get editItem => 'Modifier l\'article';

  @override
  String get add => 'Ajouter';

  @override
  String get save => 'Enregistrer';

  @override
  String get usedAmount => 'Quantité utilisée';

  @override
  String get ester => 'Ester';

  @override
  String get deleteItem => 'Supprimer cet article ?';

  @override
  String remaining(Object amount, Object unit) {
    return '$amount $unit restant';
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
  String get suppository => 'Suppositoire';

  @override
  String get transdermal => 'Spray transdermique';

  @override
  String get chooseSchedule => 'Choisir un planning';

  @override
  String get addSchedulesFirst => 'Ajoutez d\'abord des plannings.';

  @override
  String get editIntake => 'Modifier la prise';

  @override
  String get date => 'Date';

  @override
  String get amount => 'Quantité';

  @override
  String get none => 'Aucun';

  @override
  String get supplyItem => 'Article de fourniture';

  @override
  String get injectionSide => 'Côté d\'injection';

  @override
  String get deleteIntake => 'Supprimer cette prise ?';

  @override
  String todaySection(Object date) {
    return 'Aujourd\'hui - $date';
  }

  @override
  String get allDone => 'Terminé !';

  @override
  String get noIntakesDue => 'Aucune prise prévue aujourd\'hui';

  @override
  String get upcoming => 'À venir';

  @override
  String takeMedication(Object scheduleName) {
    return 'Prendre $scheduleName';
  }

  @override
  String get takeIntake => 'Prendre la prise';

  @override
  String get needleDeadSpace => 'Espace mort de l\'aiguille';

  @override
  String get microliters => 'μL';

  @override
  String get addSchedule => 'Ajouter un planning';

  @override
  String get addScheduleToGetStarted => 'Ajoutez un planning pour commencer.';

  @override
  String get newSchedule => 'Nouveau planning';

  @override
  String get next => 'Suivant';

  @override
  String get every => 'Tous les';

  @override
  String get days => 'jours';

  @override
  String get startDate => 'Date de début';

  @override
  String get editScheduleInfo => 'Modifier les informations du planning';

  @override
  String get noNotifications => 'Aucune notification';

  @override
  String notificationsCount(Object count) {
    return '$count notifications';
  }

  @override
  String get editSchedule => 'Modifier le planning';

  @override
  String get deleteSchedule => 'Supprimer ce planning ?';

  @override
  String get scheduleNotifications => 'Notifications du planning';

  @override
  String get addNotification => 'Ajouter une notification';

  @override
  String noNotificationsForSchedule(Object scheduleName) {
    return 'Aucune notification pour $scheduleName. Vous pouvez en ajouter une en utilisant le bouton Ajouter.';
  }

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get taken => 'pris';

  @override
  String get daysAgo => 'jours auparavant';

  @override
  String get inText => 'dans';

  @override
  String get lastTaken => 'Dernière prise';

  @override
  String get neverTakenYet => 'Jamais pris auparavant';

  @override
  String get side => 'côté';

  @override
  String get enanthate => 'Énanthate';

  @override
  String get valerate => 'Valérate';

  @override
  String get cypionate => 'Cypionate';

  @override
  String get undecylate => 'Undécylate';

  @override
  String get benzoate => 'Benzoate';

  @override
  String get cypionateSuspension => 'Suspension de cypionate';
}
