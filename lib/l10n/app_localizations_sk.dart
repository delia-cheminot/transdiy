// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get appTitle => 'Mona';

  @override
  String get nav_home => 'Mona';

  @override
  String get nav_intakes => 'Dávky';

  @override
  String get nav_levels => 'Hodnoty';

  @override
  String get nav_supplies => 'Zásoby';

  @override
  String get takeAnIntake => 'Vziať dávku';

  @override
  String get addAnItem => 'Pridaj vybavenie';

  @override
  String get empty_home => 'Začni pridaním plánu v nastaveniach';

  @override
  String get allDone => 'Hotovo!';

  @override
  String get noIntakesDue => 'Dnes nie sú naplánované žiadne dávky';

  @override
  String get upcoming => 'Nadchádzajúce';

  @override
  String get today => 'Dnes';

  @override
  String get taken => 'vzaté';

  @override
  String daysAgoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pred $count dňami',
      one: 'včera',
    );
    return '$_temp0';
  }

  @override
  String inDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      few: 'o $count dni',
      other: 'o $count dní',
      one: 'zajtra',
    );
    return '$_temp0';
  }

  @override
  String get lastTaken => 'Vzatá naposledy';

  @override
  String get neverTakenYet => 'Nevzatá nikdy';

  @override
  String get scheduleFrequencyDaily => 'Každý deň';

  @override
  String scheduleFrequencyEveryNDays(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      few: 'Každé $days dni',
      other: 'Každých $days dní',
    );
    return '$_temp0';
  }

  @override
  String get newUpdateAvailable => 'Je k dispozícii nová aktualizácia!';

  @override
  String get goToSettings => 'Ísť do nastavení';

  @override
  String get deprecated => 'Zastarané';

  @override
  String get legacyVersionMessage => 'Používaš staršiu verziu apky Mona. Prosím aktualizuj ju. Klikni a zisti viac.';

  @override
  String get legacyDeprecationIntro => 'Táto verzia apky Mona je zastaraná. Pre pokračovanie jej používania a získavania aktualizácií prosím nainštaluj novú verziu pomocou nasledovných krokov.';

  @override
  String get legacyStep1Title => 'Exportovanie tvojich dát';

  @override
  String get legacyStep1Description => 'V nastaveniach klikni \'Export dát\' pre vytvorenie zálohy tvojich dát do súboru JSON.';

  @override
  String get legacyStep2Title => 'Stiahnutie novej verzie';

  @override
  String get legacyStep2Description => 'Stiahni cez Play Store. Alebo z najnovšieho releaseu na GitHube stiahni súbor nazvaný mona-<verzia>.apk.';

  @override
  String get legacyStep3Title => 'Odinštalácia tejto verzie';

  @override
  String get legacyStep3Description => 'Vymaž túto apku zo svojho zariadenia. Tvoja záloha je v bezpečí.';

  @override
  String get legacyStep4Title => 'Inštalácia nového APK súboru';

  @override
  String get legacyStep4Description => 'Otvor stiahnutý APK súbor a nasleduj inštrukcie Androidu pre jeho inštaláciu.';

  @override
  String get legacyStep5Title => 'Importovanie tvojich dát';

  @override
  String get legacyStep5Description => 'Otvor novú apku Mona, choď do nastavení a klikni \'Import dát\' pre obnovenie tvojej zálohy.';

  @override
  String get openLatestRelease => 'Otvoriť na GitHube';

  @override
  String get openPlayStore => 'Otvoriť na Play Store';

  @override
  String get settingsTitle => 'Nastavenia';

  @override
  String get notifications => 'Notifikácie';

  @override
  String get schedulesAndNotifications => 'Plány & notifikácie';

  @override
  String get general => 'Všeobecné';

  @override
  String get schedules => 'Plány';

  @override
  String get noSchedules => 'Žiadne plány';

  @override
  String schedulesCreated(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      few: 'Vytvorené $count plány',
      other: 'Vytvorených $count plánov',
      one: 'Vytvorený $count plán',
    );
    return '$_temp0';
  }

  @override
  String get language => 'Jazyk';

  @override
  String get languageFollowDevice => 'Jazyk podľa zariadenia';

  @override
  String get selectLanguage => 'Vyber jazyk';

  @override
  String get enableNotifications => 'Zapni notifikácie';

  @override
  String get enableNotificationsDescription => 'Pripomienky plánov';

  @override
  String get notificationsDisabledTitle => 'Notifikácie sú vypnuté';

  @override
  String get clickToOpenSettings => 'Klikni pre otvorenie nastavení';

  @override
  String get exactRemindersDisabled => 'Presné časy pripomienok sú vypnuté';

  @override
  String get remindersDelayed => 'Pripomienky môžu byť jemne oneskorené. Klikni pre otvorenie nastavení.';

  @override
  String get autoUpdate => 'Automatické aktualizácie';

  @override
  String get autoUpdateDescription => 'Automaticky skontrolovať najnovšie aktualizácie pre otvorení apky';

  @override
  String get checkForUpdates => 'Skontrolovať aktualizácie';

  @override
  String get checkForUpdatesDescription => 'Skontrolovať najnovšiu verziu manuálne\nTáto akcia ťa pripojí na internet.\n(Žiadne dáta nebudú odoslané)';

  @override
  String appVersion(Object version) {
    return 'Mona verzia $version';
  }

  @override
  String backupSavedTo(Object path) {
    return 'Záloha uložená: $path';
  }

  @override
  String exportFailed(Object error) {
    return 'Export dát sa nepodaril: $error';
  }

  @override
  String get importDataTitle => 'Import dát';

  @override
  String get importDataSubtitle => 'Obnoviť dáta pomocou JSON zálohy';

  @override
  String get importDataOverwriteWarning => 'Týmto sa všetky tvoje dáta prepíšu zálohou. Túto akciu nie je možné vrátiť späť. Chceš pokračovať?';

  @override
  String get importConfirm => 'Import';

  @override
  String get importSuccessfulTitle => 'Import úspešný';

  @override
  String get importRestartRequired => 'Prosím reštartuj apku pre načítanie importovaných dát.';

  @override
  String get closeApp => 'Zavrieť apku';

  @override
  String importFailed(Object error) {
    return 'Import sa nepodaril: $error';
  }

  @override
  String get updates => 'Aktualizácie';

  @override
  String get dataManagement => 'Správa dát';

  @override
  String get exportDataTitle => 'Export dát';

  @override
  String get exportDataSubtitle => 'Ulož svoje dáta do JSON súboru';

  @override
  String get updateNoCompatibleApk => 'Pre tvoje zariadenie nebola nájdená kompatibilná aktualizácia.';

  @override
  String get updateAppUpToDate => 'Tvoja apka má najnovšiu aktualizáciu!';

  @override
  String get updateCheckNetworkError => 'Nebolo možné skontrolovať aktualizácie.';

  @override
  String get updateDialogTitle => 'Dostupná aktualizácia';

  @override
  String updateDialogBody(Object current, Object latest) {
    return 'Verzia $latest je dostupná! (Súčasná: $current)\n\nAktualizácia kompatibilná s tvojím zariadením je pripravená na inštaláciu.';
  }

  @override
  String get updateDownloadAndInstall => 'Stiahni & nainštaluj';

  @override
  String get updateInstallPermissionRequired => 'Pre inštaláciu aktualizácií je potrebné povolenie.';

  @override
  String get updateDownloadingTitle => 'Sťahovanie aktualizácie...';

  @override
  String updateFailedOpenInstaller(Object message) {
    return 'Nepodarilo sa otvoriť inštalátor: $message';
  }

  @override
  String get updateDownloadFailed => 'Sťahovanie sa nepodarilo. Prosím skontroluj svoje pripojenie.';

  @override
  String notificationMedicationReminderTitle(Object scheduleName) {
    return 'Prišiel čas si vziať $scheduleName';
  }

  @override
  String notificationMedicationReminderBody(Object dateTime) {
    return 'Naplánovaná na $dateTime';
  }

  @override
  String get addSchedule => 'Pridaj plán';

  @override
  String get addScheduleToGetStarted => 'Pridaj plán pre začatie.';

  @override
  String get newSchedule => 'Nový plán';

  @override
  String get every => 'Každých';

  @override
  String get days => 'dní';

  @override
  String get startDate => 'Dátum začiatku';

  @override
  String get editScheduleInfo => 'Upraviť detaily plánu';

  @override
  String get noNotifications => 'Žiadne notifikácie';

  @override
  String notificationsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      few: '$count notifikácie',
      other: '$count notifikácií',
      one: '$count notifikácia',
    );
    return '$_temp0';
  }

  @override
  String get editSchedule => 'Upraviť plán';

  @override
  String deleteSchedule(Object name) {
    return 'Vymazať $name?';
  }

  @override
  String get scheduleNotifications => 'Notifikácie plánu';

  @override
  String get addNotification => 'Pridaj notifikáciu';

  @override
  String noNotificationsForSchedule(Object scheduleName) {
    return 'Žiadne notifikácie pre $scheduleName. Stlač tlačidlo Pridaj.';
  }

  @override
  String get notificationsUpdated => 'Notifikácie boli aktualizované!';

  @override
  String get notificationsUpdatedDescription => 'Každý plán má teraz vlastné notifikácie.\n\nZapni si notifikácie pre svoje plány, aby ti nič neušlo.';

  @override
  String get dontShowAgain => 'Nezobrazovať znovu';

  @override
  String get scheduleSettings => 'Nastavenia plánu';

  @override
  String get empty_intakes => 'Vzaté dávky sa zobrazia tu';

  @override
  String get chooseSchedule => 'Vyber plán';

  @override
  String get addSchedulesFirst => 'Najprv pridaj plány.';

  @override
  String get editIntake => 'Uprav dávku';

  @override
  String get date => 'Dátum';

  @override
  String get amount => 'Množstvo';

  @override
  String get none => 'Žiadna';

  @override
  String get supplyItem => 'Zásoba';

  @override
  String get injectionSide => 'Strana injekcie';

  @override
  String get deleteIntake => 'Vymazať túto dávku?';

  @override
  String takeMedication(Object scheduleName) {
    return 'Vezmi $scheduleName';
  }

  @override
  String get takeIntake => 'Vezmi dávku';

  @override
  String get needleDeadSpace => 'Mŕtvy priestor ihly';

  @override
  String get microliters => 'μL';

  @override
  String get empty_levels => 'Estradiolové injekcie sa zobrazia na tejto karte';

  @override
  String get bloodTestsTitle => 'Krvné testy';

  @override
  String get empty_blood_tests => 'Krvné testy sa zobrazia tu. Začni tlačidlom Pridať!';

  @override
  String get addBloodTest => 'Pridaj krvný test';

  @override
  String get editBloodTest => 'Upraviť krvný test';

  @override
  String get newBloodTest => 'Nový krvný test';

  @override
  String get deleteBloodTest => 'Vymazať krvný test?';

  @override
  String get estradiolLevelLabel => 'Hodnota estradiolu';

  @override
  String get testosteroneLevelLabel => 'Hodnota testosterónu';

  @override
  String get bloodTestDateLabel => 'Dátum krvného testu';

  @override
  String chartNowConcentration(Object value) {
    return 'Teraz $value';
  }

  @override
  String chartBloodTestLevelTooltip(Object date, Object level) {
    return '$date: $level';
  }

  @override
  String get empty_supplies => 'Žiadne zásoby. Pridaj vybavenie pre začatie.';

  @override
  String get newItem => 'Nové vybavenie';

  @override
  String get adminRoute => 'Spôsob podávania';

  @override
  String get totalAmount => 'Celkové množstvo';

  @override
  String get concentration => 'Koncentrácia';

  @override
  String get editItem => 'Uprav vybavenie';

  @override
  String get usedAmount => 'Použité množstvo';

  @override
  String deleteItem(Object name) {
    return 'Vymazať $name?';
  }

  @override
  String remaining(num amount, Object unit) {
    String _temp0 = intl.Intl.pluralLogic(
      amount,
      locale: localeName,
      other: 'Zostáva $amount $unit',
      few: 'Zostávajú $amount $unit',
    );
    return '$_temp0';
  }

  @override
  String get add => 'Pridať';

  @override
  String get save => 'Uložiť';

  @override
  String get cancel => 'Zrušiť';

  @override
  String get next => 'Ďalej';

  @override
  String get delete => 'Vymazať';

  @override
  String get deleteElement => 'Vymazať toto vybavenie?';

  @override
  String get irreversibleAction => 'Tento úkon je nezvratný.';

  @override
  String get name => 'Meno';

  @override
  String get molecule => 'Molekula';

  @override
  String get ester => 'Ester';

  @override
  String get estradiol => 'Estradiol';

  @override
  String get progesterone => 'Progesterón';

  @override
  String get testosterone => 'Testosterón';

  @override
  String get nandrolone => 'Nandrolón';

  @override
  String get spironolactone => 'Spironolaktón';

  @override
  String get cyproteroneAcetate => 'Cyproterón acetát';

  @override
  String get leuprorelinAcetate => 'Leuprorelin acetát';

  @override
  String get bicalutamide => 'Bicalutamide';

  @override
  String get decapeptyl => 'Decapeptyl';

  @override
  String get raloxifene => 'Raloxifene';

  @override
  String get tamoxifen => 'Tamoxifen';

  @override
  String get finasteride => 'Finasterid';

  @override
  String get dutasteride => 'Dutasterid';

  @override
  String get minoxidil => 'Minoxidil';

  @override
  String get pioglitazone => 'Pioglitazón';

  @override
  String get enanthate => 'Enantát';

  @override
  String get valerate => 'Valerát';

  @override
  String get cypionate => 'Cypionát';

  @override
  String get undecylate => 'Undecylát';

  @override
  String get benzoate => 'Benzoát';

  @override
  String get cypionateSuspension => 'suspenzia cypionátu';

  @override
  String get medicationEstradiolEnanthate => 'Estradiol enantát';

  @override
  String get medicationEstradiolValerate => 'Estradiol valerát';

  @override
  String get medicationEstradiolCypionate => 'Estradiol cypionát';

  @override
  String get medicationEstradiolUndecylate => 'Estradiol undecylát';

  @override
  String get medicationEstradiolBenzoate => 'Estradiol benzoát';

  @override
  String get medicationEstradiolCypionateSuspension => 'Estradiolová suspenzia cypionátu';

  @override
  String get medicationTestosteroneEnanthate => 'Testosterón enantát';

  @override
  String get medicationTestosteroneValerate => 'Testosterón valerát';

  @override
  String get medicationTestosteroneCypionate => 'Testosterón cypionát';

  @override
  String get medicationTestosteroneUndecylate => 'Testosterón undecylát';

  @override
  String get medicationTestosteroneBenzoate => 'Testosterón benzoát';

  @override
  String get medicationTestosteroneCypionateSuspension => 'Testosterónová suspenzia cypionátu';

  @override
  String get injection => 'Injekcia';

  @override
  String get oral => 'Orálne podanie';

  @override
  String get sublingual => 'Sublinguálne podanie';

  @override
  String get patch => 'Náplasť';

  @override
  String get gel => 'Gél';

  @override
  String get implant => 'Implantát';

  @override
  String get suppository => 'Čapík';

  @override
  String get transdermal => 'Transdermálny sprej';

  @override
  String get transdermalDrops => 'Transdermálne kvapky';

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
      few: 'pilulky',
      other: 'piluliek',
      one: 'pilulka',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitPatch(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      few: 'náplasti',
      other: 'náplastí',
      one: 'náplasť',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitPump(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      few: 'stlačenia',
      other: 'stlačení',
      one: 'stlačenie',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitImplant(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      few: 'implantáty',
      other: 'implantátov',
      one: 'implantát',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitSuppository(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      few: 'čapíky',
      other: 'čapíkov',
      one: 'čapík',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitSpray(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      few: 'spreje',
      other: 'sprejov',
      one: 'sprej',
    );
    return '$_temp0';
  }

  @override
  String get injectionSideLeft => 'Vľavo';

  @override
  String get injectionSideRight => 'Vpravo';

  @override
  String get intakeSummaryInjectionSideLeft => 'Ľavá strana';

  @override
  String get intakeSummaryInjectionSideRight => 'Pravá strana';

  @override
  String get requiredField => 'Požadované políčko';

  @override
  String get mustBePositiveNumber => 'Musí byť kladné číslo';

  @override
  String get invalidTotalAmount => 'Nesprávne celkové množstvo';

  @override
  String get cannotExceedTotalCapacity => 'Nemôže presahovať celkové množstvo';
}
