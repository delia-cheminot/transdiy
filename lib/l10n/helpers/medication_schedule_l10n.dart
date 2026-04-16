import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/l10n/helpers/administration_route_l10n.dart';
import 'package:mona/l10n/helpers/molecule_l10n.dart';

String localizedMedicationScheduleSummary(
  MedicationSchedule schedule,
  AppLocalizations localizations,
) {
  final firstLine =
      '${schedule.dose} ${schedule.molecule.unit} • ${schedule.molecule.localizedNameWithEster(schedule.ester, localizations)} • '
      '${schedule.administrationRoute.localizedName(localizations)}';
  final secondLine = schedule.intervalDays == 1
      ? localizations.scheduleFrequencyDaily
      : localizations.scheduleFrequencyEveryNDays(schedule.intervalDays);
  return '$firstLine\n$secondLine';
}
