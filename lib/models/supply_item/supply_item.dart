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

  static String? validateTotalAmount(String value) {
    if (_parseDouble(value) == null) {
      return 'Champ obligatoire';
    }
    return null;
  }

  static String? validateName(String value) {
    if (value.isEmpty) {
      return 'Champ obligatoire';
    }
    return null;
  }

  static String? validateUsedAmount(String value, String totalAmount) {
    if (_parseDouble(value) == null) {
      return 'Champ obligatoire';
    }
    if (_parseDouble(totalAmount) != null &&
        _parseDouble(value)! > _parseDouble(totalAmount)!) {
      return 'Ne peut pas dépasser la contenance totale';
    }
    return null;
  }

  static String? validateDosePerUnit(String value) {
    if (_parseDouble(value) == null) {
      return 'Champ obligatoire';
    }
    if (_parseDouble(value)! <= 0) {
      return 'Doit être supérieur à 0';
    }
    return null;
  }

  static double? _parseDouble(String text) {
    final sanitizedText = text.replaceAll(',', '.');
    return double.tryParse(sanitizedText);
  }

  static double roundAmount(double amount) {
    // Amount is rounded to two decimal places
    return double.parse(amount.toStringAsFixed(2));
  }

  bool canUseAmount(double amountToUse) {
    return roundAmount(usedAmount + amountToUse) <= totalAmount;
  }

  double getRemainingAmount() {
    return roundAmount(totalAmount - usedAmount);
  }
}
