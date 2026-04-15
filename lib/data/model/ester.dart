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

  String localizedName(AppLocalizations localizations) =>
      _EsterLocalization.localize(this, localizations);

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

abstract final class _EsterLocalization {
  static final _strategies = {
    Ester.enanthate.name: (l) => l.enanthate,
    Ester.valerate.name: (l) => l.valerate,
    Ester.cypionate.name: (l) => l.cypionate,
    Ester.undecylate.name: (l) => l.undecylate,
    Ester.benzoate.name: (l) => l.benzoate,
    Ester.cypionateSuspension.name: (l) => l.cypionateSuspension,
  };

  static String localize(Ester ester, AppLocalizations l10n) {
    final strategy = _strategies[ester.name];
    if (strategy != null) return strategy(l10n);
    return ester.name[0].toUpperCase() + ester.name.substring(1);
  }
}
