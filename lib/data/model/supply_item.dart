import 'package:decimal/decimal.dart';

class SupplyItem {
  final int? id;
  String name;
  Decimal totalDose; // mg
  Decimal usedDose; // mg
  Decimal dosePerUnit; // mg/ml
  int quantity;
  bool get isUsed => usedDose > Decimal.zero;
  bool get isInStock => quantity > 0;

  SupplyItem({
    this.id,
    required this.name,
    required this.totalDose,
    required this.dosePerUnit,
    Decimal? usedDose,
    this.quantity = 1,
  }) : usedDose = usedDose ?? Decimal.zero;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'totalDose': totalDose.toString(),
      'usedDose': usedDose.toString(),
      'dosePerUnit': dosePerUnit.toString(),
      'quantity': quantity,
    };
  }

  factory SupplyItem.fromMap(Map<String, Object?> map) {
    return SupplyItem(
      id: map['id'] as int?,
      name: map['name'] as String,
      totalDose: Decimal.parse(map['totalDose'] as String),
      usedDose: Decimal.parse(map['usedDose'] as String),
      dosePerUnit: Decimal.parse(map['dosePerUnit'] as String),
      quantity: map['quantity'] as int,
    );
  }

  SupplyItem copy() {
    return SupplyItem(
      id: id,
      name: name,
      totalDose: totalDose,
      usedDose: usedDose,
      dosePerUnit: dosePerUnit,
      quantity: quantity,
    );
  }

  @override
  String toString() {
    return 'SupplyItem{id: $id name: $name}';
  }

  bool isValid() {
    return totalDose > Decimal.zero &&
        usedDose >= Decimal.zero &&
        usedDose <= totalDose &&
        name != '' &&
        dosePerUnit > Decimal.zero;
  }

  static String? validateTotalAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    }
    final parsedValue = Decimal.tryParse(value);
    if (parsedValue == null || parsedValue <= Decimal.zero) {
      return 'Doit être un nombre positif';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    }
    return null;
  }

  static String? validateUsedAmount(String? value, String totalAmount) {
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    }
    final parsedValue = Decimal.tryParse(value);
    if (parsedValue == null || parsedValue < Decimal.zero) {
      return 'Doit être un nombre positif';
    }
    if (validateTotalAmount(totalAmount) != null) {
      return 'Quantité totale invalide';
    }
    if (parsedValue > Decimal.parse(totalAmount)) {
      return 'Ne peut pas dépasser la contenance totale';
    }
    return null;
  }

  static String? validateDosePerUnit(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    }
    final parsedValue = Decimal.tryParse(value);
    if (parsedValue == null || parsedValue <= Decimal.zero) {
      return 'Doit être supérieur à 0';
    }
    return null;
  }

  bool canUseDose(Decimal doseToUse) {
    return usedDose + doseToUse <= totalDose;
  }

  Decimal getRemainingDose() {
    return totalDose - usedDose;
  }

  double getRatio() {
    return (getRemainingDose() *
            totalDose.inverse.toDecimal(scaleOnInfinitePrecision: 10))
        .toDouble();
  }
}
