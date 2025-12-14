import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:transdiy/services/app_database.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('AppDatabase', () {
    late AppDatabase dbInstance;

    setUp(() {
      dbInstance = AppDatabase.instance;
    });

    test('database initializes and tables exist', () async {
      final db = await dbInstance.database;

      final tables = await db
          .rawQuery("SELECT name FROM sqlite_master WHERE type='table'");

      final tableNames = tables
          .map((t) => t['name'] as String)
          .where((name) => name != 'sqlite_sequence')
          .toSet();

      expect(
        tableNames.containsAll(
            {'supply_items', 'medication_intakes', 'medication_schedules'}),
        true,
      );
    });

    test('Database is created', () async {
      final db = await dbInstance.database;

      final dbPath = await getDatabasesPath();
      final expectedPath = join(dbPath, 'app_database.db');
      expect(db.path, expectedPath);

      expect(db.isOpen, true);
    });

    test('can insert and query supply_items', () async {
      final db = await dbInstance.database;

      final id = await db.insert('supply_items', {
        'name': 'Test Item',
        'totalDose': '100',
        'usedDose': '0',
        'dosePerUnit': '10',
        'quantity': 1,
      });

      final item = await db.query(
        'supply_items',
        where: 'id = ?',
        whereArgs: [id],
      );

      final expected = {
        'name': 'Test Item',
        'totalDose': '100',
      };

      final actual = {
        'name': item.first['name'],
        'totalDose': item.first['totalDose'],
      };

      expect(actual, expected);
    });

    test('can insert and query medication_intakes', () async {
      final db = await dbInstance.database;

      final id = await db.insert('medication_intakes', {
        'scheduledDateTime': DateTime(2025, 9, 14, 10, 30).toIso8601String(),
        'takenDateTime': null,
        'dose': '2.5',
      });

      final intake = await db.query(
        'medication_intakes',
        where: 'id = ?',
        whereArgs: [id],
      );

      final actual = {
        'dose': intake.first['dose'],
        'takenDateTime': intake.first['takenDateTime'],
      };

      final expected = {
        'dose': '2.5',
        'takenDateTime': null,
      };

      expect(actual, expected);
    });

    test('can insert and query medication_schedules', () async {
      final db = await dbInstance.database;

      final id = await db.insert('medication_schedules', {
        'name': 'Morning Med',
        'dose': '5',
        'intervalDays': 1,
        'lastTaken': DateTime(2025, 9, 13).toIso8601String(),
      });

      final schedule = await db.query(
        'medication_schedules',
        where: 'id = ?',
        whereArgs: [id],
      );

      final actual = {
        'name': schedule.first['name'],
        'intervalDays': schedule.first['intervalDays'],
      };

      final expected = {
        'name': 'Morning Med',
        'intervalDays': 1,
      };

      expect(actual, expected);
    });
  });
}
