import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mona/controllers/supply_item_manager.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/data/model/supply_item.dart';
import '../mocks/mocks.mocks.dart';

void main() {
  late SupplyItemManager manager;
  late MockSupplyItemProvider mockSupplyItemProvider;

  setUp(() {
    mockSupplyItemProvider = MockSupplyItemProvider();
    manager = SupplyItemManager(mockSupplyItemProvider);
  });

  group('SupplyItemManager', () {
    test('should use amount correctly', () async {
      final item = SupplyItem(
        name: 'h',
        totalDose: Decimal.parse('20'),
        usedDose: Decimal.parse('5'),
        concentration: Decimal.parse('1'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      );

      late SupplyItem updatedItem;
      when(mockSupplyItemProvider.updateItem(any))
          .thenAnswer((invocation) async {
        updatedItem = invocation.positionalArguments.first as SupplyItem;
        return Future.value();
      });

      await manager.useDose(item, Decimal.parse('5'));

      expect(updatedItem.usedDose, Decimal.parse('10'));
    });

    test('should clamp dose when using more than available and update provider',
        () async {
      final item = SupplyItem(
        name: 'h',
        totalDose: Decimal.parse('10'),
        usedDose: Decimal.parse('5'),
        concentration: Decimal.parse('1'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      );

      late SupplyItem updatedItem;
      when(mockSupplyItemProvider.updateItem(any))
          .thenAnswer((invocation) async {
        updatedItem = invocation.positionalArguments.first as SupplyItem;
        return Future.value();
      });

      await manager.useDose(item, Decimal.parse('6'));

      expect(item.usedDose, Decimal.parse('5'));
      expect(updatedItem.usedDose, Decimal.parse('10'));
    });

    test(
        'should clamp dose when putting back more than the maximum quantity of a supply and update provider',
        () async {
      final item = SupplyItem(
        name: 'h',
        totalDose: Decimal.parse('10'),
        usedDose: Decimal.parse('5'),
        concentration: Decimal.parse('1'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      );

      late SupplyItem updatedItem;
      when(mockSupplyItemProvider.updateItem(any))
          .thenAnswer((invocation) async {
        updatedItem = invocation.positionalArguments.first as SupplyItem;
        return Future.value();
      });

      await manager.useDose(item, Decimal.parse('-6'));

      expect(item.usedDose, Decimal.parse('5'));
      expect(updatedItem.usedDose, Decimal.parse('0'));
    });

    test('use zero amount', () async {
      final item = SupplyItem(
        name: 'h',
        totalDose: Decimal.parse('10'),
        usedDose: Decimal.parse('5'),
        concentration: Decimal.parse('1'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      );

      await manager.useDose(item, Decimal.zero);

      expect(item.usedDose, Decimal.parse('5'));
      verifyNever(mockSupplyItemProvider.updateItem(item));
    });

    // switchItems
    test('previousItem is null and nextItem is null', () async {
      final SupplyItem? previousItem = null;
      final SupplyItem? nextItem = null;

      SupplyItem? updatedItem;
      when(mockSupplyItemProvider.updateItem(any))
          .thenAnswer((invocation) async {
        updatedItem = invocation.positionalArguments.first as SupplyItem;
        return Future.value();
      });

      manager.switchDoses(previousItem, nextItem, Decimal.ten, Decimal.zero);

      // Nothing should be updated because both items are null
      expect(updatedItem, null);
      });

    test('previousItem is null and nextItem is valid', () async {
      final SupplyItem? previousItem = null;
      final SupplyItem nextItem = SupplyItem(
        name: 'progesterone',
        totalDose: Decimal.parse('30'),
        usedDose: Decimal.parse('1'),
        concentration: Decimal.parse('1'),
        molecule: KnownMolecules.progesterone,
        administrationRoute: AdministrationRoute.oral,
      );

      // Because the previous item is null, it should never be updated
      SupplyItem? updatedPreviousItem;
      when(mockSupplyItemProvider.updateItem(nextItem))
          .thenAnswer((invocation) async {
        updatedPreviousItem = invocation.positionalArguments.first as SupplyItem;
        return Future.value();
      });

      late SupplyItem updatedItem;
      when(mockSupplyItemProvider.updateItem(nextItem))
          .thenAnswer((invocation) async {
        updatedItem = invocation.positionalArguments.first as SupplyItem;
        return Future.value();
      });

      manager.switchDoses(previousItem, nextItem, Decimal.one, Decimal.parse('2'));

      expect(updatedItem.usedDose, Decimal.parse('3'));
      expect(updatedPreviousItem, null);
    });

    test('previousItem is valid and nextItem is null', () async {
      final SupplyItem previousItem = SupplyItem(
        name: 'progesterone',
        totalDose: Decimal.parse('30'),
        usedDose: Decimal.parse('1'),
        concentration: Decimal.parse('1'),
        molecule: KnownMolecules.progesterone,
        administrationRoute: AdministrationRoute.oral,
      );
      final SupplyItem? nextItem = null;

      // Because the next item is null, it should never be updated
      SupplyItem? updatedNextItem;
      when(mockSupplyItemProvider.updateItem(nextItem))
          .thenAnswer((invocation) async {
        updatedNextItem = invocation.positionalArguments.first as SupplyItem;
        return Future.value();
      });

      late SupplyItem updatedPreviousItem;
      when(mockSupplyItemProvider.updateItem(previousItem))
          .thenAnswer((invocation) async {
        updatedPreviousItem = invocation.positionalArguments.first as SupplyItem;
        return Future.value();
      });

      manager.switchDoses(previousItem, nextItem, Decimal.one, Decimal.parse('2'));

      expect(updatedPreviousItem.usedDose, Decimal.zero);
      expect(updatedNextItem, null);
    });

    test('previousItem and nextItem are the same', () async {
      final SupplyItem previousItem = SupplyItem(
        name: 'progesterone',
        totalDose: Decimal.parse('30'),
        usedDose: Decimal.parse('20'),
        concentration: Decimal.parse('1'),
        molecule: KnownMolecules.progesterone,
        administrationRoute: AdministrationRoute.oral,
      );

      final SupplyItem nextItem = previousItem;
      
      late SupplyItem updatedItem;
      when(mockSupplyItemProvider.updateItem(any))
          .thenAnswer((invocation) async {
        updatedItem = invocation.positionalArguments.first as SupplyItem;
        return Future.value();
      });

      manager.switchDoses(previousItem, nextItem, Decimal.parse('6'), Decimal.parse('7'));

      expect(updatedItem.usedDose, Decimal.parse('21'));
    });
  });
}
