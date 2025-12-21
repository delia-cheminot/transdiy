import 'package:sqflite/sqflite.dart';
import 'app_database.dart';

class Repository<T> {
  final Future<Database> _dbFuture;
  final String tableName;
  final Map<String, Object?> Function(T) toMap;
  final T Function(Map<String, Object?>) fromMap;

  Repository({
    Database? db,
    required this.tableName,
    required this.toMap,
    required this.fromMap,
  }) : _dbFuture = db != null ? Future.value(db) : AppDatabase.getInstance().database; 

  Future<int> insert(T element) async {
    final db = await _dbFuture;
    return await db.insert(
      tableName,
      toMap(element),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<T>> getAll() async {
    final db = await _dbFuture;
    final result = await db.query(tableName);
    return result.map(fromMap).toList();
  }

  Future<void> update(T element, int id) async {
    final db = await _dbFuture;
    await db.update(
      tableName,
      toMap(element),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _dbFuture;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}