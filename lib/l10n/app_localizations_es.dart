// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mona';

  @override
  String get nav_home => 'Mona';

  @override
  String get nav_intakes => 'Tomas';

  @override
  String get nav_levels => 'Niveles';

  @override
  String get nav_supplies => 'Suministros';

  @override
  String get takeAnIntake => 'Registrar una toma';

  @override
  String get addAnItem => 'Añadir un elemento';

  @override
  String get empty_home => 'Comienza añadiendo un horario en Configuración';

  @override
  String get allDone => '¡Todo listo!';

  @override
  String get noIntakesDue => 'No hay tomas pendientes hoy';

  @override
  String get upcoming => 'Próximamente';

  @override
  String get today => 'Hoy';

  @override
  String get taken => 'tomado';

  @override
  String daysAgoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count días',
      one: 'ayer',
    );
    return '$_temp0';
  }

  @override
  String inDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'en $count días',
      one: 'mañana',
    );
    return '$_temp0';
  }

  @override
  String get lastTaken => 'Última toma';

  @override
  String get neverTakenYet => 'Aún no tomado';

  @override
  String get scheduleFrequencyDaily => 'Cada día';

  @override
  String scheduleFrequencyEveryNDays(num days) {
    return 'Cada $days días';
  }

  @override
  String get newUpdateAvailable => '¡Hay una nueva actualización disponible!';

  @override
  String get goToSettings => 'Ir a Configuración';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get schedulesAndNotifications => 'Horarios y notificaciones';

  @override
  String get general => 'General';

  @override
  String get schedules => 'Horarios';

  @override
  String get noSchedules => 'Sin horarios';

  @override
  String schedulesCreated(num count) {
    return '$count creados';
  }

  @override
  String get language => 'Idioma';

  @override
  String get languageFollowDevice => 'Seguir el idioma del dispositivo';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get enableNotifications => 'Activar notificaciones';

  @override
  String get enableNotificationsDescription =>
      'Enviar recordatorios para los horarios';

  @override
  String get notificationsDisabledTitle =>
      'Las notificaciones están desactivadas';

  @override
  String get clickToOpenSettings => 'Haz clic para abrir la configuración';

  @override
  String get exactRemindersDisabled =>
      'Hora exacta de los recordatorios desactivada';

  @override
  String get remindersDelayed =>
      'Los recordatorios pueden retrasarse ligeramente. Toca para abrir la configuración.';

  @override
  String get autoUpdate => 'Actualización automática';

  @override
  String get autoUpdateDescription =>
      'Buscar automáticamente nuevas actualizaciones al iniciar la aplicación';

  @override
  String get checkForUpdates => 'Buscar actualizaciones';

  @override
  String get checkForUpdatesDescription =>
      'Buscar manualmente la última versión\nEsto se conectará a Internet\n(No se enviarán datos)';

  @override
  String appVersion(Object version) {
    return 'Versión de Mona $version';
  }

  @override
  String backupSavedTo(Object path) {
    return 'Copia de seguridad guardada en: $path';
  }

  @override
  String exportFailed(Object error) {
    return 'Error al exportar: $error';
  }

  @override
  String get importDataTitle => 'Importar datos';

  @override
  String get importDataSubtitle => 'Restaurar datos desde una copia JSON';

  @override
  String get importDataOverwriteWarning =>
      'Esto sobrescribirá todos tus datos actuales con la copia de seguridad. Esta acción no se puede deshacer. ¿Deseas continuar?';

  @override
  String get importConfirm => 'Importar';

  @override
  String get importSuccessfulTitle => 'Importación correcta';

  @override
  String get importRestartRequired =>
      'Reinicia la aplicación para aplicar los datos restaurados.';

  @override
  String get closeApp => 'Cerrar aplicación';

  @override
  String importFailed(Object error) {
    return 'Error al importar: $error';
  }

  @override
  String get updates => 'Actualizaciones';

  @override
  String get dataManagement => 'Gestión de datos';

  @override
  String get exportDataTitle => 'Exportar datos';

  @override
  String get exportDataSubtitle => 'Guarda tus datos en un archivo JSON';

  @override
  String get updateNoCompatibleApk =>
      'No se encontró ninguna actualización compatible con tu dispositivo.';

  @override
  String get updateAppUpToDate => '¡Tu aplicación está actualizada!';

  @override
  String get updateCheckNetworkError =>
      'No se pudieron comprobar las actualizaciones en este momento.';

  @override
  String get updateDialogTitle => 'Actualización disponible';

  @override
  String updateDialogBody(Object current, Object latest) {
    return '¡La versión $latest está disponible! (Actual: $current)\n\nHay una actualización compatible con tu dispositivo lista para instalarse.';
  }

  @override
  String get updateDownloadAndInstall => 'Descargar e instalar';

  @override
  String get updateInstallPermissionRequired =>
      'Se necesita permiso para instalar actualizaciones.';

  @override
  String get updateDownloadingTitle => 'Descargando actualización...';

  @override
  String updateFailedOpenInstaller(Object message) {
    return 'No se pudo abrir el instalador: $message';
  }

  @override
  String get updateDownloadFailed =>
      'Error en la descarga. Comprueba tu conexión.';

  @override
  String notificationMedicationReminderTitle(Object scheduleName) {
    return 'Es hora de tomar $scheduleName';
  }

  @override
  String notificationMedicationReminderBody(Object dateTime) {
    return 'Programado para $dateTime';
  }

  @override
  String get addSchedule => 'Agregar un horario';

  @override
  String get addScheduleToGetStarted => 'Agrega un horario para comenzar.';

  @override
  String get newSchedule => 'Nuevo horario';

  @override
  String get every => 'Cada';

  @override
  String get days => 'días';

  @override
  String get startDate => 'Fecha de inicio';

  @override
  String get editScheduleInfo => 'Editar información del horario';

  @override
  String get noNotifications => 'Sin notificaciones';

  @override
  String notificationsCount(num count) {
    return '$count notificaciones';
  }

  @override
  String get editSchedule => 'Editar horario';

  @override
  String deleteSchedule(Object name) {
    return '¿Eliminar $name?';
  }

  @override
  String get scheduleNotifications => 'Notificaciones del horario';

  @override
  String get addNotification => 'Agregar una notificación';

  @override
  String noNotificationsForSchedule(Object scheduleName) {
    return 'No hay notificaciones para $scheduleName. Puedes añadir una usando el botón Añadir.';
  }

  @override
  String get notificationsUpdated =>
      '¡Las notificaciones han sido actualizadas!';

  @override
  String get notificationsUpdatedDescription =>
      'Cada horario ahora tiene sus propias notificaciones.\n\nConfigura las notificaciones de tus horarios para no perderte nada.';

  @override
  String get dontShowAgain => 'No mostrar de nuevo';

  @override
  String get scheduleSettings => 'Configuración del horario';

  @override
  String get empty_intakes => 'Las dosis tomadas aparecerán aquí';

  @override
  String get chooseSchedule => 'Elegir un horario';

  @override
  String get addSchedulesFirst => 'Añade algún horario primero.';

  @override
  String get editIntake => 'Editar toma';

  @override
  String get date => 'Fecha';

  @override
  String get amount => 'Cantidad';

  @override
  String get none => 'Ninguno';

  @override
  String get supplyItem => 'Elemento de suministro';

  @override
  String get injectionSide => 'Lado de inyección';

  @override
  String get deleteIntake => '¿Eliminar esta toma?';

  @override
  String takeMedication(Object scheduleName) {
    return 'Tomar $scheduleName';
  }

  @override
  String get takeIntake => 'Registrar toma';

  @override
  String get needleDeadSpace => 'Espacio muerto de la aguja';

  @override
  String get microliters => 'μL';

  @override
  String get empty_levels =>
      'Las inyecciones de estradiol se mostrarán en esta pestaña';

  @override
  String get bloodTestsTitle => 'Análisis de sangre';

  @override
  String get empty_blood_tests =>
      'Los análisis de sangre registrados aparecerán aquí. ¡Empieza con el botón Añadir!';

  @override
  String get addBloodTest => 'Añadir un análisis de sangre';

  @override
  String get editBloodTest => 'Editar análisis de sangre';

  @override
  String get newBloodTest => 'Nuevo análisis de sangre';

  @override
  String get deleteBloodTest => '¿Eliminar este análisis de sangre?';

  @override
  String get estradiolLevelLabel => 'Nivel de estradiol';

  @override
  String get testosteroneLevelLabel => 'Nivel de testosterona';

  @override
  String get bloodTestDateLabel => 'Fecha del análisis';

  @override
  String chartNowConcentration(Object value) {
    return 'Ahora $value';
  }

  @override
  String chartBloodTestLevelTooltip(Object date, Object level) {
    return '$date: $level';
  }

  @override
  String get empty_supplies =>
      'Sin suministros. Añade un elemento para comenzar.';

  @override
  String get newItem => 'Nuevo elemento';

  @override
  String get adminRoute => 'Vía de administración';

  @override
  String get totalAmount => 'Cantidad total';

  @override
  String get concentration => 'Concentración';

  @override
  String get editItem => 'Editar elemento';

  @override
  String get usedAmount => 'Cantidad usada';

  @override
  String deleteItem(Object name) {
    return '¿Eliminar $name?';
  }

  @override
  String remaining(num amount, Object unit) {
    return '$amount $unit restantes';
  }

  @override
  String get add => 'Añadir';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get next => 'Siguiente';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteElement => '¿Eliminar este elemento?';

  @override
  String get irreversibleAction => 'Esta acción no se puede deshacer.';

  @override
  String get name => 'Nombre';

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
  String get cypionateSuspension => 'Suspensión de cipionato';

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
      'Suspensión de cipionato de estradiol';

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
      'Suspensión de cipionato de testosterona';

  @override
  String get injection => 'Inyección';

  @override
  String get oral => 'Oral';

  @override
  String get sublingual => 'Sublingual';

  @override
  String get patch => 'Parche';

  @override
  String get gel => 'Gel';

  @override
  String get implant => 'Implante';

  @override
  String get suppository => 'Supositorio';

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
      other: 'pastillas',
      one: 'pastilla',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitPatch(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'parches',
      one: 'parche',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitPump(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pulsaciones',
      one: 'pulsación',
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
      other: 'supositorios',
      one: 'supositorio',
    );
    return '$_temp0';
  }

  @override
  String administrationRouteUnitSpray(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pulverizaciones',
      one: 'pulverización',
    );
    return '$_temp0';
  }

  @override
  String get injectionSideLeft => 'Izquierda';

  @override
  String get injectionSideRight => 'Derecha';

  @override
  String get intakeSummaryInjectionSideLeft => 'Lado izquierdo';

  @override
  String get intakeSummaryInjectionSideRight => 'Lado derecho';

  @override
  String get requiredField => 'Campo obligatorio';

  @override
  String get mustBePositiveNumber => 'Debe ser un número positivo';

  @override
  String get invalidTotalAmount => 'Cantidad total no válida';

  @override
  String get cannotExceedTotalCapacity => 'No puede superar la capacidad total';
}
