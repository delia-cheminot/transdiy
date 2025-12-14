import 'package:sqflite/sqflite.dart';
import 'app_database.dart';

class Repository<T> {
  final Database db;
  final String tableName;
  final Map<String, Object?> Function(T) toMap;
  final T Function(Map<String, Object?>) fromMap;

  Repository({
    Database? db,
    required this.tableName,
    required this.toMap,
    required this.fromMap,
  }) : db = db ?? AppDatabase.getInstance().database as Database;

  Future<int> insert(T element) async {
    return await db.insert(
      tableName,
      toMap(element),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<T>> getAll() async {
    final result = await db.query(tableName);
    return result.map(fromMap).toList();
  }

  Future<void> update(T element, int id) async {
    await db.update(
      tableName,
      toMap(element),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}