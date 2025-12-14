import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppDatabase {
  static AppDatabase? _instance;
  static Database? _database;
  final bool inMemory;

  AppDatabase._init({required this.inMemory});

  static AppDatabase getInstance({bool inMemory = false}) {
    _instance ??= AppDatabase._init(inMemory: inMemory);
    return _instance!;
  }

  Future<Database> get database async {
    WidgetsFlutterBinding.ensureInitialized();

    if (_database != null) return _database!;

    if (Platform.isLinux || Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _database = inMemory
        ? await _initInMemoryDB()
        : await _initFileDB('app_database.db');

    return _database!;
  }

  Future<Database> _initInMemoryDB() async {
    return openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<Database> _initFileDB(String filePath) async {
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
      totalDose TEXT NOT NULL,
      usedDose TEXT NOT NULL,
      dosePerUnit TEXT NOT NULL,
      name TEXT NOT NULL,
      quantity INTEGER NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE medication_intakes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      scheduledDateTime TEXT NOT NULL,
      takenDateTime TEXT,
      dose TEXT NOT NULL,
      scheduleId INTEGER
    )
    ''');

    await db.execute('''
    CREATE TABLE medication_schedules(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      dose TEXT NOT NULL,
      intervalDays INTEGER NOT NULL,
      lastGenerated TEXT NOT NULL
    )
    ''');
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  static void reset() {
    _database = null;
    _instance = null;
  }
}
