import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/l10n/helpers/administration_route_l10n.dart';
import 'package:mona/l10n/helpers/molecule_l10n.dart';

extension MedicationScheduleL10n on MedicationSchedule {
  String localizedSummary(AppLocalizations localizations) {
    final firstLine =
        '$dose ${molecule.unit} • ${molecule.localizedNameWithEster(ester, localizations)} • '
        '${administrationRoute.localizedName(localizations)}';
    final secondLine = intervalDays == 1
        ? localizations.scheduleFrequencyDaily
        : localizations.scheduleFrequencyEveryNDays(intervalDays);
    return '$firstLine\n$secondLine';
  }
}
