import 'package:flutter/material.dart';

class AdministrationRoute {
  final String name;
  final String unit;

  const AdministrationRoute({
    required this.name,
    required this.unit,
  });

  static const injection = AdministrationRoute(
    name: 'injection',
    unit: 'ml',
  );
  static const oral = AdministrationRoute(
    name: 'oral',
    unit: 'pill',
  );
  static const sublingual = AdministrationRoute(
    name: 'sublingual',
    unit: 'pill',
  );
  static const patch = AdministrationRoute(
    name: 'patch',
    unit: 'patch',
  );
  static const gel = AdministrationRoute(
    name: 'gel',
    unit: 'pump',
  );
  static const implant = AdministrationRoute(
    name: 'implant',
    unit: 'implant',
  );
  static const suppository = AdministrationRoute(
    name: 'suppository',
    unit: 'suppository',
  );

  static const List<AdministrationRoute> all = [
    injection,
    oral,
    sublingual,
    patch,
    gel,
    implant,
    suppository,
  ];

  static AdministrationRoute fromName(String name) {
    return all.firstWhere((route) => route.name == name);
  }

  static List<DropdownMenuItem<AdministrationRoute>> get menuItems => all
      .map(
        (route) => DropdownMenuItem<AdministrationRoute>(
          value: route,
          child: Text(
            route.name[0].toUpperCase() + route.name.substring(1),
          ),
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
