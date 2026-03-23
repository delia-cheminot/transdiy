import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:mona/l10n/app_localizations.dart';

class AdministrationRoute {
  final String name;
  final String unit;
  final IconData icon;

  const AdministrationRoute({
    required this.name,
    required this.unit,
    required this.icon,
  });

  static const injection = AdministrationRoute(
    name: 'injection',
    unit: 'ml',
    icon: Symbols.syringe,
  );
  static const oral = AdministrationRoute(
    name: 'oral',
    unit: 'pill',
    icon: Symbols.pill,
  );
  static const sublingual = AdministrationRoute(
    name: 'sublingual',
    unit: 'pill',
    icon: Symbols.pill,
  );
  static const patch = AdministrationRoute(
    name: 'patch',
    unit: 'patch',
    icon: Symbols.sticker,
  );
  static const gel = AdministrationRoute(
    name: 'gel',
    unit: 'pump',
    icon: Symbols.sanitizer,
  );
  static const implant = AdministrationRoute(
    name: 'implant',
    unit: 'implant',
    icon: Symbols.syringe,
  );
  static const suppository = AdministrationRoute(
    name: 'suppository',
    unit: 'suppository',
    icon: Symbols.pill,
  );
  static const transdermal = AdministrationRoute(
    name: 'transdermal spray',
    unit: 'spray',
    icon: Symbols.fragrance,
  );

  static const List<AdministrationRoute> all = [
    injection,
    oral,
    sublingual,
    patch,
    gel,
    implant,
    suppository,
    transdermal,
  ];

  static AdministrationRoute fromName(String name) {
    return all.firstWhere((route) => route.name == name);
  }

  String localizedName(AppLocalizations localizations) {
    switch (name) {
      case 'injection':
        return localizations.injection;
      case 'oral':
        return localizations.oral;
      case 'sublingual':
        return localizations.sublingual;
      case 'patch':
        return localizations.patch;
      case 'gel':
        return localizations.gel;
      case 'implant':
        return localizations.implant;
      case 'suppository':
        return localizations.suppository;
      case 'transdermal spray':
        return localizations.transdermal;
      default:
        return name[0].toUpperCase() + name.substring(1);
    }
  }

  static List<DropdownMenuItem<AdministrationRoute>> menuItems(
          AppLocalizations localizations) =>
      all
          .map(
            (route) => DropdownMenuItem<AdministrationRoute>(
              value: route,
              child: Text(route.localizedName(localizations)),
            ),
          )
          .toList();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdministrationRoute && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
