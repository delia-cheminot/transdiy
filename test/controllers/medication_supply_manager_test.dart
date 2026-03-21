import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mona/controllers/supply_item_manager.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/medication_supply.dart';
import 'package:mona/data/model/molecule.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  late SupplyItemManager manager;
  late MockSupplyItemProvider mockSupplyItemProvider;

  setUp(() {
    mockSupplyItemProvider = MockSupplyItemProvider();
    manager = SupplyItemManager(mockSupplyItemProvider);
  });

  group('MedicationSupplyManager', () {
    test('should use amount correctly', () async {
      final item = MedicationSupply(
        name: 'h',
        totalDose: Decimal.parse('20'),
        usedDose: Decimal.parse('5'),
        concentration: Decimal.parse('1'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      );

      late MedicationSupply updatedItem;
      when(mockSupplyItemProvider.updateItem(any))
          .thenAnswer((invocation) async {
        updatedItem = invocation.positionalArguments.first as MedicationSupply;
        return Future.value();
      });

      await manager.useDose(item, Decimal.parse('5'));

      expect(updatedItem.usedDose, Decimal.parse('10'));
    });

    test('should clamp dose when using more than available and update provider',
        () async {
      final item = MedicationSupply(
        name: 'h',
        totalDose: Decimal.parse('10'),
        usedDose: Decimal.parse('5'),
        concentration: Decimal.parse('1'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      );

      late MedicationSupply updatedItem;
      when(mockSupplyItemProvider.updateItem(any))
          .thenAnswer((invocation) async {
        updatedItem = invocation.positionalArguments.first as MedicationSupply;
        return Future.value();
      });

      await manager.useDose(item, Decimal.parse('6'));

      expect(item.usedDose, Decimal.parse('5'));
      expect(updatedItem.usedDose, Decimal.parse('10'));
    });

    test(
        'should clamp dose when putting back more than the maximum quantity of a supply and update provider',
        () async {
      final item = MedicationSupply(
        name: 'h',
        totalDose: Decimal.parse('10'),
        usedDose: Decimal.parse('5'),
        concentration: Decimal.parse('1'),
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.oral,
      );

      late MedicationSupply updatedItem;
      when(mockSupplyItemProvider.updateItem(any))
          .thenAnswer((invocation) async {
        updatedItem = invocation.positionalArguments.first as MedicationSupply;
        return Future.value();
      });

      await manager.useDose(item, Decimal.parse('-6'));

      expect(item.usedDose, Decimal.parse('5'));
      expect(updatedItem.usedDose, Decimal.parse('0'));
    });

    test('use zero amount', () async {
      final item = MedicationSupply(
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
}
