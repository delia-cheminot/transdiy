import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:transdiy/supply_item/supply_item.dart';
import 'package:transdiy/supply_item/supply_item_repository.dart';
import 'package:transdiy/services/app_database.dart';

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
      final item = SupplyItem(name: 'h', volume: 1.0);

      // Insert the item
      int insertedId = await SupplyItemRepository.insertItem(item);

      // Retrieve the items
      final items = await SupplyItemRepository.getItems();

      // Check that the inserted item is in the database
      expect(items.length, 1);
      expect(items[0].id, insertedId);
    });

    test('Update a SupplyItem', () async {
      // Create and insert a SupplyItem
      final item = SupplyItem(name: 'h', volume: 1.0);
      int id = await SupplyItemRepository.insertItem(item);

      // Update the item
      final updatedItem = SupplyItem(name: 'h', id: id, volume: 2.0);
      await SupplyItemRepository.updateItem(updatedItem);

      // Retrieve the updated items
      final updatedItems = await SupplyItemRepository.getItems();

      // Check that the updated item is in the database
      expect(updatedItems.length, 1);
      expect(updatedItems[0].id, id);
      expect(updatedItems[0].volume, 2.0);
    });

    test('Delete a SupplyItem', () async {
      // Create and insert a SupplyItem
      final item = SupplyItem(name: 'h', volume: 1.0);
      int id  = await SupplyItemRepository.insertItem(item);

      // Delete the item
      await SupplyItemRepository.deleteItemFromId(id);

      // Retrieve the items
      final remainingItems = await SupplyItemRepository.getItems();

      // Check that the item is deleted
      expect(remainingItems.length, 0);
    });

    test('Only delete the specified SupplyItem', () async {
      // Create and insert two SupplyItems
      final item1 = SupplyItem(name: 'g', volume: 1.0);
      final item2 = SupplyItem(name: 'h', volume: 2.0);
      int id1 = await SupplyItemRepository.insertItem(item1);
      int id2 = await SupplyItemRepository.insertItem(item2);

      // Delete the first item
      await SupplyItemRepository.deleteItemFromId(id1);

      // Retrieve the items
      final remainingItems = await SupplyItemRepository.getItems();

      // Check that only the first item is deleted
      expect(remainingItems.length, 1);
      expect(remainingItems[0].id, id2);
    });
  });
}