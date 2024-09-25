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
}