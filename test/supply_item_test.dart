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
      final item = SupplyItem();

      // Insert the item
      await SupplyItem.insertItem(item);

      // Retrieve the items
      final items = await SupplyItem.getItems();

      // Check that the inserted item is in the database
      expect(items.length, 1);
    });

    test('Update a SupplyItem', () async {
      // Create and insert a SupplyItem
      final item = SupplyItem(id: 1);
      await SupplyItem.insertItem(item);

      // Update the item
      final updatedItem = SupplyItem(id: item.id);
      await SupplyItem.updateItem(updatedItem);

      // Retrieve the updated items
      final updatedItems = await SupplyItem.getItems();

      // Check that the updated item is in the database
      expect(updatedItems.length, 1);
      expect(updatedItems[0].id, item.id);
    });

    test('Delete a SupplyItem', () async {
      // Create and insert a SupplyItem
      final item = SupplyItem(id: 1);
      await SupplyItem.insertItem(item);

      // Delete the item
      await SupplyItem.deleteItem(item.id!);

      // Retrieve the items
      final remainingItems = await SupplyItem.getItems();

      // Check that the item is deleted
      expect(remainingItems.length, 0);
    });
  });
}