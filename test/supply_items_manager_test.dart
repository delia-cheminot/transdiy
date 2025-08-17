import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:transdiy/controllers/supply_item_manager.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'mocks.mocks.dart';

void main() {
  late SupplyItemManager manager;
  late MockSupplyItemState mockSupplyItemState;

  setUp(() {
    mockSupplyItemState = MockSupplyItemState();
    manager = SupplyItemManager(mockSupplyItemState);
  });

  group('SupplyItemManager', () {
    test('should update totalAmount correctly', () async {
      final item = SupplyItem(name: 'h', id: 1, totalAmount: 10, usedAmount: 2, dosePerUnit: 1);

      final newItem = await manager.setFields(
        item,
        newTotalAmount: 20,
        newUsedAmount: 5,
      );

      expect(newItem.totalAmount, 20);
      expect(newItem.usedAmount, 5);
      verify(mockSupplyItemState.updateItem(newItem)).called(1);
    });

    test(
        'should throw ArgumentError when invalid fields and item should remain unchanged',
        () {
      final item = SupplyItem(name: 'h', totalAmount: 10, usedAmount: 2, dosePerUnit: 1);

      expect(
        () => manager.setFields(
          item,
          newUsedAmount: 15,
        ),
        throwsArgumentError,
      );

      expect(item.usedAmount, 2);
    });

    test('should use amount correctly', () async {
      final item = SupplyItem(name: 'h', totalAmount: 20, usedAmount: 5, dosePerUnit: 1);

      await manager.useAmount(item, 5);

      expect(item.usedAmount, 10);
      verify(mockSupplyItemState.updateItem(item)).called(1);
    });

    test('should throw ArgumentError when using more amount than available',
        () {
      final item = SupplyItem(name: 'h', totalAmount: 10, usedAmount: 5, dosePerUnit: 1);

      expect(
        () => manager.useAmount(item, 6),
        throwsArgumentError,
      );

      expect(item.totalAmount, 10);
      expect(item.usedAmount, 5);
      verifyNever(mockSupplyItemState.updateItem(any));
    });

    test('use zero amount', () async {
      final item = SupplyItem(name: 'h', totalAmount: 10, usedAmount: 5, dosePerUnit: 1);

      await manager.useAmount(item, 0);

      expect(item.usedAmount, 5);
      verifyNever(mockSupplyItemState.updateItem(item));
    });
  });
}
