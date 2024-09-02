import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    WidgetsFlutterBinding.ensureInitialized();
    if (_database != null) return _database!;

    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE supply_items(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      volume REAL NOT NULL,
      usedVolume REAL NOT NULL
    )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
