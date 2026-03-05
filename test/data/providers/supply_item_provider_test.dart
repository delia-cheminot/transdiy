import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/molecule.dart';
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
        concentration: i.concentration,
        molecule: i.molecule,
        administrationRoute: i.administrationRoute,
        ester: i.ester,
      ),
    );
    provider = SupplyItemProvider(repository: repo);
  });

  group('SupplyItemProvider Tests', () {
    test('initialization loads items', () async {
      await repo.insert(
        SupplyItem(
          id: 1,
          name: 'Test Item 1',
          totalDose: Decimal.parse('50'),
          concentration: Decimal.parse('5'),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
        ),
      );

      await repo.insert(SupplyItem(
        id: 2,
        name: 'Test Item 2',
        totalDose: Decimal.parse('30'),
        concentration: Decimal.parse('3'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

      await provider.fetchItems();

      expect(provider.items.length, repo.items.length);
    });

    test('add inserts a new item', () async {
      // Arrange
      final itemToAdd = SupplyItem(
        name: 'New Item',
        totalDose: Decimal.parse('20'),
        concentration: Decimal.parse('2'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      );

      // Act
      await provider.add(itemToAdd);

      // Assert
      expect(provider.items, contains(itemToAdd));
    });

    test('updateItem updates an existing item', () async {
      await repo.insert(SupplyItem(
        id: 1,
        name: 'Test Item 1',
        totalDose: Decimal.parse('50'),
        concentration: Decimal.parse('5'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

      await repo.insert(SupplyItem(
        id: 2,
        name: 'Test Item 2',
        totalDose: Decimal.parse('30'),
        concentration: Decimal.parse('3'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

      final itemToUpdate = repo.items.first;
      final updatedItem = SupplyItem(
        id: itemToUpdate.id,
        name: 'Updated Name',
        totalDose: Decimal.parse('99'),
        concentration: Decimal.parse('9'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      );

      await provider.updateItem(updatedItem);

      final firstItem = provider.items.first;
      expect(
        [firstItem.name, firstItem.totalDose, firstItem.concentration],
        ['Updated Name', Decimal.parse('99'), Decimal.parse('9')],
      );
    });

    test('deleteItemFromId removes the item', () async {
      await repo.insert(SupplyItem(
        id: 1,
        name: 'Test Item 1',
        totalDose: Decimal.parse('50'),
        concentration: Decimal.parse('5'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

      await repo.insert(SupplyItem(
        id: 2,
        name: 'Test Item 2',
        totalDose: Decimal.parse('30'),
        concentration: Decimal.parse('3'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

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
        concentration: Decimal.parse('5'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

      await repo.insert(SupplyItem(
        id: 2,
        name: 'Test Item 2',
        totalDose: Decimal.parse('30'),
        concentration: Decimal.parse('3'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

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
        concentration: Decimal.parse('1'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

      await repo.insert(SupplyItem(
        id: 4,
        name: 'B',
        totalDose: Decimal.parse('100'),
        usedDose: Decimal.parse('10'),
        concentration: Decimal.parse('1'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

      await repo.insert(SupplyItem(
        id: 5,
        name: 'C',
        totalDose: Decimal.parse('100'),
        usedDose: Decimal.parse('50'),
        concentration: Decimal.parse('1'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

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
        concentration: Decimal.parse('2'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      );

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
