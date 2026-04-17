import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/l10n/helpers/administration_route_l10n.dart';
import 'package:mona/l10n/helpers/injection_side_l10n.dart';
import 'package:mona/l10n/helpers/molecule_l10n.dart';

extension MedicationIntakeL10n on MedicationIntake {
  String localizedSummary(AppLocalizations localizations) {
    final firstLine =
        '$dose ${molecule.unit} • ${molecule.localizedNameWithEster(ester, localizations)} • '
        '${administrationRoute.localizedName(localizations)}';
    if (side == null) return firstLine;
    return '$firstLine • ${side!.localizedSideSummary(localizations)}';
  }
}
