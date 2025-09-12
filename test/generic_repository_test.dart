import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/services/app_database.dart';
import 'package:transdiy/services/generic_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Initialize sqflite_common_ffi
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Database tests', () {
    setUp(() async {
      final db = await AppDatabase.instance.database;
      await db.delete('supply_items');
    });

    tearDownAll(() async {
      // Close the database after all tests
      await AppDatabase.instance.close();
    });

    test('Database is created', () async {
      // Initialize the database
      final db = await AppDatabase.instance.database;

      // Check that the database path is correct
      final dbPath = await getDatabasesPath();
      final expectedPath = join(dbPath, 'app_database.db');
      expect(db.path, expectedPath);

      // Check that the database is open
      expect(db.isOpen, true);
    });
  });

  group('SupplyItemRepository tests', () {
    late GenericRepository<SupplyItem> repository =
        GenericRepository<SupplyItem>(
      tableName: 'supply_items',
      toMap: (SupplyItem item) => item.toMap(),
      fromMap: (Map<String, Object?> map) => SupplyItem.fromMap(map),
    );

    setUp(() async {
      final db = await AppDatabase.instance.database;
      await db.delete('supply_items');
    });

    tearDownAll(() async {
      // Close the database after all tests
      await AppDatabase.instance.close();
    });

    test('Insert and retrieve a SupplyItem', () async {
      // Create a SupplyItem instance
      final item = SupplyItem(
          name: 'h',
          totalDose: Decimal.parse('1'),
          dosePerUnit: Decimal.parse('1'));

      // Insert the item
      int insertedId = await repository.insert(item);

      // Retrieve the items
      final items = await repository.getAll();

      // Check that the inserted item is in the database
      expect(items.length, 1);
      expect(items[0].id, insertedId);
    });

    test('Update a SupplyItem', () async {
      // Create and insert a SupplyItem
      final item = SupplyItem(
          name: 'h',
          totalDose: Decimal.parse('1'),
          dosePerUnit: Decimal.parse('1'));
      int id = await repository.insert(item);

      // Update the item
      final updatedItem = SupplyItem(
          name: 'h',
          id: id,
          totalDose: Decimal.parse('2'),
          dosePerUnit: Decimal.parse('1'));
      await repository.update(updatedItem, id);

      // Retrieve the updated items
      final updatedItems = await repository.getAll();

      // Check that the updated item is in the database
      expect(updatedItems.length, 1);
      expect(updatedItems[0].id, id);
      expect(updatedItems[0].totalDose, Decimal.parse('2'));
    });

    test('Delete a SupplyItem', () async {
      // Create and insert a SupplyItem
      final item = SupplyItem(
          name: 'h',
          totalDose: Decimal.parse('1'),
          dosePerUnit: Decimal.parse('1'));
      int id = await repository.insert(item);

      // Delete the item
      await repository.delete(id);

      // Retrieve the items
      final remainingItems = await repository.getAll();

      // Check that the item is deleted
      expect(remainingItems.length, 0);
    });

    test('Only delete the specified SupplyItem', () async {
      // Create and insert two SupplyItems
      final item1 = SupplyItem(
          name: 'g',
          totalDose: Decimal.parse('1'),
          dosePerUnit: Decimal.parse('1'));
      final item2 = SupplyItem(
          name: 'h',
          totalDose: Decimal.parse('2'),
          dosePerUnit: Decimal.parse('1'));
      int id1 = await repository.insert(item1);
      int id2 = await repository.insert(item2);

      // Delete the first item
      await repository.delete(id1);

      // Retrieve the items
      final remainingItems = await repository.getAll();

      // Check that only the first item is deleted
      expect(remainingItems.length, 1);
      expect(remainingItems[0].id, id2);
    });
  });

  group('Invalid column name test', () {
    test('Throws exception for invalid column name', () async {
      GenericRepository<SupplyItem> repository = GenericRepository<SupplyItem>(
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
