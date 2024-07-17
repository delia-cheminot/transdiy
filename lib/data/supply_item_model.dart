import 'package:sqflite/sqflite.dart';
import 'app_database.dart';

class SupplyItem {
  final int? id;

  const SupplyItem({
    this.id,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
    };
  }

  factory SupplyItem.fromMap(Map<String, Object?> map) {
    return SupplyItem(
      id: map['id'] as int?,
    );
  }

  @override
  String toString() {
    return 'SupplyItem{id: $id}';
  }

  static Future<void> insertItem(SupplyItem item) async {
    final db = await AppDatabase.instance.database;
    await db.insert(
      'supply_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<SupplyItem>> getItems() async {
    final db = await AppDatabase.instance.database;
    final List<Map<String, Object?>> supplyItemMap = await db.query('supply_items');
    return supplyItemMap.map((e) => SupplyItem.fromMap(e)).toList();
  }

  static Future<void> updateItem(SupplyItem item) async {
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
}
