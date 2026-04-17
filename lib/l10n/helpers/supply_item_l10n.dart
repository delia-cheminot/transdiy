import 'package:mona/data/model/supply_item.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/l10n/helpers/administration_route_l10n.dart';
import 'package:mona/l10n/helpers/molecule_l10n.dart';

extension SupplyItemL10n on SupplyItem {
  String localizedSummary(AppLocalizations localizations) {
    final amountRemaining = getAmount(remainingDose);
    final routeUnitRemaining = administrationRoute.localizedUnit(
      localizations,
      amountRemaining.toDouble(),
    );
    final headline = '${molecule.localizedNameWithEster(ester, localizations)} • '
        '$concentration ${molecule.unit}/${administrationRoute.localizedUnit(localizations, 1)}';
    final remainingLine = localizations.remaining(
      amountRemaining.toString(),
      routeUnitRemaining,
    );
    return '$headline\n$remainingLine';
  }
}
