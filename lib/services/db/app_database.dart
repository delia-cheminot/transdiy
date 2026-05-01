import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:mona/services/db/db_tables.dart';
import 'package:mona/services/db/upgrade/v2.dart';
import 'package:mona/services/db/upgrade/v3.dart';
import 'package:mona/services/db/upgrade/v4.dart';
import 'package:mona/services/db/upgrade/v5.dart';
import 'package:mona/services/db/upgrade/v6.dart';
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
      onOpen: _onOpen,
    );
  }

  Future<Database> _initFileDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 6,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
      onOpen: _onOpen,
    );
  }

  Future _onOpen(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    await db.execute(createSupplyItemsTable);
    await db.execute(createMedicationIntakesTable);
    await db.execute(createMedicationSchedulesTable);
    await db.execute(createBloodTestsTable);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      DbUpgradeV2().upgrade(db, oldVersion, newVersion);
    }
    if (oldVersion < 3) {
      DbUpgradeV3().upgrade(db, oldVersion, newVersion);
    }
    if (oldVersion < 4) {
      DbUpgradeV4().upgrade(db, oldVersion, newVersion);
    }
    if (oldVersion < 5) {
      DbUpgradeV5().upgrade(db, oldVersion, newVersion);
    }
    if (oldVersion < 6) {
      DbUpgradeV6().upgrade(db, oldVersion, newVersion);
    }
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
