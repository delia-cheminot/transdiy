import 'package:flutter/material.dart';
import 'package:mona/l10n/app_localizations.dart';

class Ester {
  final String name;

  const Ester({
    required this.name,
  });

  static const enanthate = Ester(name: "enanthate");
  static const valerate = Ester(name: "valerate");
  static const cypionate = Ester(name: "cypionate");
  static const undecylate = Ester(name: "undecylate");
  static const benzoate = Ester(name: "benzoate");
  static const cypionateSuspension = Ester(name: "cypionate suspension");

  static const List<Ester> all = [
    enanthate,
    valerate,
    cypionate,
    undecylate,
    benzoate,
    cypionateSuspension,
  ];

  static Ester? fromName(String? name) {
    if (name == null) return null;
    return all.firstWhere((ester) => ester.name == name);
  }

  String localizedName(AppLocalizations localizations) {
    switch (name) {
      case 'enanthate':
        return localizations.enanthate;
      case 'valerate':
        return localizations.valerate;
      case 'cypionate':
        return localizations.cypionate;
      case 'undecylate':
        return localizations.undecylate;
      case 'benzoate':
        return localizations.benzoate;
      case 'cypionate suspension':
        return localizations.cypionateSuspension;
      default:
        return name[0].toUpperCase() + name.substring(1);
    }
  }

  static List<DropdownMenuItem<Ester>> menuItems(
          AppLocalizations localizations) =>
      all
          .map(
            (ester) => DropdownMenuItem<Ester>(
              value: ester,
              child: Text(ester.localizedName(localizations)),
            ),
          )
          .toList();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Ester && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
