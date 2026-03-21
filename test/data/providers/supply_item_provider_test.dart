import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/generic_supply.dart';
import 'package:mona/data/model/medication_supply.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/data/model/supply_item.dart';
import 'package:mona/data/model/supply_type.dart';
import 'package:mona/data/providers/supply_item_provider.dart';

import 'generic_repository_mock.dart';

void main() {
  late SupplyItemProvider provider;
  late GenericRepositoryMock<SupplyItem> repo;

  setUp(() async {
    repo = GenericRepositoryMock<SupplyItem>(
      withId: (item, id) {
        if (item.getType()==SupplyType.medication) {
          return (item as MedicationSupply).copyWith(id: id);
        }
        else {
          return (item as GenericSupply).copyWith(id: id);
        }
      },
    );
    provider = SupplyItemProvider(repository: repo);
  });

  group('SupplyItemProvider Tests', () {
    test('initialization loads medication items', () async {
      await repo.insert(
        MedicationSupply(
          id: 1,
          name: 'Test Item 1',
          totalDose: Decimal.parse('50'),
          concentration: Decimal.parse('5'),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
        ),
      );

      await repo.insert(MedicationSupply(
        id: 2,
        name: 'Test Item 2',
        totalDose: Decimal.parse('30'),
        concentration: Decimal.parse('3'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

      await provider.fetchAll();

      expect(provider.medicationItems.length, repo.items.length);
    });

    test('initialization loads generic items', () async {
      await repo.insert(
        GenericSupply(
          id: 1,
          name: 'Test Item 1',
          quantity: 2
        ),
      );

      await repo.insert(GenericSupply(
        id: 2,
        name: 'Test Item 2',
        quantity: 3
      ));

      await provider.fetchAll();

      expect(provider.genericItems.length, repo.items.length);
    });

    test('add inserts a new medication item', () async {
      // Arrange
      final itemToAdd = MedicationSupply(
        name: 'New Item',
        totalDose: Decimal.parse('20'),
        concentration: Decimal.parse('2'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      );

      // Act
      await provider.add(itemToAdd);

      // Assert
      expect(provider.medicationItems, contains(itemToAdd));
    });

    test('add inserts a new generic item', () async {
      // Arrange
      final itemToAdd = GenericSupply(
        name: 'New Item',
        quantity: 3
      );

      // Act
      await provider.add(itemToAdd);

      // Assert
      expect(provider.genericItems, contains(itemToAdd));
    });

    test('updateItem updates an existing medication item', () async {
      await repo.insert(MedicationSupply(
        id: 1,
        name: 'Test Item 1',
        totalDose: Decimal.parse('50'),
        concentration: Decimal.parse('5'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

      await repo.insert(MedicationSupply(
        id: 2,
        name: 'Test Item 2',
        totalDose: Decimal.parse('30'),
        concentration: Decimal.parse('3'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

      final itemToUpdate = repo.items.first;
      final updatedItem = MedicationSupply(
        id: itemToUpdate.getId(),
        name: 'Updated Name',
        totalDose: Decimal.parse('99'),
        concentration: Decimal.parse('9'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      );

      await provider.updateItem(updatedItem);

      //medicationItems getter sorts by name, moving 'Updated Name' after 'Test Item'
      final firstItem = provider.medicationItems.last;
      expect(
        [firstItem.name, firstItem.totalDose, firstItem.concentration],
        ['Updated Name', Decimal.parse('99'), Decimal.parse('9')],
      );
    });

    test('updateItem updates an existing generic item', () async {
      await repo.insert(GenericSupply(
        id: 1,
        name: 'Test Item 1',
        quantity: 1
      ));

      await repo.insert(GenericSupply(
        id: 2,
        name: 'Test Item 2',
        quantity: 2
      ));

      final itemToUpdate = repo.items.first;
      final updatedItem = GenericSupply(
        id: itemToUpdate.getId(),
        name: 'Updated Name',
        quantity: 3
      );

      await provider.updateItem(updatedItem);

      //genericItems getter sorts by name, moving 'Updated Name' after 'Test Item'
      final firstItem = provider.genericItems.last;
      expect(
        [firstItem.name, firstItem.quantity],
        ['Updated Name', 3],
      );
    });

    test('deleteItemFromId removes the medication item', () async {
      await repo.insert(MedicationSupply(
        id: 1,
        name: 'Test Item 1',
        totalDose: Decimal.parse('50'),
        concentration: Decimal.parse('5'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

      await repo.insert(MedicationSupply(
        id: 2,
        name: 'Test Item 2',
        totalDose: Decimal.parse('30'),
        concentration: Decimal.parse('3'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

      await provider.deleteItemFromId(1);

      expect(
        [provider.medicationItems.length, provider.medicationItems.first.id],
        [1, 2],
      );
    });

    test('deleteItemFromId removes the generic item', () async {
      await repo.insert(GenericSupply(
        id: 1,
        name: 'Test Item 1',
        quantity: 1
      ));

      await repo.insert(GenericSupply(
        id: 2,
        name: 'Test Item 2',
        quantity: 2
      ));

      await provider.deleteItemFromId(1);

      expect(
        [provider.genericItems.length, provider.genericItems.first.id],
        [1, 2],
      );
    });

    test('deleteItem removes the medication item by object', () async {
      await repo.insert(MedicationSupply(
        id: 1,
        name: 'Test Item 1',
        totalDose: Decimal.parse('50'),
        concentration: Decimal.parse('5'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

      await repo.insert(MedicationSupply(
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
        [provider.medicationItems.length, provider.medicationItems.first.id],
        [1, 2],
      );
    });

    test('deleteItem removes the generic item by object', () async {
      await repo.insert(GenericSupply(
        id: 1,
        name: 'Test Item 1',
        quantity: 1
      ));

      await repo.insert(GenericSupply(
        id: 2,
        name: 'Test Item 2',
        quantity: 2
      ));

      final itemToDelete = repo.items.first;

      await provider.deleteItem(itemToDelete);

      expect(
        [provider.genericItems.length, provider.genericItems.first.id],
        [1, 2],
      );
    });

    test('medicationSuppliesOrderedByRemainingDose orders items with most used/total first',
        () async {
      await repo.insert(MedicationSupply(
        id: 3,
        name: 'A',
        totalDose: Decimal.parse('100'),
        usedDose: Decimal.parse('90'),
        concentration: Decimal.parse('1'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

      await repo.insert(MedicationSupply(
        id: 4,
        name: 'B',
        totalDose: Decimal.parse('100'),
        usedDose: Decimal.parse('10'),
        concentration: Decimal.parse('1'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

      await repo.insert(MedicationSupply(
        id: 5,
        name: 'C',
        totalDose: Decimal.parse('100'),
        usedDose: Decimal.parse('50'),
        concentration: Decimal.parse('1'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      ));

      await repo.insert(GenericSupply(
        id: 6,
        name: 'D',
        quantity: 6
      ));

      await provider.fetchAll();

      final ordered = provider.medicationSuppliesOrderedByRemainingDose;

      expect(ordered.map((e) => e.name).toList(), ['A', 'C', 'B']);
    });

    test(
        'getMostUsedItemForMedication returns the most used item for medication',
        () async {
      // Arrange
      final baseItem = MedicationSupply(
        id: 1,
        name: 'E vial',
        totalDose: Decimal.parse('200'),
        usedDose: Decimal.parse('150'),
        concentration: Decimal.parse('2'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.injection,
        ester: Ester.valerate,
      );

      await repo.insert(baseItem);
      await repo.insert(baseItem.copyWith(
        id: 2,
        usedDose: Decimal.parse('50'),
      ));
      await repo.insert(baseItem.copyWith(
        id: 3,
        usedDose: Decimal.parse('100'),
      ));
      await provider.fetchAll();

      // Act
      final mostUsed = provider.getMostUsedItemForMedication(
        KnownMolecules.estradiol,
        AdministrationRoute.injection,
        Ester.valerate,
      );

      // Assert
      expect(mostUsed?.id, 1);
    });

    test('getMostUsedItemForMedication ignores other administration routes',
        () async {
      // Arrange
      final injectionItem = MedicationSupply(
        id: 1,
        name: 'Injection',
        totalDose: Decimal.parse('200'),
        usedDose: Decimal.parse('50'),
        concentration: Decimal.parse('2'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.injection,
        ester: Ester.valerate,
      );

      final oralItem = injectionItem.copyWith(
        id: 2,
        administrationRoute: AdministrationRoute.oral,
        usedDose: Decimal.parse('150'),
        ester: null,
      );
      await repo.insert(injectionItem);
      await repo.insert(oralItem);
      await provider.fetchAll();

      // Act
      final mostUsed = provider.getMostUsedItemForMedication(
        KnownMolecules.estradiol,
        AdministrationRoute.injection,
        Ester.valerate,
      );

      // Assert
      expect(mostUsed?.id, 1);
    });

    test('getMostUsedItemForMedication returns null if no matching item',
        () async {
      // Arrange
      final oralItem = MedicationSupply(
        id: 1,
        name: 'Injection',
        totalDose: Decimal.parse('200'),
        usedDose: Decimal.parse('50'),
        concentration: Decimal.parse('2'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      );
      await repo.insert(oralItem);
      await provider.fetchAll();

      // Act
      final mostUsed = provider.getMostUsedItemForMedication(
        KnownMolecules.estradiol,
        AdministrationRoute.injection,
        Ester.valerate,
      );

      // Assert
      expect(mostUsed, null);
    });

    group('getItemsForMedication', () {
      test('returns matching items ordered by most used first', () async {
        // Arrange
        final baseItem = MedicationSupply(
          id: 1,
          name: 'E vial A',
          totalDose: Decimal.parse('200'),
          usedDose: Decimal.parse('150'),
          concentration: Decimal.parse('2'),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.injection,
          ester: Ester.valerate,
        );
        await repo.insert(baseItem);
        await repo.insert(baseItem.copyWith(
          id: 2,
          name: 'E vial B',
          usedDose: Decimal.parse('50'),
        ));
        await repo.insert(baseItem.copyWith(
          id: 3,
          name: 'E vial C',
          usedDose: Decimal.parse('100'),
        ));
        await provider.fetchAll();

        // Act
        final items = provider.getItemsForMedication(
          KnownMolecules.estradiol,
          AdministrationRoute.injection,
          Ester.valerate,
        );

        // Assert
        expect(items.map((e) => e.id).toList(), [1, 3, 2]);
      });

      test('returns empty list when no matching item', () async {
        // Arrange
        await repo.insert(MedicationSupply(
          id: 1,
          name: 'Oral only',
          totalDose: Decimal.parse('50'),
          concentration: Decimal.parse('5'),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
        ));
        await provider.fetchAll();

        // Act
        final items = provider.getItemsForMedication(
          KnownMolecules.estradiol,
          AdministrationRoute.injection,
          Ester.valerate,
        );

        // Assert
        expect(items, isEmpty);
      });

      test('returns empty list when items list is empty', () async {
        // Arrange
        await provider.fetchAll();

        // Act
        final items = provider.getItemsForMedication(
          KnownMolecules.estradiol,
          AdministrationRoute.injection,
          Ester.valerate,
        );

        // Assert
        expect(items, isEmpty);
      });

      test('returns single item when only one matches molecule route and ester',
          () async {
        // Arrange
        final matchItem = MedicationSupply(
          id: 1,
          name: 'Match',
          totalDose: Decimal.parse('200'),
          usedDose: Decimal.parse('50'),
          concentration: Decimal.parse('2'),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.injection,
          ester: Ester.valerate,
        );
        await repo.insert(matchItem);
        await repo.insert(matchItem.copyWith(
          id: 2,
          name: 'Other molecule',
          molecule: KnownMolecules.progesterone,
        ));
        await repo.insert(matchItem.copyWith(
          id: 3,
          name: 'Other route',
          administrationRoute: AdministrationRoute.oral,
          ester: null,
        ));
        await repo.insert(matchItem.copyWith(
          id: 4,
          name: 'Other ester',
          ester: Ester.enanthate,
        ));
        await provider.fetchAll();

        // Act
        final items = provider.getItemsForMedication(
          KnownMolecules.estradiol,
          AdministrationRoute.injection,
          Ester.valerate,
        );

        // Assert
        expect(items.map((e) => e.id).toList(), [1]);
      });

      test('returns the matching item when others differ by molecule route or ester',
          () async {
        // Arrange
        final matchItem = MedicationSupply(
          id: 1,
          name: 'Match',
          totalDose: Decimal.parse('200'),
          usedDose: Decimal.parse('50'),
          concentration: Decimal.parse('2'),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.injection,
          ester: Ester.valerate,
        );
        await repo.insert(matchItem);
        await repo.insert(matchItem.copyWith(
          id: 2,
          name: 'Other molecule',
          molecule: KnownMolecules.progesterone,
        ));
        await repo.insert(matchItem.copyWith(
          id: 3,
          name: 'Other route',
          administrationRoute: AdministrationRoute.oral,
          ester: null,
        ));
        await repo.insert(matchItem.copyWith(
          id: 4,
          name: 'Other ester',
          ester: Ester.enanthate,
        ));
        await provider.fetchAll();

        // Act
        final items = provider.getItemsForMedication(
          KnownMolecules.estradiol,
          AdministrationRoute.injection,
          Ester.valerate,
        );

        // Assert
        expect(items.single.id, 1);
      });
    });
  });
}
