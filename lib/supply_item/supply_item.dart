class SupplyItem {
  final int? id;
  String name;
  double volume;
  double usedVolume;
  int quantity;
  bool get isUsed => usedVolume > 0;
  bool get isInStock => quantity > 0;

  SupplyItem({
    this.id,
    required this.name,
    required this.volume,
    this.usedVolume = 0,
    this.quantity = 1,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'volume': volume,
      'usedVolume': usedVolume,
      'quantity': quantity,
    };
  }

  factory SupplyItem.fromMap(Map<String, Object?> map) {
    return SupplyItem(
      id: map['id'] as int?,
      name: map['name'] as String,
      volume: map['volume'] as double,
      usedVolume: map['usedVolume'] as double,
      quantity: map['quantity'] as int,
    );
  }

  SupplyItem copy() {
    return SupplyItem(
      id: id,
      name: name,
      volume: volume,
      usedVolume: usedVolume,
      quantity: quantity,
    );
  }

  @override
  String toString() {
    return 'SupplyItem{id: $id name: $name}';
  }

  bool isValid() {
    return volume > 0 && usedVolume >= 0 && usedVolume <= volume && name != '';
  }

  static String? validateVolume(String value) {
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

  static String? validateUsedVolume(String value, String volume) {
    if (_parseDouble(value) == null) {
      return 'Champ obligatoire';
    }
    if (_parseDouble(volume) != null &&
        _parseDouble(value)! > _parseDouble(volume)!) {
      return 'Le volume utilisé ne peut pas dépasser la contenance';
    }
    return null;
  }

  static double? _parseDouble(String text) {
    final sanitizedText = text.replaceAll(',', '.');
    return double.tryParse(sanitizedText);
  }
}