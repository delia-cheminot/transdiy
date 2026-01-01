import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:transdiy/controllers/supply_item_manager.dart';
import 'package:transdiy/data/model/supply_item.dart';
import '../mocks/mocks.mocks.dart';

void main() {
  late SupplyItemManager manager;
  late MockSupplyItemProvider mockSupplyItemProvider;

  setUp(() {
    mockSupplyItemProvider = MockSupplyItemProvider();
    manager = SupplyItemManager(mockSupplyItemProvider);
  });

  group('SupplyItemManager', () {
    test('should update totalAmount and usedDose correctly', () async {
      final item = SupplyItem(
          name: 'h',
          id: 1,
          totalDose: Decimal.parse('10'),
          usedDose: Decimal.parse('2'),
          dosePerUnit: Decimal.parse('1'));

      final newItem = await manager.setFields(
        item,
        newTotalDose: Decimal.parse('20'),
        newUsedDose: Decimal.parse('5'),
      );

      expect(newItem.totalDose, Decimal.parse('20'));
      expect(newItem.usedDose, Decimal.parse('5'));
    });

    test(
        'should throw ArgumentError when invalid fields and item should remain unchanged',
        () {
      final item = SupplyItem(
          name: 'h',
          totalDose: Decimal.parse('10'),
          usedDose: Decimal.parse('2'),
          dosePerUnit: Decimal.parse('1'));

      expect(
        () => manager.setFields(
          item,
          newUsedDose: Decimal.parse('15'),
        ),
        throwsArgumentError,
      );

      expect(item.usedDose, Decimal.parse('2'));
    });

    test('should use amount correctly', () async {
      final item = SupplyItem(
          name: 'h',
          totalDose: Decimal.parse('20'),
          usedDose: Decimal.parse('5'),
          dosePerUnit: Decimal.parse('1'));

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
        dosePerUnit: Decimal.parse('1'),
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

    test('use zero amount', () async {
      final item = SupplyItem(
          name: 'h',
          totalDose: Decimal.parse('10'),
          usedDose: Decimal.parse('5'),
          dosePerUnit: Decimal.parse('1'));

      await manager.useDose(item, Decimal.zero);

      expect(item.usedDose, Decimal.parse('5'));
      verifyNever(mockSupplyItemProvider.updateItem(item));
    });
  });
}
