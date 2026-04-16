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
  String todaySection(Object date) {
    return 'Hoy - $date';
  }

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
  String get daysAgo => 'días atrás';

  @override
  String get inText => 'en';

  @override
  String get lastTaken => 'Última toma';

  @override
  String get neverTakenYet => 'Aún no tomado';

  @override
  String get side => 'lado';

  @override
  String get scheduleFrequencyDaily => 'Cada día';

  @override
  String scheduleFrequencyEveryNDays(Object days) {
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
  String schedulesCreated(Object count) {
    return '$count creados';
  }

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get enableNotifications => 'Activar notificaciones';

  @override
  String get enableNotificationsDescription => 'Enviar recordatorios para los horarios';

  @override
  String get notificationsDisabledTitle => 'Las notificaciones están desactivadas';

  @override
  String get clickToOpenSettings => 'Haz clic para abrir la configuración';

  @override
  String get exactRemindersDisabled => 'Hora exacta de los recordatorios desactivada';

  @override
  String get remindersDelayed => 'Los recordatorios pueden retrasarse ligeramente. Toca para abrir la configuración.';

  @override
  String get autoUpdate => 'Actualización automática';

  @override
  String get autoUpdateDescription => 'Buscar automáticamente nuevas actualizaciones al iniciar la aplicación';

  @override
  String get checkForUpdates => 'Buscar actualizaciones';

  @override
  String get checkForUpdatesDescription => 'Buscar manualmente la última versión\nEsto se conectará a Internet\n(No se enviarán datos)';

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
  String get importDataOverwriteWarning => 'Esto sobrescribirá todos tus datos actuales con la copia de seguridad. Esta acción no se puede deshacer. ¿Deseas continuar?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get importConfirm => 'Importar';

  @override
  String get importSuccessfulTitle => 'Importación correcta';

  @override
  String get importRestartRequired => 'Reinicia la aplicación para aplicar los datos restaurados.';

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
  String get addSchedule => 'Agregar un horario';

  @override
  String get addScheduleToGetStarted => 'Agrega un horario para comenzar.';

  @override
  String get newSchedule => 'Nuevo horario';

  @override
  String get next => 'Siguiente';

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
  String notificationsCount(Object count) {
    return '$count notificaciones';
  }

  @override
  String get editSchedule => 'Editar horario';

  @override
  String get deleteSchedule => '¿Eliminar este horario?';

  @override
  String get scheduleNotifications => 'Notificaciones del horario';

  @override
  String get addNotification => 'Agregar una notificación';

  @override
  String noNotificationsForSchedule(Object scheduleName) {
    return 'No hay notificaciones para $scheduleName. Puedes añadir una usando el botón Añadir.';
  }

  @override
  String get notificationsUpdated => '¡Las notificaciones han sido actualizadas!';

  @override
  String get notificationsUpdatedDescription => 'Cada horario ahora tiene sus propias notificaciones.\n\nConfigura las notificaciones de tus horarios para no perderte nada.';

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
  String get empty_levels => 'Las inyecciones de estradiol se mostrarán en esta pestaña';

  @override
  String get empty_supplies => 'Sin suministros. Añade un elemento para comenzar.';

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
  String get deleteItem => '¿Eliminar este elemento?';

  @override
  String remaining(Object amount, Object unit) {
    return '$amount $unit restantes';
  }

  @override
  String get add => 'Añadir';

  @override
  String get save => 'Guardar';

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
  String get medicationEstradiolCypionateSuspension => 'Suspensión de cipionato de estradiol';

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
  String get medicationTestosteroneCypionateSuspension => 'Suspensión de cipionato de testosterona';

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
  String get injectionSideLeft => 'Izquierda';

  @override
  String get injectionSideRight => 'Derecha';
}
