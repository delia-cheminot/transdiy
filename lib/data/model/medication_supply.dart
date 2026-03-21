import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/data/model/supply_item.dart';
import 'package:mona/data/model/supply_type.dart';
import 'package:mona/util/string_parsing.dart';
import 'package:mona/util/validators.dart';

class MedicationSupply implements SupplyItem{
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
    return (
      remainingDose * totalDose.inverse.toDecimal(scaleOnInfinitePrecision: 10)
    ).toDouble();
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
      'type': getType().name,
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

  static String? validateTotalAmount(String? value) =>
      requiredStrictlyPositiveDecimal(value);

  static String? validateName(String? value) => requiredString(value);

  static String? validateConcentration(String? value) =>
      requiredStrictlyPositiveDecimal(value);

  static String? Function(String?) usedAmountValidator(String totalAmount) {
    return (String? value) {
      return requiredPositiveDecimal(value) ??
          (validateTotalAmount(totalAmount) != null
              ? 'Invalid total amount'
              : null) ??
          (value.toDecimalOrZero > totalAmount.toDecimal
              ? 'Cannot exceed total capacity'
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
      identical(this, other) || other is MedicationSupply && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return "${molecule.name}"
        "${ester != null ? "\n${ester!.name} " : ""}"
        "\n$concentration ${molecule.unit}/${administrationRoute.unit}";
  }

  @override
  SupplyType getType() {
    return SupplyType.medication;
  }

  @override
  int getId() {
    return id;
  }
}
