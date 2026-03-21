import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/generic_supply.dart';

void main() {
  group('AdministrationSupply model', () {
    test('toMap and fromMap should preserve values', () {
      // Arrange
      final item = GenericSupply(
        id: 1,
        name: 'Test Item',
        quantity: 2,
      );

      // Act
      final map = item.toMap();
      final fromMap = GenericSupply.fromMap(map);

      // Assert
      expect(
          fromMap,
          isA<GenericSupply>()
              .having((s) => s.id, 'id', item.id)
              .having((s) => s.name, 'name', item.name)
              .having((s) => s.quantity, 'quantity',
              item.quantity)
      );
    });

    group('validators', () {
      test('validateName', () {
        // Arrange
        final cases = [
          {'value': null, 'expected': isNotNull},
          {'value': '', 'expected': isNotNull},
        ];

        // Act
        final results = cases
            .map((c) =>
            GenericSupply.validateName(c['value'] as String?))
            .toList();
        final expected = cases.map((c) => c['expected'] as Matcher).toList();

        // Assert
        expect(results, expected);
      });

      test('validateRemainingQuantity', () {
        // Arrange
        final cases = [
          {'value': null, 'expected': isNotNull},
          {'value': '', 'expected': isNotNull},
          {'value': '-1', 'expected': isNotNull},
          {'value': '200', 'expected': isNull},
          {'value': '50', 'expected': isNull},
        ];

        // Act
        final results = cases
            .map((c) => GenericSupply.validateRemainingQuantity(c['value'] as String?)).toList();
        final expected = cases.map((c) => c['expected'] as Matcher).toList();

        expect(results, expected);
      });

      test('quantity returns correct value', () {
        // Arrange
        final item = GenericSupply(
          name: 'Remaining',
          quantity: 70,
        );

        // Act
        final remaining = item.quantity;

        // Assert
        expect(remaining, 70);
      });
    });
  });
}