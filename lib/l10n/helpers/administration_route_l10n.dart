import 'package:flutter/material.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/l10n/app_localizations.dart';

extension AdministrationRouteL10n on AdministrationRoute {
  String localizedName(AppLocalizations localizations) =>
      _AdministrationRouteDisplayNames.resolve(this, localizations);
}

// TODO move ui stuff to a better place
List<DropdownMenuItem<AdministrationRoute>>
    administrationRouteDropdownMenuItems(
  AppLocalizations localizations,
) =>
        AdministrationRoute.all
            .map(
              (route) => DropdownMenuItem<AdministrationRoute>(
                value: route,
                child: Text(route.localizedName(localizations)),
              ),
            )
            .toList();

abstract final class _AdministrationRouteDisplayNames {
  static final Map<String, String Function(AppLocalizations)> _labelsByName = {
    AdministrationRoute.injection.name: (l) => l.injection,
    AdministrationRoute.oral.name: (l) => l.oral,
    AdministrationRoute.sublingual.name: (l) => l.sublingual,
    AdministrationRoute.patch.name: (l) => l.patch,
    AdministrationRoute.gel.name: (l) => l.gel,
    AdministrationRoute.implant.name: (l) => l.implant,
    AdministrationRoute.suppository.name: (l) => l.suppository,
    AdministrationRoute.transdermal.name: (l) => l.transdermal,
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
