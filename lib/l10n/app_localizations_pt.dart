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
  String get nav_home => 'Mona';

  @override
  String get nav_intakes => 'Doses';

  @override
  String get nav_levels => 'Níveis';

  @override
  String get nav_supplies => 'Suprimentos';

  @override
  String get takeAnIntake => 'Registrar uma dose';

  @override
  String get addAnItem => 'Adicionar um item';

  @override
  String get empty_home => 'Comece adicionando um cronograma em Configurações';

  @override
  String get allDone => 'Tudo pronto!';

  @override
  String get noIntakesDue => 'Nenhuma dose pendente hoje';

  @override
  String get upcoming => 'Próximos';

  @override
  String get today => 'Hoje';

  @override
  String get taken => 'tomado';

  @override
  String daysAgoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'há $count dias',
      one: 'ontem',
    );
    return '$_temp0';
  }

  @override
  String inDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'em $count dias',
      one: 'amanhã',
    );
    return '$_temp0';
  }

  @override
  String get lastTaken => 'Última dose';

  @override
  String get neverTakenYet => 'Ainda não tomado';

  @override
  String get scheduleFrequencyDaily => 'Todos os dias';

  @override
  String scheduleFrequencyEveryNDays(Object days) {
    return 'A cada $days dias';
  }

  @override
  String get newUpdateAvailable => 'Uma nova atualização está disponível!';

  @override
  String get goToSettings => 'Ir para Configurações';

  @override
  String get deprecated => 'Obsoleto';

  @override
  String get legacyVersionMessage =>
      'Está a utilizar uma versão obsoleta de Mona. Por favor, atualize-a. Toque para saber mais.';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get notifications => 'Notificações';

  @override
  String get schedulesAndNotifications => 'Cronogramas e notificações';

  @override
  String get general => 'Geral';

  @override
  String get schedules => 'Cronogramas';

  @override
  String get noSchedules => 'Sem cronogramas';

  @override
  String schedulesCreated(Object count) {
    return '$count criados';
  }

  @override
  String get language => 'Idioma';

  @override
  String get languageFollowDevice => 'Seguir o idioma do dispositivo';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get enableNotifications => 'Ativar notificações';

  @override
  String get enableNotificationsDescription =>
      'Enviar lembretes dos cronogramas';

  @override
  String get notificationsDisabledTitle => 'As notificações estão desativadas';

  @override
  String get clickToOpenSettings => 'Toque para abrir as configurações';

  @override
  String get exactRemindersDisabled =>
      'Os horários exatos de lembrete estão desativados';

  @override
  String get remindersDelayed =>
      'Os lembretes podem atrasar um pouco. Toque para abrir as configurações.';

  @override
  String get autoUpdate => 'Atualização automática';

  @override
  String get autoUpdateDescription =>
      'Verificar automaticamente por atualizações ao iniciar o app';

  @override
  String get checkForUpdates => 'Verificar atualizações';

  @override
  String get checkForUpdatesDescription =>
      'Verificar manualmente a versão mais recente\nIsso se conectará à Internet\n(Nenhum dado será enviado)';

  @override
  String appVersion(Object version) {
    return 'Versão do Mona $version';
  }

  @override
  String backupSavedTo(Object path) {
    return 'Backup salvo em: $path';
  }

  @override
  String exportFailed(Object error) {
    return 'Falha ao exportar: $error';
  }

  @override
  String get importDataTitle => 'Importar dados';

  @override
  String get importDataSubtitle => 'Restaurar dados de um backup JSON';

  @override
  String get importDataOverwriteWarning =>
      'Isso substituirá todos os seus dados atuais pelo backup. Esta ação não pode ser desfeita. Deseja continuar?';

  @override
  String get importConfirm => 'Importar';

  @override
  String get importSuccessfulTitle => 'Importação concluída';

  @override
  String get importRestartRequired =>
      'Reinicie o app para aplicar os dados restaurados.';

  @override
  String get closeApp => 'Fechar app';

  @override
  String importFailed(Object error) {
    return 'Falha ao importar: $error';
  }

  @override
  String get updates => 'Atualizações';

  @override
  String get dataManagement => 'Gestão de dados';

  @override
  String get exportDataTitle => 'Exportar dados';

  @override
  String get exportDataSubtitle => 'Salve seus dados num ficheiro JSON';

  @override
  String get updateNoCompatibleApk =>
      'Não foi encontrada nenhuma atualização compatível com o seu dispositivo.';

  @override
  String get updateAppUpToDate => 'A sua aplicação está atualizada!';

  @override
  String get updateCheckNetworkError =>
      'Não foi possível verificar atualizações neste momento.';

  @override
  String get updateDialogTitle => 'Atualização disponível';

  @override
  String updateDialogBody(Object current, Object latest) {
    return 'A versão $latest está disponível! (Atual: $current)\n\nHá uma atualização compatível com o seu dispositivo pronta a instalar.';
  }

  @override
  String get updateDownloadAndInstall => 'Transferir e instalar';

  @override
  String get updateInstallPermissionRequired =>
      'É necessária permissão para instalar atualizações.';

  @override
  String get updateDownloadingTitle => 'A transferir atualização...';

  @override
  String updateFailedOpenInstaller(Object message) {
    return 'Falha ao abrir o instalador: $message';
  }

  @override
  String get updateDownloadFailed =>
      'Falha na transferência. Verifique a sua ligação.';

  @override
  String notificationMedicationReminderTitle(Object scheduleName) {
    return 'Hora de tomar $scheduleName';
  }

  @override
  String notificationMedicationReminderBody(Object dateTime) {
    return 'Agendado para $dateTime';
  }

  @override
  String get addSchedule => 'Adicionar cronograma';

  @override
  String get addScheduleToGetStarted => 'Adicione um cronograma para começar.';

  @override
  String get newSchedule => 'Novo cronograma';

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
  String deleteSchedule(Object name) {
    return 'Excluir $name?';
  }

  @override
  String get scheduleNotifications => 'Notificações do cronograma';

  @override
  String get addNotification => 'Adicionar notificação';

  @override
  String noNotificationsForSchedule(Object scheduleName) {
    return 'Sem notificações para $scheduleName. Você pode adicionar uma usando o botão Adicionar.';
  }

  @override
  String get notificationsUpdated => 'As notificações foram atualizadas!';

  @override
  String get notificationsUpdatedDescription =>
      'Cada cronograma agora tem suas próprias notificações.\n\nConfigure as notificações para seus cronogramas para garantir que você não perca nada.';

  @override
  String get dontShowAgain => 'Não mostrar novamente';

  @override
  String get scheduleSettings => 'Configurações do cronograma';

  @override
  String get empty_intakes => 'As doses registradas aparecerão aqui';

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
  String get empty_levels => 'As injeções de estradiol aparecerão nesta aba';

  @override
  String get bloodTestsTitle => 'Exames de sangue';

  @override
  String get empty_blood_tests =>
      'Os exames de sangue registados aparecem aqui. Comece pelo botão Adicionar!';

  @override
  String get addBloodTest => 'Adicionar exame de sangue';

  @override
  String get editBloodTest => 'Editar exame de sangue';

  @override
  String get newBloodTest => 'Novo exame de sangue';

  @override
  String get deleteBloodTest => 'Eliminar este exame de sangue?';

  @override
  String get estradiolLevelLabel => 'Nível de estradiol';

  @override
  String get testosteroneLevelLabel => 'Nível de testosterona';

  @override
  String get bloodTestDateLabel => 'Data do exame';

  @override
  String chartNowConcentration(Object value) {
    return 'Agora $value';
  }

  @override
  String chartBloodTestLevelTooltip(Object date, Object level) {
    return '$date: $level';
  }

  @override
  String get empty_supplies =>
      'Sem suprimentos. Adicione um item para começar.';

  @override
  String get newItem => 'Novo item';

  @override
  String get adminRoute => 'Via de administração';

  @override
  String get totalAmount => 'Quantidade total';

  @override
  String get concentration => 'Concentração';

  @override
  String get editItem => 'Editar item';

  @override
  String get usedAmount => 'Quantidade usada';

  @override
  String deleteItem(Object name) {
    return 'Excluir $name?';
  }

  @override
  String remaining(Object amount, Object unit) {
    return '$amount $unit restantes';
  }

  @override
  String get add => 'Adicionar';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get next => 'Próximo';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteElement => 'Eliminar este item?';

  @override
  String get irreversibleAction => 'Esta ação não pode ser desfeita.';

  @override
  String get name => 'Nome';

  @override
  String get molecule => 'Molécula';

  @override
  String get ester => 'Éster';

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
  String get pioglitazone => 'Pioglitazona';

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

  @override
  String get medicationEstradiolEnanthate => 'Enantato de estradiol';

  @override
  String get medicationEstradiolValerate => 'Valerato de estradiol';

  @override
  String get medicationEstradiolCypionate => 'Cipionato de estradiol';

  @override
  String get medicationEstradiolUndecylate => 'Undecilato de estradiol';

  @override
  String get medicationEstradiolBenzoate => 'Benzoato de estradiol';

  @override
  String get medicationEstradiolCypionateSuspension =>
      'Suspensão de cipionato de estradiol';

  @override
  String get medicationTestosteroneEnanthate => 'Enantato de testosterona';

  @override
  String get medicationTestosteroneValerate => 'Valerato de testosterona';

  @override
  String get medicationTestosteroneCypionate => 'Cipionato de testosterona';

  @override
  String get medicationTestosteroneUndecylate => 'Undecilato de testosterona';

  @override
  String get medicationTestosteroneBenzoate => 'Benzoato de testosterona';

  @override
  String get medicationTestosteroneCypionateSuspension =>
      'Suspensão de cipionato de testosterona';

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
      other: 'comprimidos',
      one: 'comprimido',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitPatch(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'adesivos',
      one: 'adesivo',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitPump(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'aplicações',
      one: 'aplicação',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitImplant(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'implantes',
      one: 'implante',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitSuppository(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'supositórios',
      one: 'supositório',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitSpray(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pulverizações',
      one: 'pulverização',
    );
    return '$_temp0';
  }

  @override
  String get injectionSideLeft => 'Esquerda';

  @override
  String get injectionSideRight => 'Direita';

  @override
  String get intakeSummaryInjectionSideLeft => 'Lado esquerdo';

  @override
  String get intakeSummaryInjectionSideRight => 'Lado direito';

  @override
  String get requiredField => 'Campo obrigatório';

  @override
  String get mustBePositiveNumber => 'Deve ser um número positivo';

  @override
  String get invalidTotalAmount => 'Quantidade total inválida';

  @override
  String get cannotExceedTotalCapacity => 'Não pode exceder a capacidade total';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'Mona';

  @override
  String get nav_home => 'Mona';

  @override
  String get nav_intakes => 'Doses';

  @override
  String get nav_levels => 'Níveis';

  @override
  String get nav_supplies => 'Suprimentos';

  @override
  String get takeAnIntake => 'Registrar uma dose';

  @override
  String get addAnItem => 'Adicionar um item';

  @override
  String get empty_home => 'Comece adicionando um cronograma em Configurações';

  @override
  String get allDone => 'Tudo pronto!';

  @override
  String get noIntakesDue => 'Nenhuma dose pendente hoje';

  @override
  String get upcoming => 'Próximos';

  @override
  String get today => 'Hoje';

  @override
  String get taken => 'tomado';

  @override
  String daysAgoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'há $count dias',
      one: 'ontem',
    );
    return '$_temp0';
  }

  @override
  String inDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'em $count dias',
      one: 'amanhã',
    );
    return '$_temp0';
  }

  @override
  String get lastTaken => 'Última dose';

  @override
  String get neverTakenYet => 'Ainda não tomado';

  @override
  String get scheduleFrequencyDaily => 'Todos os dias';

  @override
  String scheduleFrequencyEveryNDays(Object days) {
    return 'A cada $days dias';
  }

  @override
  String get newUpdateAvailable => 'Uma nova atualização está disponível!';

  @override
  String get goToSettings => 'Ir para Configurações';

  @override
  String get deprecated => 'Obsoleto';

  @override
  String get legacyVersionMessage =>
      'Está a utilizar uma versão obsoleta de Mona. Por favor, atualize-a. Toque para saber mais.';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get notifications => 'Notificações';

  @override
  String get schedulesAndNotifications => 'Cronogramas e notificações';

  @override
  String get general => 'Geral';

  @override
  String get schedules => 'Cronogramas';

  @override
  String get noSchedules => 'Sem cronogramas';

  @override
  String schedulesCreated(Object count) {
    return '$count criados';
  }

  @override
  String get language => 'Idioma';

  @override
  String get languageFollowDevice => 'Seguir o idioma do dispositivo';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get enableNotifications => 'Ativar notificações';

  @override
  String get enableNotificationsDescription =>
      'Enviar lembretes dos cronogramas';

  @override
  String get notificationsDisabledTitle => 'As notificações estão desativadas';

  @override
  String get clickToOpenSettings => 'Toque para abrir as configurações';

  @override
  String get exactRemindersDisabled =>
      'Os horários exatos de lembrete estão desativados';

  @override
  String get remindersDelayed =>
      'Os lembretes podem atrasar um pouco. Toque para abrir as configurações.';

  @override
  String get autoUpdate => 'Atualização automática';

  @override
  String get autoUpdateDescription =>
      'Verificar automaticamente por atualizações ao iniciar o app';

  @override
  String get checkForUpdates => 'Verificar atualizações';

  @override
  String get checkForUpdatesDescription =>
      'Verificar manualmente a versão mais recente\nIsso se conectará à Internet\n(Nenhum dado será enviado)';

  @override
  String appVersion(Object version) {
    return 'Versão do Mona $version';
  }

  @override
  String backupSavedTo(Object path) {
    return 'Backup salvo em: $path';
  }

  @override
  String exportFailed(Object error) {
    return 'Falha ao exportar: $error';
  }

  @override
  String get importDataTitle => 'Importar dados';

  @override
  String get importDataSubtitle => 'Restaurar dados de um backup JSON';

  @override
  String get importDataOverwriteWarning =>
      'Isso substituirá todos os seus dados atuais pelo backup. Esta ação não pode ser desfeita. Deseja continuar?';

  @override
  String get importConfirm => 'Importar';

  @override
  String get importSuccessfulTitle => 'Importação concluída';

  @override
  String get importRestartRequired =>
      'Reinicie o app para aplicar os dados restaurados.';

  @override
  String get closeApp => 'Fechar app';

  @override
  String importFailed(Object error) {
    return 'Falha ao importar: $error';
  }

  @override
  String get updates => 'Atualizações';

  @override
  String get dataManagement => 'Gerenciamento de dados';

  @override
  String get exportDataTitle => 'Exportar dados';

  @override
  String get exportDataSubtitle => 'Salve seus dados em um arquivo JSON';

  @override
  String get updateNoCompatibleApk =>
      'Nenhuma atualização compatível com seu dispositivo foi encontrada.';

  @override
  String get updateAppUpToDate => 'Seu app está atualizado!';

  @override
  String get updateCheckNetworkError =>
      'Não foi possível verificar atualizações no momento.';

  @override
  String get updateDialogTitle => 'Atualização disponível';

  @override
  String updateDialogBody(Object current, Object latest) {
    return 'A versão $latest está disponível! (Atual: $current)\n\nHá uma atualização compatível com seu dispositivo pronta para instalação.';
  }

  @override
  String get updateDownloadAndInstall => 'Baixar e instalar';

  @override
  String get updateInstallPermissionRequired =>
      'É necessária permissão para instalar atualizações.';

  @override
  String get updateDownloadingTitle => 'Baixando atualização...';

  @override
  String updateFailedOpenInstaller(Object message) {
    return 'Falha ao abrir o instalador: $message';
  }

  @override
  String get updateDownloadFailed =>
      'Falha no download. Verifique sua conexão.';

  @override
  String notificationMedicationReminderTitle(Object scheduleName) {
    return 'Hora de tomar $scheduleName';
  }

  @override
  String notificationMedicationReminderBody(Object dateTime) {
    return 'Agendado para $dateTime';
  }

  @override
  String get addSchedule => 'Adicionar cronograma';

  @override
  String get addScheduleToGetStarted => 'Adicione um cronograma para começar.';

  @override
  String get newSchedule => 'Novo cronograma';

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
  String deleteSchedule(Object name) {
    return 'Excluir $name?';
  }

  @override
  String get scheduleNotifications => 'Notificações do cronograma';

  @override
  String get addNotification => 'Adicionar notificação';

  @override
  String noNotificationsForSchedule(Object scheduleName) {
    return 'Sem notificações para $scheduleName. Você pode adicionar uma usando o botão Adicionar.';
  }

  @override
  String get notificationsUpdated => 'As notificações foram atualizadas!';

  @override
  String get notificationsUpdatedDescription =>
      'Cada cronograma agora tem suas próprias notificações.\n\nConfigure as notificações para seus cronogramas para garantir que você não perca nada.';

  @override
  String get dontShowAgain => 'Não mostrar novamente';

  @override
  String get scheduleSettings => 'Configurações do cronograma';

  @override
  String get empty_intakes => 'As doses registradas aparecerão aqui';

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
  String get empty_levels => 'As injeções de estradiol aparecerão nesta aba';

  @override
  String get bloodTestsTitle => 'Exames de sangue';

  @override
  String get empty_blood_tests =>
      'Os exames de sangue registrados aparecem aqui. Comece pelo botão Adicionar!';

  @override
  String get addBloodTest => 'Adicionar exame de sangue';

  @override
  String get editBloodTest => 'Editar exame de sangue';

  @override
  String get newBloodTest => 'Novo exame de sangue';

  @override
  String get deleteBloodTest => 'Excluir este exame de sangue?';

  @override
  String get estradiolLevelLabel => 'Nível de estradiol';

  @override
  String get testosteroneLevelLabel => 'Nível de testosterona';

  @override
  String get bloodTestDateLabel => 'Data do exame';

  @override
  String chartNowConcentration(Object value) {
    return 'Agora $value';
  }

  @override
  String chartBloodTestLevelTooltip(Object date, Object level) {
    return '$date: $level';
  }

  @override
  String get empty_supplies =>
      'Sem suprimentos. Adicione um item para começar.';

  @override
  String get newItem => 'Novo item';

  @override
  String get adminRoute => 'Via de administração';

  @override
  String get totalAmount => 'Quantidade total';

  @override
  String get concentration => 'Concentração';

  @override
  String get editItem => 'Editar item';

  @override
  String get usedAmount => 'Quantidade usada';

  @override
  String deleteItem(Object name) {
    return 'Excluir $name?';
  }

  @override
  String remaining(Object amount, Object unit) {
    return '$amount $unit restantes';
  }

  @override
  String get add => 'Adicionar';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get next => 'Próximo';

  @override
  String get delete => 'Excluir';

  @override
  String get deleteElement => 'Excluir este item?';

  @override
  String get irreversibleAction => 'Esta ação não pode ser desfeita.';

  @override
  String get name => 'Nome';

  @override
  String get molecule => 'Molécula';

  @override
  String get ester => 'Éster';

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
  String get pioglitazone => 'Pioglitazona';

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

  @override
  String get medicationEstradiolEnanthate => 'Enantato de estradiol';

  @override
  String get medicationEstradiolValerate => 'Valerato de estradiol';

  @override
  String get medicationEstradiolCypionate => 'Cipionato de estradiol';

  @override
  String get medicationEstradiolUndecylate => 'Undecilato de estradiol';

  @override
  String get medicationEstradiolBenzoate => 'Benzoato de estradiol';

  @override
  String get medicationEstradiolCypionateSuspension =>
      'Suspensão de cipionato de estradiol';

  @override
  String get medicationTestosteroneEnanthate => 'Enantato de testosterona';

  @override
  String get medicationTestosteroneValerate => 'Valerato de testosterona';

  @override
  String get medicationTestosteroneCypionate => 'Cipionato de testosterona';

  @override
  String get medicationTestosteroneUndecylate => 'Undecilato de testosterona';

  @override
  String get medicationTestosteroneBenzoate => 'Benzoato de testosterona';

  @override
  String get medicationTestosteroneCypionateSuspension =>
      'Suspensão de cipionato de testosterona';

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
      other: 'comprimidos',
      one: 'comprimido',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitPatch(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'adesivos',
      one: 'adesivo',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitPump(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'aplicações',
      one: 'aplicação',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitImplant(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'implantes',
      one: 'implante',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitSuppository(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'supositórios',
      one: 'supositório',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitSpray(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pulverizações',
      one: 'pulverização',
    );
    return '$_temp0';
  }

  @override
  String get injectionSideLeft => 'Esquerda';

  @override
  String get injectionSideRight => 'Direita';

  @override
  String get intakeSummaryInjectionSideLeft => 'Lado esquerdo';

  @override
  String get intakeSummaryInjectionSideRight => 'Lado direito';

  @override
  String get requiredField => 'Campo obrigatório';

  @override
  String get mustBePositiveNumber => 'Deve ser um número positivo';

  @override
  String get invalidTotalAmount => 'Quantidade total inválida';

  @override
  String get cannotExceedTotalCapacity => 'Não pode exceder a capacidade total';
}
