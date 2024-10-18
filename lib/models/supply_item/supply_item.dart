import 'package:transdiy/utils/math_helper.dart';

class SupplyItem {
  final int? id;
  String name;
  double totalAmount;
  double usedAmount;
  double dosePerUnit;
  int quantity;
  bool get isUsed => usedAmount > 0;
  bool get isInStock => quantity > 0;

  SupplyItem({
    this.id,
    required this.name,
    required this.totalAmount,
    required this.dosePerUnit,
    this.usedAmount = 0,
    this.quantity = 1,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'totalAmount': totalAmount,
      'usedAmount': usedAmount,
      'dosePerUnit': dosePerUnit,
      'quantity': quantity,
    };
  }

  factory SupplyItem.fromMap(Map<String, Object?> map) {
    return SupplyItem(
      id: map['id'] as int?,
      name: map['name'] as String,
      totalAmount: map['totalAmount'] as double,
      usedAmount: map['usedAmount'] as double,
      dosePerUnit: map['dosePerUnit'] as double,
      quantity: map['quantity'] as int,
    );
  }

  SupplyItem copy() {
    return SupplyItem(
      id: id,
      name: name,
      totalAmount: totalAmount,
      usedAmount: usedAmount,
      dosePerUnit: dosePerUnit,
      quantity: quantity,
    );
  }

  @override
  String toString() {
    return 'SupplyItem{id: $id name: $name}';
  }

  bool isValid() {
    return totalAmount > 0 &&
        usedAmount >= 0 &&
        usedAmount <= totalAmount &&
        name != '' &&
        dosePerUnit > 0;
  }

  static String? validateTotalAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    }
    final parsedValue = MathHelper.parseDouble(value);
    if (parsedValue == null || parsedValue <= 0) {
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
    final parsedValue = MathHelper.parseDouble(value);
    if (parsedValue == null || parsedValue < 0) {
      return 'Doit être un nombre positif';
    }
    if (validateTotalAmount(totalAmount) != null) {
      return 'Quantité totale invalide';
    }
    if (parsedValue > MathHelper.parseDouble(totalAmount)!) {
      return 'Ne peut pas dépasser la contenance totale';
    }
    return null;
  }

  static String? validateDosePerUnit(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    }
    final parsedValue = MathHelper.parseDouble(value);
    if (parsedValue == null || parsedValue <= 0) {
      return 'Doit être supérieur à 0';
    }
    return null;
  }

  static double roundAmount(double amount) {
    // Amount is rounded to two decimal places
    return MathHelper.roundDouble(amount, 2);
  }

  bool canUseAmount(double amountToUse) {
    return roundAmount(usedAmount + amountToUse) <= totalAmount;
  }

  double getRemainingAmount() {
    return roundAmount(totalAmount - usedAmount);
  }
}
