import 'package:mona/data/model/administration_route.dart';
import 'package:mona/l10n/app_localizations.dart';

extension AdministrationRouteL10n on AdministrationRoute {
  String localizedName(AppLocalizations localizations) =>
      _AdministrationRouteDisplayNames.resolve(this, localizations);

  String localizedUnit(AppLocalizations localizations, num count) =>
      _AdministrationRouteUnits.resolve(this, localizations, count);
}

abstract final class _AdministrationRouteDisplayNames {
  static final Map<String, String Function(AppLocalizations)> _labelsByName = {
    AdministrationRoute.injection.name: (l) => l.injection,
    AdministrationRoute.oral.name: (l) => l.oral,
    AdministrationRoute.sublingual.name: (l) => l.sublingual,
    AdministrationRoute.patch.name: (l) => l.patch,
    AdministrationRoute.gel.name: (l) => l.gel,
    AdministrationRoute.implant.name: (l) => l.implant,
    AdministrationRoute.suppository.name: (l) => l.suppository,
    AdministrationRoute.transdermalSpray.name: (l) => l.transdermal,
  };

  static String resolve(
    AdministrationRoute route,
    AppLocalizations localizations,
  ) {
    final labelBuilder = _labelsByName[route.name];
    if (labelBuilder != null) {
      return labelBuilder(localizations);
    }
    final n = route.name;
    return n[0].toUpperCase() + n.substring(1);
  }
}

abstract final class _AdministrationRouteUnits {
  static final Map<String, String Function(AppLocalizations l, num count)>
      _labelsByName = {
    AdministrationRoute.injection.name: (l, c) =>
        l.administrationRouteUnitMl(c),
    AdministrationRoute.oral.name: (l, c) => l.administrationRouteUnitPill(c),
    AdministrationRoute.sublingual.name: (l, c) =>
        l.administrationRouteUnitPill(c),
    AdministrationRoute.patch.name: (l, c) => l.administrationRouteUnitPatch(c),
    AdministrationRoute.gel.name: (l, c) => l.administrationRouteUnitPump(c),
    AdministrationRoute.implant.name: (l, c) =>
        l.administrationRouteUnitImplant(c),
    AdministrationRoute.suppository.name: (l, c) =>
        l.administrationRouteUnitSuppository(c),
    AdministrationRoute.transdermalSpray.name: (l, c) =>
        l.administrationRouteUnitSpray(c),
  };

  static String resolve(
    AdministrationRoute route,
    AppLocalizations localizations,
    num count,
  ) {
    final labelBuilder = _labelsByName[route.name];
    if (labelBuilder != null) {
      return labelBuilder(localizations, count);
    }
    return route.unit;
  }
}
