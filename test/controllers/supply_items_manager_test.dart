import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mona/controllers/supply_item_manager.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/data/model/medication_supply_item.dart';
import '../mocks/mocks.mocks.dart';

void main() {
  late SupplyItemManager manager;
  late MockSupplyItemProvider mockSupplyItemProvider;

  setUp(() {
    mockSupplyItemProvider = MockSupplyItemProvider();
    manager = SupplyItemManager(mockSupplyItemProvider);
  });

  group('SupplyItemManager', () {
    group('useDose', () {
      test('should use amount correctly', () async {
        final item = MedicationSupplyItem(
          name: 'h',
          totalDose: Decimal.parse('20'),
          usedDose: Decimal.parse('5'),
          concentration: Decimal.parse('1'),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
        );

        late MedicationSupplyItem updatedItem;
        when(mockSupplyItemProvider.updateItem(any))
            .thenAnswer((invocation) async {
          updatedItem =
              invocation.positionalArguments.first as MedicationSupplyItem;
          return Future.value();
        });

        await manager.useDose(item, Decimal.parse('5'));

        expect(updatedItem.usedDose, Decimal.parse('10'));
      });

      test(
          'should clamp dose when using more than available and update provider',
          () async {
        final item = MedicationSupplyItem(
          name: 'h',
          totalDose: Decimal.parse('10'),
          usedDose: Decimal.parse('5'),
          concentration: Decimal.parse('1'),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
        );

        late MedicationSupplyItem updatedItem;
        when(mockSupplyItemProvider.updateItem(any))
            .thenAnswer((invocation) async {
          updatedItem =
              invocation.positionalArguments.first as MedicationSupplyItem;
          return Future.value();
        });

        await manager.useDose(item, Decimal.parse('6'));

        expect(item.usedDose, Decimal.parse('5'));
        expect(updatedItem.usedDose, Decimal.parse('10'));
      });

      test(
          'should clamp dose when putting back more than the maximum quantity of a supply and update provider',
          () async {
        final item = MedicationSupplyItem(
          name: 'h',
          totalDose: Decimal.parse('10'),
          usedDose: Decimal.parse('5'),
          concentration: Decimal.parse('1'),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
        );

        late MedicationSupplyItem updatedItem;
        when(mockSupplyItemProvider.updateItem(any))
            .thenAnswer((invocation) async {
          updatedItem =
              invocation.positionalArguments.first as MedicationSupplyItem;
          return Future.value();
        });

        await manager.useDose(item, Decimal.parse('-6'));

        expect(item.usedDose, Decimal.parse('5'));
        expect(updatedItem.usedDose, Decimal.parse('0'));
      });

      test('use zero amount', () async {
        final item = MedicationSupplyItem(
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
    });

    group('switchItems', () {
      late final MedicationSupplyItem baseItem;

      MedicationSupplyItem? previousItem;
      MedicationSupplyItem? nextItem;

      MedicationSupplyItem? updatedItem;
      MedicationSupplyItem? updatedPreviousItem;
      MedicationSupplyItem? updatedNextItem;

      setUpAll(() {
        baseItem = MedicationSupplyItem(
          id: 0,
          name: 'progesterone',
          totalDose: Decimal.parse('30'),
          usedDose: Decimal.parse('10'),
          concentration: Decimal.parse('1'),
          molecule: KnownMolecules.progesterone,
          administrationRoute: AdministrationRoute.oral,
        );
      });

      setUp(() {
        previousItem = null;
        nextItem = null;
        updatedPreviousItem = null;
        updatedNextItem = null;

        when(mockSupplyItemProvider.updateItem(any))
            .thenAnswer((invocation) async {
          final item =
              invocation.positionalArguments.first as MedicationSupplyItem;
          updatedItem = item;
          if (item == previousItem) {
            updatedPreviousItem = item;
          } else if (item == nextItem) {
            updatedNextItem = item;
          }
        });
      });

      test('previousItem is null and nextItem is null', () async {
        manager.switchDoses(previousItem, nextItem, Decimal.ten, Decimal.zero);

        // Nothing should be updated because both items are null
        verifyNever(mockSupplyItemProvider.updateItem(any));
        expect(updatedPreviousItem, null);
        expect(updatedNextItem, null);
      });

      test('previousItem is null and nextItem is valid', () async {
        previousItem = null;
        nextItem = baseItem.copyWith(id: 1);

        manager.switchDoses(
            previousItem, nextItem, Decimal.one, Decimal.parse('2'));

        // Because the previous item is null, it should never be updated
        expect(updatedPreviousItem, null);
        expect(updatedNextItem?.usedDose, Decimal.parse('12'));
        verify(mockSupplyItemProvider.updateItem(any)).called(1);
      });

      test('previousItem is valid and nextItem is null', () async {
        previousItem = baseItem;
        nextItem = null;

        manager.switchDoses(
            previousItem, nextItem, Decimal.one, Decimal.parse('2'));

        expect(updatedPreviousItem?.usedDose, Decimal.parse('9'));
        // Because the next item is null, it should never be updated
        expect(updatedNextItem, null);
        verify(mockSupplyItemProvider.updateItem(any)).called(1);
      });

      test('previousItem and nextItem are the same', () async {
        previousItem = baseItem;
        nextItem = previousItem;

        manager.switchDoses(
            previousItem, nextItem, Decimal.parse('6'), Decimal.parse('7'));

        expect(updatedItem?.usedDose, Decimal.parse('11'));
        verify(mockSupplyItemProvider.updateItem(any)).called(1);
      });

      test('previousItem and nextItem are different and both valid', () async {
        previousItem = baseItem;
        nextItem = baseItem.copyWith(id: 1);

        manager.switchDoses(
            previousItem, nextItem, Decimal.parse('6'), Decimal.parse('7'));

        expect(updatedPreviousItem?.usedDose, Decimal.parse('4'));
        expect(updatedNextItem?.usedDose, Decimal.parse('17'));
        verify(mockSupplyItemProvider.updateItem(any)).called(2);
      });
    });
  });
}
