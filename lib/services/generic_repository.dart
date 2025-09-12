import 'package:sqflite/sqflite.dart';
import 'app_database.dart';

class GenericRepository<T> {
  final String tableName;
  final Map<String, Object?> Function(T) toMap;
  final T Function(Map<String, Object?>) fromMap;

  GenericRepository({
    required this.tableName,
    required this.toMap,
    required this.fromMap,
  });

  Future<int> insert(T element) async {
    final db = await AppDatabase.instance.database;
    return await db.insert(
      tableName,
      toMap(element),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<T>> getAll() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(tableName);
    return result.map(fromMap).toList();
  }

  Future<void> update(T element, int id) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      tableName,
      toMap(element),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}