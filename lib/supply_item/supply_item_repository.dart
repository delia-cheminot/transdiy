import 'package:sqflite/sqflite.dart';
import 'supply_item.dart';
import '../services/app_database.dart';

class SupplyItemRepository {
  /// Inserts or replaces the [SupplyItem] into the database table
  /// and returns the id of the inserted item.
  static Future<int> insertItem(SupplyItem item) async {
    final db = await AppDatabase.instance.database;
    return await db.insert(
      'supply_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<SupplyItem>> getItems() async {
    final db = await AppDatabase.instance.database;
    final List<Map<String, Object?>> supplyItemMap =
        await db.query('supply_items');
    return supplyItemMap.map((e) => SupplyItem.fromMap(e)).toList();
  }

  static Future<void> updateItem(SupplyItem item) async {
    assert(item.id != null && item.isValid());
    final db = await AppDatabase.instance.database;
    await db.update(
      'supply_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  static Future<void> deleteItemFromId(int id) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      'supply_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteItem(SupplyItem item) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      'supply_items',
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
}
