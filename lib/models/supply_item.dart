class SupplyItem {
  final int? id;
  double volume;
  double usedVolume;
  bool get isUsed => usedVolume > 0;

  SupplyItem({
    this.id,
    required this.volume,
    this.usedVolume = 0,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'volume': volume,
      'usedVolume': usedVolume,
    };
  }

  factory SupplyItem.fromMap(Map<String, Object?> map) {
    return SupplyItem(
      id: map['id'] as int?,
      volume: map['volume'] as double,
      usedVolume: map['usedVolume'] as double,
    );
  }

  @override
  String toString() {
    return 'MedicineContainer{id: $id volume: $volume} usedVolume: $usedVolume';
  }

  bool isValid() {
    return volume > 0 && usedVolume >= 0 && usedVolume <= volume;
  }
}