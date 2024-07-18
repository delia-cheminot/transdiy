import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:transdiy/data/app_database.dart';
import 'package:transdiy/data/supply_item_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Initialize sqflite_common_ffi
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Database tests', () {
    setUp(() async {
      // Initialize the AppDatabase instance and clean the database before each test
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

    test('Insert and retrieve a SupplyItem', () async {
      // Create a SupplyItem instance with an ID
      final item = SupplyItem(volume: 1.0);

      // Insert the item
      int insertedId = await SupplyItem.insertItem(item);

      // Retrieve the items
      final items = await SupplyItem.getItems();

      // Check that the inserted item is in the database
      expect(items.length, 1);
      expect(items[0].id, insertedId);
    });

    test('Update a SupplyItem', () async {
      // Create and insert a SupplyItem
      final item = SupplyItem(volume: 1.0);
      int id = await SupplyItem.insertItem(item);

      // Update the item
      final updatedItem = SupplyItem(id: id, volume: 2.0);
      await SupplyItem.updateItem(updatedItem);

      // Retrieve the updated items
      final updatedItems = await SupplyItem.getItems();

      // Check that the updated item is in the database
      expect(updatedItems.length, 1);
      expect(updatedItems[0].id, id);
    });

    test('Delete a SupplyItem', () async {
      // Create and insert a SupplyItem
      final item = SupplyItem(volume: 1.0);
      int id  = await SupplyItem.insertItem(item);

      // Delete the item
      await SupplyItem.deleteItem(id);

      // Retrieve the items
      final remainingItems = await SupplyItem.getItems();

      // Check that the item is deleted
      expect(remainingItems.length, 0);
    });

    test('Only delete the specified SupplyItem', () async {
      // Create and insert two SupplyItems
      final item1 = SupplyItem(volume: 1.0);
      final item2 = SupplyItem(volume: 2.0);
      int id1 = await SupplyItem.insertItem(item1);
      int id2 = await SupplyItem.insertItem(item2);

      // Delete the first item
      await SupplyItem.deleteItem(id1);

      // Retrieve the items
      final remainingItems = await SupplyItem.getItems();

      // Check that only the first item is deleted
      expect(remainingItems.length, 1);
      expect(remainingItems[0].id, id2);
    });

    test('Use volume successfully', () async {
      // Create and insert a SupplyItem
      SupplyItem item = SupplyItem(id: 1, volume: 10.0, usedVolume: 0.0);
      await SupplyItem.insertItem(item);

      // Use volume
      await item.useVolume(5.0);

      // Verify that the used volume has been updated
      expect(item.usedVolume, 5.0);

      // Verify that the used volume has been updated in the database
      final remainingItems = await SupplyItem.getItems();
      expect(remainingItems[0].usedVolume, 5.0);
    });

    test('Attempt to use volume exceeding available volume', () async {
      // Create and insert a SupplyItem
      SupplyItem item = SupplyItem(id: 1, volume: 10.0, usedVolume: 5.0);
      await SupplyItem.insertItem(item);

      // Attempt to use volume exceeding available volume
      try {
        await item.useVolume(6.0);
        // If no exception is thrown, the test should fail
        fail('Expected exception was not thrown');
      } catch (e) {
        // Verify that the exception is thrown
        expect(e is Exception, true);
        expect(e.toString(), 'Exception: Volume exceeded');
        
        // Verify that the used volume has not been updated
        expect(item.usedVolume, 5.0);

        // Verify that the used volume has not been updated in the database
        final remainingItems = await SupplyItem.getItems();
        expect(remainingItems[0].usedVolume, 5.0);
      }
    });

    test('Use zero volume', () async {
      // Create and insert a SupplyItem into the database
      SupplyItem item = SupplyItem(id: 1, volume: 10.0, usedVolume: 5.0);
      await SupplyItem.insertItem(item);

      // Use zero volume
      await item.useVolume(0.0);

      // Verify that usedVolume remains unchanged
      expect(item.usedVolume, 5.0);

      // Verify that database records remain unchanged
      final remainingItems = await SupplyItem.getItems();
      expect(remainingItems[0].usedVolume, 5.0);
    });
  });
}