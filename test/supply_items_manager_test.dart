import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:transdiy/managers/supply_item_manager.dart';
import 'package:transdiy/models/supply_item.dart';
import 'mocks.mocks.dart';

void main() {
  late SupplyItemManager manager;
  late MockSuppliesState mockSuppliesState;

  setUp(() {
    mockSuppliesState = MockSuppliesState();
    manager = SupplyItemManager(mockSuppliesState);
  });

  group('SupplyItemManager', () {
    test('should update volume correctly', () async {
      final item = SupplyItem(id: 1, volume: 10, usedVolume: 2);

      await manager.setFields(
        item,
        newVolume: 20,
        newUsedVolume: 5,
      );

      expect(item.volume, 20);
      expect(item.usedVolume, 5);
      verify(mockSuppliesState.updateItem(item)).called(1);
    });

    test('should throw ArgumentError when newUsedVolume exceeds volume', () {
      final item = SupplyItem(volume: 10, usedVolume: 2);

      expect(
        () => manager.setFields(
          item,
          newUsedVolume: 15,
        ),
        throwsArgumentError,
      );
    });

    test('should use volume correctly', () async {
      final item = SupplyItem(volume: 20, usedVolume: 5);

      await manager.useVolume(item, 5);

      expect(item.usedVolume, 10);
      verify(mockSuppliesState.updateItem(item)).called(1);
    });

    test('should throw ArgumentError when using more volume than available', () {
      final item = SupplyItem(volume: 10, usedVolume: 5);

      expect(
        () => manager.useVolume(item, 6),
        throwsArgumentError,
      );

      expect(item.volume, 10);
      expect(item.usedVolume, 5);
      verifyNever(mockSuppliesState.updateItem(any));
    });

    test('use zero volume', () async {
      final item = SupplyItem(volume: 10, usedVolume: 5);

      await manager.useVolume(item, 0);

      expect(item.usedVolume, 5);
      verifyNever(mockSuppliesState.updateItem(item));
    });
  });
}