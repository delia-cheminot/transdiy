import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/util/validators.dart';

class SupplyItem {
  final int id;
  final String name;
  final Decimal totalDose;
  final Decimal usedDose;
  final Decimal concentration;
  // TODO remove quantity
  final int quantity;
  final Molecule molecule;
  final AdministrationRoute administrationRoute;
  final Ester? ester;

  SupplyItem({
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

  factory SupplyItem.fromMap(Map<String, Object?> map) {
    return SupplyItem(
      id: map['id'] as int?,
      name: map['name'] as String,
      totalDose: Decimal.parse(map['totalDose'] as String),
      usedDose: Decimal.parse(map['usedDose'] as String),
      concentration: Decimal.parse(map['concentration'] as String),
      quantity: map['quantity'] as int,
      molecule: Molecule.fromJson(jsonDecode(map['moleculeJson'] as String)),
      administrationRoute: AdministrationRoute.fromName(
          map['administrationRouteName'] as String),
      ester: map['esterName'] != null
          ? Ester.values.byName(map['esterName'] as String)
          : null,
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
    };
  }

  SupplyItem copyWith({
    int? id,
    String? name,
    Decimal? totalDose,
    Decimal? usedDose,
    Decimal? concentration,
    int? quantity,
    Molecule? molecule,
    AdministrationRoute? administrationRoute,
    Ester? ester,
  }) {
    return SupplyItem(
      id: id ?? this.id,
      name: name ?? this.name,
      totalDose: totalDose ?? this.totalDose,
      usedDose: usedDose ?? this.usedDose,
      concentration: concentration ?? this.concentration,
      quantity: quantity ?? this.quantity,
      molecule: molecule ?? this.molecule,
      administrationRoute: administrationRoute ?? this.administrationRoute,
      ester: ester ?? this.ester,
    );
  }

  static String? validateTotalAmount(String? value) =>
      requiredPositiveDecimal(value);

  static String? validateName(String? value) => requiredString(value);

  static String? validateConcentration(String? value) =>
      requiredPositiveDecimal(value);

  static String? Function(String?) usedAmountValidator(String totalAmount) {
    return (String? value) {
      return requiredPositiveDecimal(value) ??
          (Decimal.tryParse(value!)! > Decimal.parse(totalAmount)
              ? 'Cannot exceed total capacity'
              : null) ??
          (validateTotalAmount(totalAmount) != null
              ? 'Invalid total amount'
              : null);
    };
  }

  static String? validateMolecule(Molecule? value) => requiredMolecule(value);

  static String? validateAdministrationRoute(AdministrationRoute? value) =>
      requiredAdministrationRoute(value);

  static String? Function(Ester?) esterValidator(
      Molecule? molecule, AdministrationRoute? administrationRoute) {
    return (Ester? value) {
      return (molecule == KnownMolecules.estradiol &&
              administrationRoute == AdministrationRoute.injection &&
              value == null)
          ? 'Required field'
          : null;
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SupplyItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SupplyItem{id: $id name: $name}';
  }
}
