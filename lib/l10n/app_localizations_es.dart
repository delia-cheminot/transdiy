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
  String get profileTitle => 'Configuración';

  @override
  String get intakesTitle => 'Tomas';

  @override
  String get levelsTitle => 'Niveles';

  @override
  String get suppliesTitle => 'Suministros';

  @override
  String get empty_home => 'Comienza agregando un horario en Configuración';

  @override
  String get empty_intakes => 'Las tomas registradas aparecerán aquí';

  @override
  String get empty_levels => 'Las inyecciones de estradiol se mostrarán en esta pestaña';

  @override
  String get empty_supplies => 'Sin suministros. Agrega un elemento para comenzar.';

  @override
  String get nav_home => 'Mona';

  @override
  String get nav_intakes => 'Tomas';

  @override
  String get nav_levels => 'Niveles';

  @override
  String get nav_supplies => 'Suministros';

  @override
  String get schedules => 'Horarios';

  @override
  String get noSchedules => 'Sin horarios';

  @override
  String schedulesCount(Object count) {
    return '$count creados';
  }

  @override
  String get notifications => 'Notificaciones';

  @override
  String notificationsEnabled(Object time) {
    return 'Activadas a las $time';
  }

  @override
  String get notificationsDisabled => 'Desactivadas';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String schedulesCreated(Object count) {
    return '$count creados';
  }

  @override
  String get english => 'Inglés';

  @override
  String get french => 'Francés';

  @override
  String get enableNotifications => 'Activar notificaciones';

  @override
  String get notificationsDisabledTitle => 'Las notificaciones están desactivadas';

  @override
  String get clickToOpenSettings => 'Haz clic para abrir la configuración';

  @override
  String get exactRemindersDisabled => 'Los recordatorios exactos están desactivados';

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
  String get notificationsUpdated => '¡Las notificaciones han sido actualizadas!';

  @override
  String get notificationsUpdatedDescription => 'Cada horario ahora tiene sus propias notificaciones.\n\nConfigura las notificaciones para tus horarios para asegurarte de no perder nada.';

  @override
  String get dontShowAgain => 'No mostrar de nuevo';

  @override
  String get scheduleSettings => 'Configuración del horario';

  @override
  String get newItem => 'Nuevo elemento';

  @override
  String get name => 'Nombre';

  @override
  String get molecule => 'Molécula';

  @override
  String get adminRoute => 'Vía de administración';

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
  String get totalAmount => 'Cantidad total';

  @override
  String get concentration => 'Concentración';

  @override
  String get editItem => 'Editar elemento';

  @override
  String get add => 'Agregar';

  @override
  String get save => 'Guardar';

  @override
  String get usedAmount => 'Cantidad usada';

  @override
  String get ester => 'Éster';

  @override
  String get deleteItem => '¿Eliminar este elemento?';

  @override
  String remaining(Object amount, Object unit) {
    return '$amount $unit restantes';
  }

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
  String get chooseSchedule => 'Elegir un horario';

  @override
  String get addSchedulesFirst => 'Agrega horarios primero.';

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
    return 'No hay notificaciones para $scheduleName. Puedes agregar una usando el botón Agregar.';
  }

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
}
