import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/util/string_parsing.dart';

void main() {
  group('string_parsing', () {
    test('toDecimalOrZero works correctly', () {
      // Arrange
      final cases = [
        {'value': '1', 'expected': Decimal.parse('1')},
        {'value': '1.5', 'expected': Decimal.parse('1.5')},
        {'value': '1,5', 'expected': Decimal.parse('1.5')},
        {'value': '0.01', 'expected': Decimal.parse('0.01')},
        {'value': 'abc', 'expected': Decimal.zero},
        {'value': '', 'expected': Decimal.zero},
      ];

      // Act
      final results =
          cases.map((c) => (c['value'] as String).toDecimalOrZero).toList();

      final expected = cases.map((c) => c['expected']).toList();

      // Assert
      expect(results, expected);
    });

    test('toDecimalOrNull works correctly', () {
      // Arrange
      final cases = [
        {'value': '', 'expected': null},
        {'value': '   ', 'expected': null},
        {'value': '1', 'expected': Decimal.parse('1')},
        {'value': '1.5', 'expected': Decimal.parse('1.5')},
        {'value': '1,5', 'expected': Decimal.parse('1.5')},
        {'value': 'abc', 'expected': null},
      ];

      // Act
      final results =
          cases.map((c) => (c['value'] as String).toDecimalOrNull).toList();

      final expected = cases.map((c) => c['expected']).toList();

      // Assert
      expect(results, expected);
    });
  });
}
