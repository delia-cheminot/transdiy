import 'package:flutter_test/flutter_test.dart';
import 'package:mona/services/db/app_database.dart';
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
        'type': 'medication',
        'name': 'Test Item',
        'totalDose': '100',
        'usedDose': '0',
        'concentration': '10',
        'quantity': 1,
        'moleculeJson': '{"name":"estradiol","unit":"mg"}',
        'administrationRouteName': 'oral',
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
      final supplyItemId = await db.insert('supply_items', {
        'type': 'medication',
        'name': 'Test Item',
        'totalDose': '100',
        'usedDose': '10',
        'concentration': '200',
        'quantity': 1,
        'moleculeJson': '{"name":"progesterone","unit":"mg"}',
        'administrationRouteName': 'oral',
      });

      final id = await db.insert('medication_intakes', {
        'scheduledDateTime': DateTime(2025, 9, 14, 10, 30).toIso8601String(),
        'takenDateTime': null,
        'dose': '2.5',
        'side': null,
        'moleculeJson': '{"name":"estradiol","unit":"mg"}',
        'administrationRouteName': 'oral',
        'supplyItemId': supplyItemId,
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
          containsPair('id', id),
          containsPair('dose', '2.5'),
          containsPair('takenDateTime', null),
          containsPair('side', null),
          containsPair('supplyItemId', supplyItemId),
        ),
      );
    });

    test(
        "inserting a supplyItemId that doesn't exist in medication_intakes does not succeed",
        () async {
      final supplyItemId = -67;

      expect(
          () async => await db.insert('medication_intakes', {
                'scheduledDateTime':
                    DateTime(2025, 9, 14, 10, 30).toIso8601String(),
                'takenDateTime': null,
                'dose': '2.5',
                'side': null,
                'moleculeJson': '{"name":"estradiol","unit":"mg"}',
                'administrationRouteName': 'oral',
                'supplyItemId': supplyItemId,
              }),
          throwsA(
            predicate((e) =>
                e is DatabaseException &&
                e.getResultCode() == 787), // Foreign key constraint failed code
          ));
    });

    test(
        "deleting a supplyItem sets the field supplyItemId in medication_intakes NULL",
        () async {
      final supplyItemId = await db.insert('supply_items', {
        'type': 'medication',
        'name': 'Test Item',
        'totalDose': '100',
        'usedDose': '10',
        'concentration': '200',
        'quantity': 1,
        'moleculeJson': '{"name":"progesterone","unit":"mg"}',
        'administrationRouteName': 'oral',
      });

      final intakeId = await db.insert('medication_intakes', {
        'scheduledDateTime': DateTime(2025, 9, 14, 10, 30).toIso8601String(),
        'takenDateTime': null,
        'dose': '2.5',
        'side': null,
        'moleculeJson': '{"name":"estradiol","unit":"mg"}',
        'administrationRouteName': 'oral',
        'supplyItemId': supplyItemId,
      });

      await db
          .delete("supply_items", where: 'id = ?', whereArgs: [supplyItemId]);

      final intakes = await db
          .query("medication_intakes", where: 'id = ?', whereArgs: [intakeId]);
      final intake = intakes.single;

      expect(
        intake,
        containsPair('supplyItemId', null),
      );
    });

    test('can insert and query medication_schedules', () async {
      final id = await db.insert('medication_schedules', {
        'name': 'Morning Med',
        'dose': '5',
        'intervalDays': 1,
        'startDate': DateTime(2025, 9, 13).toIso8601String(),
        'moleculeJson': '{"name":"estradiol","unit":"mg"}',
        'administrationRouteName': 'oral',
        'notificationTimes': '["12:30", "18:30"]',
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
