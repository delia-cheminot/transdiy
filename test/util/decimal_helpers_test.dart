import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/util/decimal_helpers.dart';

void main() {
  group('decimal_helpers', () {
    test('parseDecimal works correctly', () {
      // Arrange
      final cases = [
        {'value': '1', 'expected': Decimal.parse('1')},
        {'value': '1.5', 'expected': Decimal.parse('1.5')},
        {'value': '1,5', 'expected': Decimal.parse('1.5')},
        {'value': '0.01', 'expected': Decimal.parse('0.01')},
        {'value': 'abc', 'expected': FormatException},
        {'value': '', 'expected': FormatException},
      ];

      // Act
      final results = cases.map((c) {
        try {
          return parseDecimal(c['value'] as String);
        } catch (e) {
          return e.runtimeType;
        }
      }).toList();

      final expected = cases.map((c) => c['expected']).toList();

      // Assert
      expect(results, expected);
    });

    test('parseOptionalDecimal works correctly', () {
      // Arrange
      final cases = [
        {'value': '', 'expected': null},
        {'value': '   ', 'expected': null},
        {'value': '1', 'expected': Decimal.parse('1')},
        {'value': '1.5', 'expected': Decimal.parse('1.5')},
        {'value': '1,5', 'expected': Decimal.parse('1.5')},
        {'value': 'abc', 'expected': FormatException},
      ];

      // Act
      final results = cases.map((c) {
        try {
          return parseOptionalDecimal(c['value'] as String);
        } catch (e) {
          return e.runtimeType;
        }
      }).toList();

      final expected = cases.map((c) => c['expected']).toList();

      // Assert
      expect(results, expected);
    });
  });
}
