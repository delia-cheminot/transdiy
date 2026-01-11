import 'package:flutter_test/flutter_test.dart';
import 'package:mona/services/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('AppDatabase', () {
    late AppDatabase dbInstance;
    late Database db;

    setUp(() async {
      AppDatabase.reset();
      dbInstance = AppDatabase.getInstance(inMemory: true);
      db = await dbInstance.database;
    });
    test('Database is created', () async {
      expect(db.isOpen, true);
    });

    test('database initializes and tables exist', () async {
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

    test('can insert and query supply_items', () async {
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

      expect(
        [
          item.first['name'],
          item.first['totalDose'],
        ],
        [
          'Test Item',
          '100',
        ],
      );
    });

    test('can insert and query medication_intakes', () async {
      final id = await db.insert('medication_intakes', {
        'scheduledDateTime': DateTime(2025, 9, 14, 10, 30).toIso8601String(),
        'takenDateTime': null,
        'dose': '2.5',
        'side': null,
      });

      final allIntakes = await db.query(
        'medication_intakes',
        where: 'id = ?',
        whereArgs: [id],
      );

      final intake = allIntakes.first;

      expect(
        intake,
        allOf(
          containsPair('id, ', id),
          containsPair('dose', '2.5'),
          containsPair('takenDateTime', null),
          containsPair('side', null),
        ),
      );
    });

    test('can insert and query medication_schedules', () async {
      final id = await db.insert('medication_schedules', {
        'name': 'Morning Med',
        'dose': '5',
        'intervalDays': 1,
        'startDate': DateTime(2025, 9, 13).toIso8601String(),
      });

      final schedule = await db.query(
        'medication_schedules',
        where: 'id = ?',
        whereArgs: [id],
      );

      expect(
        [
          schedule.first['name'],
          schedule.first['intervalDays'],
        ],
        [
          'Morning Med',
          1,
        ],
      );
    });
  });
}
