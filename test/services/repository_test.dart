import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/services/app_database.dart';
import 'package:transdiy/services/repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('SupplyItemRepository tests', () {
    late AppDatabase dbInstance;
    late Database db;
    late Repository<SupplyItem> repository;

    setUp(() async {
      AppDatabase.reset();
      dbInstance = AppDatabase.getInstance(inMemory: true);
      db = await dbInstance.database;
      await db.delete('supply_items');
      repository = Repository<SupplyItem>(
        db: db,
        tableName: 'supply_items',
        toMap: (SupplyItem item) => item.toMap(),
        fromMap: (Map<String, Object?> map) => SupplyItem.fromMap(map),
      );
    });

    test('Insert and retrieve a SupplyItem', () async {
      final item = SupplyItem(
          name: 'h',
          totalDose: Decimal.parse('1'),
          dosePerUnit: Decimal.parse('1'));

      int insertedId = await repository.insert(item);

      final items = await repository.getAll();

      expect(items.length, 1);
      expect(items[0].id, insertedId);
    });

    test('Update a SupplyItem', () async {
      final item = SupplyItem(
          name: 'h',
          totalDose: Decimal.parse('1'),
          dosePerUnit: Decimal.parse('1'));
      int id = await repository.insert(item);

      final updatedItem = SupplyItem(
          name: 'h',
          id: id,
          totalDose: Decimal.parse('2'),
          dosePerUnit: Decimal.parse('1'));
      await repository.update(updatedItem, id);

      final updatedItems = await repository.getAll();

      expect(updatedItems.length, 1);
      expect(updatedItems[0].id, id);
      expect(updatedItems[0].totalDose, Decimal.parse('2'));
    });

    test('Delete a SupplyItem', () async {
      final item = SupplyItem(
          name: 'h',
          totalDose: Decimal.parse('1'),
          dosePerUnit: Decimal.parse('1'));
      int id = await repository.insert(item);

      await repository.delete(id);

      final remainingItems = await repository.getAll();

      expect(remainingItems.length, 0);
    });

    test('Only delete the specified SupplyItem', () async {
      final item1 = SupplyItem(
          id: 1,
          name: 'g',
          totalDose: Decimal.parse('1'),
          dosePerUnit: Decimal.parse('1'));
      final item2 = SupplyItem(
          id: 2,
          name: 'h',
          totalDose: Decimal.parse('2'),
          dosePerUnit: Decimal.parse('1'));
      int id1 = await repository.insert(item1);
      int id2 = await repository.insert(item2);

      await repository.delete(id1);

      final remainingItems = await repository.getAll();

      expect(remainingItems.length, 1);
      expect(remainingItems[0].id, id2);
    });
  });

  group('Invalid column name test', () {
    test('Throws exception for invalid column name', () async {
      AppDatabase.reset();
      AppDatabase dbInstance = AppDatabase.getInstance(inMemory: true);
      Database db = await dbInstance.database;
      Repository<SupplyItem> repository = Repository<SupplyItem>(
        db: db,
        tableName: 'bad_table',
        toMap: (SupplyItem item) => item.toMap(),
        fromMap: (Map<String, Object?> map) => SupplyItem.fromMap(map),
      );

      try {
        await repository.getAll();
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isA<DatabaseException>());
      }
    });
  });
}
