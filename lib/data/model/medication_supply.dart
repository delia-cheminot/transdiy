import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/data/model/supply.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/util/string_parsing.dart';
import 'package:mona/util/validators.dart';

class MedicationSupply implements Supply {
  @override
  final int id;
  @override
  final String name;
  final Decimal totalDose;
  final Decimal usedDose;
  final Decimal concentration;
  // TODO remove quantity
  @override
  final int quantity;
  final Molecule molecule;
  final AdministrationRoute administrationRoute;
  final Ester? ester;
  @override
  final SupplyType type = SupplyType.medication;

  MedicationSupply({
    int? id,
    required this.name,
    required this.totalDose,
    required this.concentration,
    Decimal? usedDose,
    this.quantity = 1,
    required this.molecule,
    required this.administrationRoute,
    this.ester,
  })  : usedDose = usedDose ?? Decimal.zero,
        id = id ?? DateTime.now().millisecondsSinceEpoch;

  factory MedicationSupply.fromMap(Map<String, Object?> map) {
    return MedicationSupply(
      id: map['id'] as int?,
      name: map['name'] as String,
      totalDose: (map['totalDose'] as String).toDecimal,
      usedDose: (map['usedDose'] as String).toDecimal,
      concentration: (map['concentration'] as String).toDecimal,
      quantity: map['quantity'] as int,
      molecule: Molecule.fromJson(jsonDecode(map['moleculeJson'] as String)),
      administrationRoute: AdministrationRoute.fromName(
          map['administrationRouteName'] as String),
      ester: Ester.fromName(map['esterName'] as String?),
    );
  }

  bool get isUsed => usedDose > Decimal.zero;
  bool get isInStock => quantity > 0;
  Decimal get remainingDose => totalDose - usedDose;

  bool isValid() {
    return totalDose > Decimal.zero &&
        usedDose >= Decimal.zero &&
        usedDose <= totalDose &&
        name != '' &&
        concentration > Decimal.zero;
  }

  bool canUseDose(Decimal doseToUse) {
    return usedDose + doseToUse <= totalDose;
  }

  double getRatio() {
    return (remainingDose *
            totalDose.inverse.toDecimal(scaleOnInfinitePrecision: 10))
        .toDouble();
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'totalDose': totalDose.toString(),
      'usedDose': usedDose.toString(),
      'concentration': concentration.toString(),
      'quantity': quantity,
      'moleculeJson': jsonEncode(molecule.toJson()),
      'administrationRouteName': administrationRoute.name,
      'esterName': ester?.name,
      'type': type.name,
    };
  }

  Decimal getAmount(Decimal dose) =>
      (dose.toRational() / concentration.toRational())
          .toDecimal(scaleOnInfinitePrecision: 3);

  Decimal getDose(Decimal amount) => amount * concentration;

  MedicationSupply copyWith({
    int? id,
    String? name,
    Decimal? totalDose,
    Decimal? usedDose,
    Decimal? concentration,
    int? quantity,
    Molecule? molecule,
    AdministrationRoute? administrationRoute,
    Ester? ester,
    bool clearEster = false,
  }) {
    return MedicationSupply(
      id: id ?? this.id,
      name: name ?? this.name,
      totalDose: totalDose ?? this.totalDose,
      usedDose: usedDose ?? this.usedDose,
      concentration: concentration ?? this.concentration,
      quantity: quantity ?? this.quantity,
      molecule: molecule ?? this.molecule,
      administrationRoute: administrationRoute ?? this.administrationRoute,
      ester: clearEster ? null : (ester ?? this.ester),
    );
  }

  static String? validateTotalAmount(AppLocalizations l10n, String? value) =>
      requiredStrictlyPositiveDecimal(l10n, value);

  static String? validateName(AppLocalizations l10n, String? value) =>
      requiredString(l10n, value);

  static String? validateConcentration(AppLocalizations l10n, String? value) =>
      requiredStrictlyPositiveDecimal(l10n, value);

  static String? Function(String?) usedAmountValidator(
      AppLocalizations l10n, String totalAmount) {
    return (String? value) {
      return requiredPositiveDecimal(l10n, value) ??
          (validateTotalAmount(l10n, totalAmount) != null
              ? l10n.invalidTotalAmount
              : null) ??
          (value.toDecimalOrZero > totalAmount.toDecimal
              ? l10n.cannotExceedTotalCapacity
              : null);
    };
  }

  static String? validateMolecule(AppLocalizations l10n, Molecule? value) =>
      requiredMolecule(l10n, value);

  static String? validateAdministrationRoute(
          AppLocalizations l10n, AdministrationRoute? value) =>
      requiredAdministrationRoute(l10n, value);

  static String? Function(Ester?) esterValidator(AppLocalizations l10n,
      Molecule? molecule, AdministrationRoute? administrationRoute) {
    return (Ester? value) {
      return (molecule == KnownMolecules.estradiol &&
              administrationRoute == AdministrationRoute.injection &&
              value == null)
          ? l10n.requiredField
          : null;
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MedicationSupply && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SupplyItem(id: $id, name: $name, molecule: ${molecule.name}, '
        'ester: ${ester?.name}, route: ${administrationRoute.name}, '
        'concentration: $concentration ${molecule.unit}/${administrationRoute.unit}, '
        'totalDose: $totalDose, usedDose: $usedDose, quantity: $quantity)';
  }
}
