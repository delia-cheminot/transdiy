// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Mona';

  @override
  String get profileTitle => 'Configurações';

  @override
  String get intakesTitle => 'Doses';

  @override
  String get levelsTitle => 'Níveis';

  @override
  String get suppliesTitle => 'Suprimentos';

  @override
  String get empty_home => 'Comece adicionando um cronograma em Configurações';

  @override
  String get empty_intakes => 'As doses registradas aparecerão aqui';

  @override
  String get empty_levels => 'As injeções de estradiol aparecerão nesta aba';

  @override
  String get empty_supplies => 'Sem suprimentos. Adicione um item para começar.';

  @override
  String get nav_home => 'Mona';

  @override
  String get nav_intakes => 'Doses';

  @override
  String get nav_levels => 'Níveis';

  @override
  String get nav_supplies => 'Suprimentos';

  @override
  String get schedules => 'Cronogramas';

  @override
  String get noSchedules => 'Sem cronogramas';

  @override
  String schedulesCount(Object count) {
    return '$count criados';
  }

  @override
  String get notifications => 'Notificações';

  @override
  String notificationsEnabled(Object time) {
    return 'Ativado às $time';
  }

  @override
  String get notificationsDisabled => 'Desativado';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String schedulesCreated(Object count) {
    return '$count criados';
  }

  @override
  String get english => 'Inglês';

  @override
  String get french => 'Francês';

  @override
  String get enableNotifications => 'Ativar notificações';

  @override
  String get notificationsDisabledTitle => 'As notificações estão desativadas';

  @override
  String get clickToOpenSettings => 'Toque para abrir as configurações';

  @override
  String get exactRemindersDisabled => 'Os horários exatos de lembrete estão desativados';

  @override
  String get remindersDelayed => 'Os lembretes podem atrasar um pouco. Toque para abrir as configurações.';

  @override
  String get autoUpdate => 'Atualização automática';

  @override
  String get autoUpdateDescription => 'Verificar automaticamente por atualizações ao iniciar o app';

  @override
  String get checkForUpdates => 'Verificar atualizações';

  @override
  String get checkForUpdatesDescription => 'Verificar manualmente a versão mais recente\nIsso se conectará à Internet\n(Nenhum dado será enviado)';

  @override
  String appVersion(Object version) {
    return 'Versão do Mona $version';
  }

  @override
  String get notificationsUpdated => 'As notificações foram atualizadas!';

  @override
  String get notificationsUpdatedDescription => 'Cada cronograma agora tem suas próprias notificações.\n\nConfigure as notificações para seus cronogramas para garantir que você não perca nada.';

  @override
  String get dontShowAgain => 'Não mostrar novamente';

  @override
  String get scheduleSettings => 'Configurações do cronograma';

  @override
  String get newItem => 'Novo item';

  @override
  String get name => 'Nome';

  @override
  String get molecule => 'Molécula';

  @override
  String get adminRoute => 'Via de administração';

  @override
  String get estradiol => 'Estradiol';

  @override
  String get progesterone => 'Progesterona';

  @override
  String get testosterone => 'Testosterona';

  @override
  String get nandrolone => 'Nandrolona';

  @override
  String get spironolactone => 'Espironolactona';

  @override
  String get cyproteroneAcetate => 'Acetato de ciproterona';

  @override
  String get leuprorelinAcetate => 'Acetato de leuprorelina';

  @override
  String get bicalutamide => 'Bicalutamida';

  @override
  String get decapeptyl => 'Decapeptyl';

  @override
  String get raloxifene => 'Raloxifeno';

  @override
  String get tamoxifen => 'Tamoxifeno';

  @override
  String get finasteride => 'Finasterida';

  @override
  String get dutasteride => 'Dutasterida';

  @override
  String get minoxidil => 'Minoxidil';

  @override
  String get totalAmount => 'Quantidade total';

  @override
  String get concentration => 'Concentração';

  @override
  String get editItem => 'Editar item';

  @override
  String get add => 'Adicionar';

  @override
  String get save => 'Salvar';

  @override
  String get usedAmount => 'Quantidade usada';

  @override
  String get ester => 'Éster';

  @override
  String get deleteItem => 'Excluir este item?';

  @override
  String remaining(Object amount, Object unit) {
    return '$amount $unit restantes';
  }

  @override
  String get injection => 'Injeção';

  @override
  String get oral => 'Oral';

  @override
  String get sublingual => 'Sublingual';

  @override
  String get patch => 'Adesivo';

  @override
  String get gel => 'Gel';

  @override
  String get implant => 'Implante';

  @override
  String get suppository => 'Supositório';

  @override
  String get transdermal => 'Spray transdérmico';

  @override
  String get chooseSchedule => 'Escolher um cronograma';

  @override
  String get addSchedulesFirst => 'Adicione cronogramas primeiro.';

  @override
  String get editIntake => 'Editar dose';

  @override
  String get date => 'Data';

  @override
  String get amount => 'Quantidade';

  @override
  String get none => 'Nenhum';

  @override
  String get supplyItem => 'Item de suprimento';

  @override
  String get injectionSide => 'Lado da injeção';

  @override
  String get deleteIntake => 'Excluir esta dose?';

  @override
  String todaySection(Object date) {
    return 'Hoje - $date';
  }

  @override
  String get allDone => 'Tudo pronto!';

  @override
  String get noIntakesDue => 'Nenhuma dose pendente hoje';

  @override
  String get upcoming => 'Próximos';

  @override
  String takeMedication(Object scheduleName) {
    return 'Tomar $scheduleName';
  }

  @override
  String get takeIntake => 'Registrar dose';

  @override
  String get needleDeadSpace => 'Espaço morto da agulha';

  @override
  String get microliters => 'μL';

  @override
  String get addSchedule => 'Adicionar cronograma';

  @override
  String get addScheduleToGetStarted => 'Adicione um cronograma para começar.';

  @override
  String get newSchedule => 'Novo cronograma';

  @override
  String get next => 'Próximo';

  @override
  String get every => 'A cada';

  @override
  String get days => 'dias';

  @override
  String get startDate => 'Data de início';

  @override
  String get editScheduleInfo => 'Editar informações do cronograma';

  @override
  String get noNotifications => 'Sem notificações';

  @override
  String notificationsCount(Object count) {
    return '$count notificações';
  }

  @override
  String get editSchedule => 'Editar cronograma';

  @override
  String get deleteSchedule => 'Excluir este cronograma?';

  @override
  String get scheduleNotifications => 'Notificações do cronograma';

  @override
  String get addNotification => 'Adicionar notificação';

  @override
  String noNotificationsForSchedule(Object scheduleName) {
    return 'Sem notificações para $scheduleName. Você pode adicionar uma usando o botão Adicionar.';
  }

  @override
  String get today => 'Hoje';

  @override
  String get taken => 'tomado';

  @override
  String get daysAgo => 'dias atrás';

  @override
  String get inText => 'em';

  @override
  String get lastTaken => 'Última dose';

  @override
  String get neverTakenYet => 'Ainda não tomado';

  @override
  String get side => 'lado';

  @override
  String get enanthate => 'Enantato';

  @override
  String get valerate => 'Valerato';

  @override
  String get cypionate => 'Cipionato';

  @override
  String get undecylate => 'Undecilato';

  @override
  String get benzoate => 'Benzoato';

  @override
  String get cypionateSuspension => 'Suspensão de cipionato';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr(): super('pt_BR');

  @override
  String get appTitle => 'Mona';

  @override
  String get profileTitle => 'Configurações';

  @override
  String get intakesTitle => 'Doses';

  @override
  String get levelsTitle => 'Níveis';

  @override
  String get suppliesTitle => 'Suprimentos';

  @override
  String get empty_home => 'Comece adicionando um cronograma em Configurações';

  @override
  String get empty_intakes => 'As doses registradas aparecerão aqui';

  @override
  String get empty_levels => 'As injeções de estradiol aparecerão nesta aba';

  @override
  String get empty_supplies => 'Sem suprimentos. Adicione um item para começar.';

  @override
  String get nav_home => 'Mona';

  @override
  String get nav_intakes => 'Doses';

  @override
  String get nav_levels => 'Níveis';

  @override
  String get nav_supplies => 'Suprimentos';

  @override
  String get schedules => 'Cronogramas';

  @override
  String get noSchedules => 'Sem cronogramas';

  @override
  String schedulesCount(Object count) {
    return '$count criados';
  }

  @override
  String get notifications => 'Notificações';

  @override
  String notificationsEnabled(Object time) {
    return 'Ativado às $time';
  }

  @override
  String get notificationsDisabled => 'Desativado';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String schedulesCreated(Object count) {
    return '$count criados';
  }

  @override
  String get english => 'Inglês';

  @override
  String get french => 'Francês';

  @override
  String get enableNotifications => 'Ativar notificações';

  @override
  String get notificationsDisabledTitle => 'As notificações estão desativadas';

  @override
  String get clickToOpenSettings => 'Toque para abrir as configurações';

  @override
  String get exactRemindersDisabled => 'Os horários exatos de lembrete estão desativados';

  @override
  String get remindersDelayed => 'Os lembretes podem atrasar um pouco. Toque para abrir as configurações.';

  @override
  String get autoUpdate => 'Atualização automática';

  @override
  String get autoUpdateDescription => 'Verificar automaticamente por atualizações ao iniciar o app';

  @override
  String get checkForUpdates => 'Verificar atualizações';

  @override
  String get checkForUpdatesDescription => 'Verificar manualmente a versão mais recente\nIsso se conectará à Internet\n(Nenhum dado será enviado)';

  @override
  String appVersion(Object version) {
    return 'Versão do Mona $version';
  }

  @override
  String get notificationsUpdated => 'As notificações foram atualizadas!';

  @override
  String get notificationsUpdatedDescription => 'Cada cronograma agora tem suas próprias notificações.\n\nConfigure as notificações para seus cronogramas para garantir que você não perca nada.';

  @override
  String get dontShowAgain => 'Não mostrar novamente';

  @override
  String get scheduleSettings => 'Configurações do cronograma';

  @override
  String get newItem => 'Novo item';

  @override
  String get name => 'Nome';

  @override
  String get molecule => 'Molécula';

  @override
  String get adminRoute => 'Via de administração';

  @override
  String get estradiol => 'Estradiol';

  @override
  String get progesterone => 'Progesterona';

  @override
  String get testosterone => 'Testosterona';

  @override
  String get nandrolone => 'Nandrolona';

  @override
  String get spironolactone => 'Espironolactona';

  @override
  String get cyproteroneAcetate => 'Acetato de ciproterona';

  @override
  String get leuprorelinAcetate => 'Acetato de leuprorelina';

  @override
  String get bicalutamide => 'Bicalutamida';

  @override
  String get decapeptyl => 'Decapeptyl';

  @override
  String get raloxifene => 'Raloxifeno';

  @override
  String get tamoxifen => 'Tamoxifeno';

  @override
  String get finasteride => 'Finasterida';

  @override
  String get dutasteride => 'Dutasterida';

  @override
  String get minoxidil => 'Minoxidil';

  @override
  String get totalAmount => 'Quantidade total';

  @override
  String get concentration => 'Concentração';

  @override
  String get editItem => 'Editar item';

  @override
  String get add => 'Adicionar';

  @override
  String get save => 'Salvar';

  @override
  String get usedAmount => 'Quantidade usada';

  @override
  String get ester => 'Éster';

  @override
  String get deleteItem => 'Excluir este item?';

  @override
  String remaining(Object amount, Object unit) {
    return '$amount $unit restantes';
  }

  @override
  String get injection => 'Injeção';

  @override
  String get oral => 'Oral';

  @override
  String get sublingual => 'Sublingual';

  @override
  String get patch => 'Adesivo';

  @override
  String get gel => 'Gel';

  @override
  String get implant => 'Implante';

  @override
  String get suppository => 'Supositório';

  @override
  String get transdermal => 'Spray transdérmico';

  @override
  String get chooseSchedule => 'Escolher um cronograma';

  @override
  String get addSchedulesFirst => 'Adicione cronogramas primeiro.';

  @override
  String get editIntake => 'Editar dose';

  @override
  String get date => 'Data';

  @override
  String get amount => 'Quantidade';

  @override
  String get none => 'Nenhum';

  @override
  String get supplyItem => 'Item de suprimento';

  @override
  String get injectionSide => 'Lado da injeção';

  @override
  String get deleteIntake => 'Excluir esta dose?';

  @override
  String todaySection(Object date) {
    return 'Hoje - $date';
  }

  @override
  String get allDone => 'Tudo pronto!';

  @override
  String get noIntakesDue => 'Nenhuma dose pendente hoje';

  @override
  String get upcoming => 'Próximos';

  @override
  String takeMedication(Object scheduleName) {
    return 'Tomar $scheduleName';
  }

  @override
  String get takeIntake => 'Registrar dose';

  @override
  String get needleDeadSpace => 'Espaço morto da agulha';

  @override
  String get microliters => 'μL';

  @override
  String get addSchedule => 'Adicionar cronograma';

  @override
  String get addScheduleToGetStarted => 'Adicione um cronograma para começar.';

  @override
  String get newSchedule => 'Novo cronograma';

  @override
  String get next => 'Próximo';

  @override
  String get every => 'A cada';

  @override
  String get days => 'dias';

  @override
  String get startDate => 'Data de início';

  @override
  String get editScheduleInfo => 'Editar informações do cronograma';

  @override
  String get noNotifications => 'Sem notificações';

  @override
  String notificationsCount(Object count) {
    return '$count notificações';
  }

  @override
  String get editSchedule => 'Editar cronograma';

  @override
  String get deleteSchedule => 'Excluir este cronograma?';

  @override
  String get scheduleNotifications => 'Notificações do cronograma';

  @override
  String get addNotification => 'Adicionar notificação';

  @override
  String noNotificationsForSchedule(Object scheduleName) {
    return 'Sem notificações para $scheduleName. Você pode adicionar uma usando o botão Adicionar.';
  }

  @override
  String get today => 'Hoje';

  @override
  String get taken => 'tomado';

  @override
  String get daysAgo => 'dias atrás';

  @override
  String get inText => 'em';

  @override
  String get lastTaken => 'Última dose';

  @override
  String get neverTakenYet => 'Ainda não tomado';

  @override
  String get side => 'lado';

  @override
  String get enanthate => 'Enantato';

  @override
  String get valerate => 'Valerato';

  @override
  String get cypionate => 'Cipionato';

  @override
  String get undecylate => 'Undecilato';

  @override
  String get benzoate => 'Benzoato';

  @override
  String get cypionateSuspension => 'Suspensão de cipionato';
}
