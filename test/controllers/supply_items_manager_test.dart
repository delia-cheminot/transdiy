import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:transdiy/controllers/supply_item_manager.dart';
import 'package:transdiy/data/model/supply_item.dart';
import '../mocks/mocks.mocks.dart';

void main() {
  late SupplyItemManager manager;
  late MockSupplyItemProvider mockSupplyItemState;

  setUp(() {
    mockSupplyItemState = MockSupplyItemProvider();
    manager = SupplyItemManager(mockSupplyItemState);
  });

  group('SupplyItemManager', () {
    test('should update totalAmount correctly', () async {
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
      verify(mockSupplyItemState.updateItem(newItem)).called(1);
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
      when(mockSupplyItemState.updateItem(any)).thenAnswer((invocation) async {
        updatedItem = invocation.positionalArguments.first as SupplyItem;
        return Future.value();
      });

      await manager.useDose(item, Decimal.parse('5'));

      expect(updatedItem.usedDose, Decimal.parse('10'));
      verify(mockSupplyItemState.updateItem(updatedItem)).called(1);
    });

    test('should throw ArgumentError when using more amount than available',
        () {
      final item = SupplyItem(
          name: 'h',
          totalDose: Decimal.parse('10'),
          usedDose: Decimal.parse('5'),
          dosePerUnit: Decimal.parse('1'));

      expect(
        () => manager.useDose(item, Decimal.parse('6')),
        throwsArgumentError,
      );

      expect(item.totalDose, Decimal.parse('10'));
      expect(item.usedDose, Decimal.parse('5'));
      verifyNever(mockSupplyItemState.updateItem(any));
    });

    test('use zero amount', () async {
      final item = SupplyItem(
          name: 'h',
          totalDose: Decimal.parse('10'),
          usedDose: Decimal.parse('5'),
          dosePerUnit: Decimal.parse('1'));

      await manager.useDose(item, Decimal.zero);

      expect(item.usedDose, Decimal.parse('5'));
      verifyNever(mockSupplyItemState.updateItem(item));
    });
  });
}
