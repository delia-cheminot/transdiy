import 'package:flutter/material.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/l10n/helpers/administration_route_l10n.dart';

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
