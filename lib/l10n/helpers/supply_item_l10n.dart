import 'package:mona/data/model/supply_item.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/l10n/helpers/molecule_l10n.dart';

extension SupplyItemL10n on SupplyItem {
  String localizedSummary(AppLocalizations localizations) {
    return '${molecule.localizedNameWithEster(ester, localizations)} • '
        '$concentration ${molecule.unit}/${administrationRoute.unit}';
  }
}
