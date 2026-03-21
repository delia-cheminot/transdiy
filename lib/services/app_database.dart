import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:mona/data/model/date.dart';
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
      version: 5,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE supply_items(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      totalDose TEXT,
      usedDose TEXT,
      concentration TEXT,
      name TEXT NOT NULL,
      quantity INTEGER NOT NULL,
      moleculeJson TEXT,
      administrationRouteName TEXT,
      esterName TEXT,
      type TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE medication_intakes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      scheduledDateTime TEXT NOT NULL,
      takenDateTime TEXT,
      takenTimeZone TEXT,
      dose TEXT NOT NULL,
      scheduleId INTEGER,
      side TEXT,
      moleculeJson TEXT NOT NULL,
      administrationRouteName TEXT NOT NULL,
      esterName TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE medication_schedules(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      dose TEXT NOT NULL,
      intervalDays INTEGER NOT NULL,
      startDate TEXT NOT NULL,
      moleculeJson TEXT NOT NULL,
      administrationRouteName TEXT NOT NULL,
      esterName TEXT,
      notificationTimes TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE blood_tests(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      dateTime TEXT NOT NULL,
      timeZone TEXT NOT NULL,
      estradiolLevels TEXT,
      testosteroneLevels TEXT
    )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // medication_schedules migration
      await db.execute('''
      CREATE TABLE medication_schedules_new(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dose TEXT NOT NULL,
        intervalDays INTEGER NOT NULL,
        startDate TEXT NOT NULL,
        moleculeJson TEXT NOT NULL,
        administrationRouteName TEXT NOT NULL,
        esterName TEXT
      )
      ''');

      await db.execute('''
      INSERT INTO medication_schedules_new (
        id, name, dose, intervalDays, startDate,
        moleculeJson, administrationRouteName, esterName
      )
      SELECT
        id, name, dose, intervalDays, startDate,
        '{"name":"estradiol","unit":"mg"}',
        'injection',
        'enanthate'
      FROM medication_schedules
      ''');

      await db.execute('DROP TABLE medication_schedules');
      await db.execute(
          'ALTER TABLE medication_schedules_new RENAME TO medication_schedules');

      // supply_items migration
      await db.execute('''
      CREATE TABLE supply_items_new(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        totalDose TEXT NOT NULL,
        usedDose TEXT NOT NULL,
        concentration TEXT NOT NULL,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        moleculeJson TEXT NOT NULL,
        administrationRouteName TEXT NOT NULL,
        esterName TEXT
      )
      ''');

      await db.execute('''
      INSERT INTO supply_items_new (
        id, totalDose, usedDose, concentration, name, quantity,
        moleculeJson, administrationRouteName, esterName
      )
      SELECT
        id, totalDose, usedDose, dosePerUnit, name, quantity,
        '{"name":"estradiol","unit":"mg"}',
        'injection',
        'enanthate'
      FROM supply_items
      ''');

      await db.execute('DROP TABLE supply_items');
      await db.execute('ALTER TABLE supply_items_new RENAME TO supply_items');

      // medication_intakes migration
      await db.execute('''
      CREATE TABLE medication_intakes_new(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        scheduledDateTime TEXT NOT NULL,
        takenDateTime TEXT,
        dose TEXT NOT NULL,
        scheduleId INTEGER,
        side TEXT,
        moleculeJson TEXT NOT NULL,
        administrationRouteName TEXT NOT NULL,
        esterName TEXT
      )
      ''');

      await db.execute('''
      INSERT INTO medication_intakes_new (
        id, scheduledDateTime, takenDateTime, dose,
        scheduleId, side, moleculeJson,
        administrationRouteName, esterName
      )
      SELECT
        id, scheduledDateTime, takenDateTime, dose,
        scheduleId, side,
        '{"name":"estradiol","unit":"mg"}',
        'injection',
        'enanthate'
      FROM medication_intakes
      ''');

      await db.execute('DROP TABLE medication_intakes');
      await db.execute(
          'ALTER TABLE medication_intakes_new RENAME TO medication_intakes');
    }

    if (oldVersion < 3) {
      await db.execute(
          "ALTER TABLE medication_schedules ADD COLUMN notificationTimes TEXT NOT NULL DEFAULT '[]'");
    }

    if (oldVersion < 4) {
      // add blood_tests
      await db.execute('''
      CREATE TABLE blood_tests(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dateTime TEXT NOT NULL,
        timeZone TEXT NOT NULL,
        estradiolLevels TEXT,
        testosteroneLevels TEXT
      )
      ''');

      // migrate startDate to date
      final schedules = await db.query('medication_schedules');
      for (final row in schedules) {
        final raw = row['startDate'] as String;

        final local = DateTime.parse(raw);
        final date = Date(DateTime.utc(local.year, local.month, local.day));

        await db.update(
          'medication_schedules',
          {'startDate': date.toString()},
          where: 'id = ?',
          whereArgs: [row['id']],
        );
      }

      // add takenTimeZone to medication_intakes
      await db.execute(
          'ALTER TABLE medication_intakes ADD COLUMN takenTimeZone TEXT');

      // use utc for takenDateTime and add takenTimeZone
      final intakes = await db.query('medication_intakes');
      final TimezoneInfo currentTimeZone =
          await FlutterTimezone.getLocalTimezone();

      for (final row in intakes) {
        final id = row['id'] as int;
        final takenDateTimeRaw = row['takenDateTime'] as String?;

        if (takenDateTimeRaw != null) {
          final local = DateTime.parse(takenDateTimeRaw);
          final localAtNoon =
              DateTime(local.year, local.month, local.day, 12, 0);
          final utc = localAtNoon.toUtc();

          await db.update(
            'medication_intakes',
            {
              'takenDateTime': utc.toIso8601String(),
              'takenTimeZone': currentTimeZone.identifier
            },
            where: 'id = ?',
            whereArgs: [id],
          );
        }
      }
    }

    if (oldVersion < 5) {
      // supply_items : add column 'type' and drop not null on columns
      await db.execute('''
      CREATE TABLE supply_items_new(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        totalDose TEXT,
        usedDose TEXT,
        concentration TEXT,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        moleculeJson TEXT,
        administrationRouteName TEXT,
        esterName TEXT,
        type TEXT NOT NULL
      )
      ''');

      await db.execute('''
      INSERT INTO supply_items_new (
        id, totalDose, usedDose, concentration, name, quantity,
        moleculeJson, administrationRouteName, esterName, type
      )
      SELECT
        id, 
        totalDose,
        usedDose,
        concentration,
        name,
        quantity,
        moleculeJson,
        administrationRouteName,
        esterName,
        'medication'
      FROM supply_items
      ''');

      await db.execute('DROP TABLE supply_items');
      await db.execute('ALTER TABLE supply_items_new RENAME TO supply_items');
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
