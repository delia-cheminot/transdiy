import 'package:decimal/decimal.dart';
import 'package:mona/util/validators.dart';

class SupplyItem {
  final int id;
  final String name;
  final Decimal totalDose;
  final Decimal usedDose;
  final Decimal concentration;
  final int quantity;
  bool get isUsed => usedDose > Decimal.zero;
  bool get isInStock => quantity > 0;
  Decimal get remainingDose => totalDose - usedDose;

  SupplyItem({
    int? id,
    required this.name,
    required this.totalDose,
    required this.concentration,
    Decimal? usedDose,
    this.quantity = 1,
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
    );
  }

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
    };
  }

  SupplyItem copy() {
    return SupplyItem(
      id: id,
      name: name,
      totalDose: totalDose,
      usedDose: usedDose,
      concentration: concentration,
      quantity: quantity,
    );
  }

  SupplyItem copyWith({
    int? id,
    String? name,
    Decimal? totalDose,
    Decimal? usedDose,
    Decimal? concentration,
    int? quantity,
  }) {
    return SupplyItem(
      id: id ?? this.id,
      name: name ?? this.name,
      totalDose: totalDose ?? this.totalDose,
      usedDose: usedDose ?? this.usedDose,
      concentration: concentration ?? this.concentration,
      quantity: quantity ?? this.quantity,
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplyItem &&
          other.id == id &&
          other.name == name &&
          other.totalDose == totalDose &&
          other.usedDose == usedDose &&
          other.concentration == concentration &&
          other.quantity == quantity;

  @override
  int get hashCode =>
      Object.hash(id, name, totalDose, usedDose, concentration, quantity);

  @override
  String toString() {
    return 'SupplyItem{id: $id name: $name}';
  }
}
