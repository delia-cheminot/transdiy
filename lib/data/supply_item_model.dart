import 'package:sqflite/sqflite.dart';
import 'app_database.dart';

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
    return 'SupplyItem{id: $id volume: $volume} usedVolume: $usedVolume';
  }

  /// Inserts or replaces the [SupplyItem] into the database table and returns the id of the inserted item.
  static Future<int> insertItem(SupplyItem item) async {
    final db = await AppDatabase.instance.database;
    int id = await db.insert(
      'supply_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<SupplyItem>> getItems() async {
    final db = await AppDatabase.instance.database;
    final List<Map<String, Object?>> supplyItemMap =
        await db.query('supply_items');
    return supplyItemMap.map((e) => SupplyItem.fromMap(e)).toList();
  }

  static Future<void> updateItem(SupplyItem item) async {
    assert(item.id != null);
    if (item.usedVolume > item.volume) {
      throw ArgumentError('Used volume cannot exceed total volume');
    }
    final db = await AppDatabase.instance.database;
    await db.update(
      'supply_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  static Future<void> deleteItem(int id) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      'supply_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Uses a portion of the volume of the [SupplyItem] and updates the database.
  Future<void> useVolume(double volumeToUse) async {
    if (usedVolume + volumeToUse > this.volume) {
      throw ArgumentError('Volume exceeded');
    }
    usedVolume += volumeToUse;
    await updateItem(this);
  }

  Future<void> setFields({
    double? newVolume,
    double? newUsedVolume,
    String? newName,
    DateTime? newExpirationDate,
  }) async {
    if (newVolume != null) {
      volume = newVolume;
    }
    if (newUsedVolume != null) {
      if (newUsedVolume > volume) {
        throw ArgumentError('Used volume cannot exceed total volume');
      }
      usedVolume = newUsedVolume;
    }
  }
}
