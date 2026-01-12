import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/supply_item.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
import 'generic_repository_mock.dart';

void main() {
  late SupplyItemProvider provider;
  late GenericRepositoryMock<SupplyItem> repo;

  setUp(() async {
    repo = GenericRepositoryMock<SupplyItem>(
      withId: (i, id) => SupplyItem(
        id: id,
        name: i.name,
        totalDose: i.totalDose,
        usedDose: i.usedDose,
        dosePerUnit: i.dosePerUnit,
      ),
    );
    provider = SupplyItemProvider(repository: repo);
  });

  group('SupplyItemProvider Tests', () {
    test('initialization loads items', () async {
      await repo.insert(SupplyItem(
          id: 1,
          name: 'Test Item 1',
          totalDose: Decimal.parse('50'),
          dosePerUnit: Decimal.parse('5')));

      await repo.insert(SupplyItem(
          id: 2,
          name: 'Test Item 2',
          totalDose: Decimal.parse('30'),
          dosePerUnit: Decimal.parse('3')));

      await provider.fetchItems();

      expect(provider.items.length, repo.items.length);
    });

    test('addItem inserts a new item', () async {
      await repo.insert(SupplyItem(
          id: 1,
          name: 'Test Item 1',
          totalDose: Decimal.parse('50'),
          dosePerUnit: Decimal.parse('5')));

      await repo.insert(SupplyItem(
          id: 2,
          name: 'Test Item 2',
          totalDose: Decimal.parse('30'),
          dosePerUnit: Decimal.parse('3')));

      const name = 'New Item';
      final totalDose = Decimal.parse('20');
      final dosePerUnit = Decimal.parse('2');

      await provider.addItem(totalDose, name, dosePerUnit);

      final lastItem = provider.items.last;
      expect(
        [
          provider.items.length,
          lastItem.name,
          lastItem.totalDose,
          lastItem.dosePerUnit,
        ],
        [
          3,
          name,
          totalDose,
          dosePerUnit,
        ],
      );
    });

    test('updateItem updates an existing item', () async {
      await repo.insert(SupplyItem(
          id: 1,
          name: 'Test Item 1',
          totalDose: Decimal.parse('50'),
          dosePerUnit: Decimal.parse('5')));

      await repo.insert(SupplyItem(
          id: 2,
          name: 'Test Item 2',
          totalDose: Decimal.parse('30'),
          dosePerUnit: Decimal.parse('3')));

      final itemToUpdate = repo.items.first;
      final updatedItem = SupplyItem(
          id: itemToUpdate.id,
          name: 'Updated Name',
          totalDose: Decimal.parse('99'),
          dosePerUnit: Decimal.parse('9'));

      await provider.updateItem(updatedItem);

      final firstItem = provider.items.first;
      expect(
        [firstItem.name, firstItem.totalDose, firstItem.dosePerUnit],
        ['Updated Name', Decimal.parse('99'), Decimal.parse('9')],
      );
    });

    test('deleteItemFromId removes the item', () async {
      await repo.insert(SupplyItem(
          id: 1,
          name: 'Test Item 1',
          totalDose: Decimal.parse('50'),
          dosePerUnit: Decimal.parse('5')));

      await repo.insert(SupplyItem(
          id: 2,
          name: 'Test Item 2',
          totalDose: Decimal.parse('30'),
          dosePerUnit: Decimal.parse('3')));

      await provider.deleteItemFromId(1);

      expect(
        [provider.items.length, provider.items.first.id],
        [1, 2],
      );
    });

    test('deleteItem removes the item by object', () async {
      await repo.insert(SupplyItem(
          id: 1,
          name: 'Test Item 1',
          totalDose: Decimal.parse('50'),
          dosePerUnit: Decimal.parse('5')));

      await repo.insert(SupplyItem(
          id: 2,
          name: 'Test Item 2',
          totalDose: Decimal.parse('30'),
          dosePerUnit: Decimal.parse('3')));

      final itemToDelete = repo.items.first;

      await provider.deleteItem(itemToDelete);

      expect(
        [provider.items.length, provider.items.first.id],
        [1, 2],
      );
    });

    test('orderedByRemainingDose orders items with most used/total first',
        () async {
      await repo.insert(SupplyItem(
          id: 3,
          name: 'A',
          totalDose: Decimal.parse('100'),
          usedDose: Decimal.parse('90'),
          dosePerUnit: Decimal.parse('1')));

      await repo.insert(SupplyItem(
          id: 4,
          name: 'B',
          totalDose: Decimal.parse('100'),
          usedDose: Decimal.parse('10'),
          dosePerUnit: Decimal.parse('1')));

      await repo.insert(SupplyItem(
          id: 5,
          name: 'C',
          totalDose: Decimal.parse('100'),
          usedDose: Decimal.parse('50'),
          dosePerUnit: Decimal.parse('1')));

      await provider.fetchItems();

      final ordered = provider.orderedByRemainingDose;

      expect(ordered.map((e) => e.name).toList(), ['A', 'C', 'B']);
    });

    test('getMostUsedItem returns the item with highest used/total dose',
        () async {
      final supplyItem = SupplyItem(
          id: 6,
          name: 'X',
          totalDose: Decimal.parse('200'),
          usedDose: Decimal.parse('150'),
          dosePerUnit: Decimal.parse('2'));

      await repo.insert(supplyItem);

      await repo.insert(supplyItem.copyWith(
        id: 7,
        usedDose: Decimal.parse('50'),
      ));

      await repo.insert(supplyItem.copyWith(
        id: 8,
        usedDose: Decimal.parse('100'),
      ));

      await provider.fetchItems();

      final mostUsed = provider.getMostUsedItem();

      expect(mostUsed?.id, 6);
    });
  });
}
