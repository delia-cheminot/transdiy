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
  String get newItem => 'Nouvel élément';

  @override
  String get name => 'Nom';

  @override
  String get molecule => 'Molécule';

  @override
  String get adminRoute => 'Voie d\'administration';

  @override
  String get totalAmount => 'Quantité totale';

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
  String get suppository => 'Suppositoire';

  @override
  String get transdermal => 'Spray transdermique';
}
