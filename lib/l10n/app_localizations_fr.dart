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
  String get nav_home => 'Mona';

  @override
  String get nav_intakes => 'Prises';

  @override
  String get nav_levels => 'Niveaux';

  @override
  String get nav_supplies => 'Pharmacie';

  @override
  String get takeAnIntake => 'Prendre une prise';

  @override
  String get addAnItem => 'Ajouter un élément';

  @override
  String get empty_home =>
      'Commencez par ajouter un plannig dans les paramètres';

  @override
  String get allDone => 'Terminé !';

  @override
  String get noIntakesDue => 'Aucune prise prévue aujourd\'hui';

  @override
  String get upcoming => 'À venir';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get taken => 'pris';

  @override
  String daysAgoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count jours',
      one: 'hier',
    );
    return '$_temp0';
  }

  @override
  String inDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dans $count jours',
      one: 'demain',
    );
    return '$_temp0';
  }

  @override
  String get lastTaken => 'Dernière prise';

  @override
  String get neverTakenYet => 'Jamais pris auparavant';

  @override
  String get scheduleFrequencyDaily => 'Tous les jours';

  @override
  String scheduleFrequencyEveryNDays(Object days) {
    return 'Tous les $days jours';
  }

  @override
  String get newUpdateAvailable => 'Une nouvelle mise à jour est disponible !';

  @override
  String get goToSettings => 'Aller aux paramètres';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get notifications => 'Notifications';

  @override
  String get schedulesAndNotifications => 'Plannings et notifications';

  @override
  String get general => 'Général';

  @override
  String get schedules => 'Plannings';

  @override
  String get noSchedules => 'Aucun planning';

  @override
  String schedulesCreated(Object count) {
    return '$count créés';
  }

  @override
  String get language => 'Langue';

  @override
  String get languageFollowDevice => 'Suivre la langue de l’appareil';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get enableNotifications => 'Activer les notifications';

  @override
  String get enableNotificationsDescription =>
      'Envoyer des rappels pour vos plannings';

  @override
  String get notificationsDisabledTitle => 'Les notifications sont désactivées';

  @override
  String get clickToOpenSettings => 'Cliquez pour ouvrir les paramètres';

  @override
  String get exactRemindersDisabled =>
      'Les heures de rappel exactes sont désactivées';

  @override
  String get remindersDelayed =>
      'Les rappels peuvent être légèrement retardés. Appuyez pour ouvrir les paramètres.';

  @override
  String get autoUpdate => 'Mise à jour automatique';

  @override
  String get autoUpdateDescription =>
      'Vérifier automatiquement les nouvelles mises à jour au lancement de l\'application';

  @override
  String get checkForUpdates => 'Vérifier les mises à jour';

  @override
  String get checkForUpdatesDescription =>
      'Vérifier manuellement la dernière version\nCela vous connectera à Internet\n(Aucune donnée ne sera envoyée)';

  @override
  String appVersion(Object version) {
    return 'Mona version $version';
  }

  @override
  String backupSavedTo(Object path) {
    return 'Sauvegarde enregistrée dans : $path';
  }

  @override
  String exportFailed(Object error) {
    return 'Échec de l\'exportation : $error';
  }

  @override
  String get importDataTitle => 'Importer des données';

  @override
  String get importDataSubtitle =>
      'Restaurer les données depuis une sauvegarde JSON';

  @override
  String get importDataOverwriteWarning =>
      'Cela remplacera toutes vos données actuelles par la sauvegarde. Cette action est irréversible. Voulez-vous continuer ?';

  @override
  String get importConfirm => 'Importer';

  @override
  String get importSuccessfulTitle => 'Import réussi';

  @override
  String get importRestartRequired =>
      'Veuillez redémarrer l\'application pour appliquer les données restaurées.';

  @override
  String get closeApp => 'Fermer l\'application';

  @override
  String importFailed(Object error) {
    return 'Échec de l\'importation : $error';
  }

  @override
  String get updates => 'Mises à jour';

  @override
  String get dataManagement => 'Gestion des données';

  @override
  String get exportDataTitle => 'Exporter les données';

  @override
  String get exportDataSubtitle =>
      'Enregistrer vos données dans un fichier JSON';

  @override
  String get updateNoCompatibleApk =>
      'Aucune mise à jour compatible avec votre appareil.';

  @override
  String get updateAppUpToDate => 'Votre application est à jour !';

  @override
  String get updateCheckNetworkError =>
      'Impossible de vérifier les mises à jour pour le moment.';

  @override
  String get updateDialogTitle => 'Mise à jour disponible';

  @override
  String updateDialogBody(Object current, Object latest) {
    return 'La version $latest est disponible ! (Actuelle : $current)\n\nUne mise à jour compatible avec votre appareil est prête à être installée.';
  }

  @override
  String get updateDownloadAndInstall => 'Télécharger et installer';

  @override
  String get updateInstallPermissionRequired =>
      'Une autorisation est requise pour installer les mises à jour.';

  @override
  String get updateDownloadingTitle => 'Téléchargement de la mise à jour...';

  @override
  String updateFailedOpenInstaller(Object message) {
    return 'Échec de l\'ouverture de l\'installateur : $message';
  }

  @override
  String get updateDownloadFailed =>
      'Échec du téléchargement. Vérifiez votre connexion.';

  @override
  String notificationMedicationReminderTitle(Object scheduleName) {
    return 'Il est temps de prendre $scheduleName';
  }

  @override
  String notificationMedicationReminderBody(Object dateTime) {
    return 'Prévu pour $dateTime';
  }

  @override
  String get addSchedule => 'Ajouter un planning';

  @override
  String get addScheduleToGetStarted => 'Ajoutez un planning pour commencer.';

  @override
  String get newSchedule => 'Nouveau planning';

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
  String deleteSchedule(Object name) {
    return 'Supprimer $name ?';
  }

  @override
  String get scheduleNotifications => 'Notifications du planning';

  @override
  String get addNotification => 'Ajouter une notification';

  @override
  String noNotificationsForSchedule(Object scheduleName) {
    return 'Aucune notification pour $scheduleName. Vous pouvez en ajouter une en utilisant le bouton Ajouter.';
  }

  @override
  String get notificationsUpdated => 'Les notifications ont été mises à jour !';

  @override
  String get notificationsUpdatedDescription =>
      'Chaque planning a désormais ses propres notifications.\n\nVeuillez configurer les notifications pour vos plannings pour vous assurer de ne rien manquer.';

  @override
  String get dontShowAgain => 'Ne plus afficher';

  @override
  String get scheduleSettings => 'Paramètres des plannings';

  @override
  String get empty_intakes => 'Les prises enregistrées apparaîtront ici';

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
  String get supplyItem => 'Consommable';

  @override
  String get injectionSide => 'Côté';

  @override
  String get deleteIntake => 'Supprimer cette prise ?';

  @override
  String takeMedication(Object scheduleName) {
    return 'Prendre $scheduleName';
  }

  @override
  String get takeIntake => 'Prendre';

  @override
  String get needleDeadSpace => 'Espace mort de l\'aiguille';

  @override
  String get microliters => 'μL';

  @override
  String get empty_levels =>
      'Les injections d’estradiol s’afficheront dans cet onglet';

  @override
  String get bloodTestsTitle => 'Prises de sang';

  @override
  String get empty_blood_tests =>
      'Les prises de sang enregistrées s’afficheront ici. Commencez avec le bouton Ajouter !';

  @override
  String get addBloodTest => 'Ajouter une analyse de sang';

  @override
  String get editBloodTest => 'Modifier la prise de sang';

  @override
  String get newBloodTest => 'Nouvelle prise de sang';

  @override
  String get deleteBloodTest => 'Supprimer cette prise de sang ?';

  @override
  String get estradiolLevelLabel => 'Taux d\'estradiol';

  @override
  String get testosteroneLevelLabel => 'Taux de testostérone';

  @override
  String get bloodTestDateLabel => 'Date';

  @override
  String chartNowConcentration(Object value) {
    return 'Maintenant $value';
  }

  @override
  String chartBloodTestLevelTooltip(Object date, Object level) {
    return '$date : $level';
  }

  @override
  String get empty_supplies =>
      'Aucun consommable. Ajoutez un élément pour commencer.';

  @override
  String get newItem => 'Nouvel élément';

  @override
  String get adminRoute => 'Voie d\'administration';

  @override
  String get totalAmount => 'Quantité totale';

  @override
  String get concentration => 'Concentration';

  @override
  String get editItem => 'Modifier l\'élément';

  @override
  String get usedAmount => 'Quantité utilisée';

  @override
  String deleteItem(Object name) {
    return 'Supprimer $name ?';
  }

  @override
  String remaining(Object amount, Object unit) {
    return 'Reste $amount $unit';
  }

  @override
  String get add => 'Ajouter';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get next => 'Suivant';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteElement => 'Supprimer cet élément ?';

  @override
  String get irreversibleAction => 'Cette action est irréversible.';

  @override
  String get name => 'Nom';

  @override
  String get molecule => 'Molécule';

  @override
  String get ester => 'Ester';

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

  @override
  String get medicationEstradiolEnanthate => 'Énanthate d\'œstradiol';

  @override
  String get medicationEstradiolValerate => 'Valérate d\'œstradiol';

  @override
  String get medicationEstradiolCypionate => 'Cypionate d\'œstradiol';

  @override
  String get medicationEstradiolUndecylate => 'Undécylate d\'œstradiol';

  @override
  String get medicationEstradiolBenzoate => 'Benzoate d\'œstradiol';

  @override
  String get medicationEstradiolCypionateSuspension =>
      'Suspension de cypionate d\'œstradiol';

  @override
  String get medicationTestosteroneEnanthate => 'Énanthate de testostérone';

  @override
  String get medicationTestosteroneValerate => 'Valérate de testostérone';

  @override
  String get medicationTestosteroneCypionate => 'Cypionate de testostérone';

  @override
  String get medicationTestosteroneUndecylate => 'Undécylate de testostérone';

  @override
  String get medicationTestosteroneBenzoate => 'Benzoate de testostérone';

  @override
  String get medicationTestosteroneCypionateSuspension =>
      'Suspension de cypionate de testostérone';

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
      other: 'comprimés',
      one: 'comprimé',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitPatch(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'patchs',
      one: 'patch',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitPump(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pressions',
      one: 'pression',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitImplant(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'implants',
      one: 'implant',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitSuppository(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'suppositoires',
      one: 'suppositoire',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitSpray(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pulvérisations',
      one: 'pulvérisation',
    );
    return '$_temp0';
  }

  @override
  String get injectionSideLeft => 'Gauche';

  @override
  String get injectionSideRight => 'Droite';

  @override
  String get intakeSummaryInjectionSideLeft => 'Côté gauche';

  @override
  String get intakeSummaryInjectionSideRight => 'Côté droit';

  @override
  String get requiredField => 'Champ obligatoire';

  @override
  String get mustBePositiveNumber => 'Doit être un nombre positif';

  @override
  String get invalidTotalAmount => 'Montant total invalide';

  @override
  String get cannotExceedTotalCapacity =>
      'Ne peut pas dépasser la capacité totale';
}
