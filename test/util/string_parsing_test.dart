import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/util/string_parsing.dart';

void main() {
  group('string_parsing', () {
    test('isEmpty works correctly', () {
      // Arrange
      final cases = <Map<String, Object?>>[
        {'value': null, 'expected': true},
        {'value': '', 'expected': true},
        {'value': '   ', 'expected': true},
        {'value': 'a', 'expected': false},
        {'value': '  x  ', 'expected': false},
      ];

      // Act
      final results =
          cases.map((c) => (c['value'] as String?).isEmpty).toList();
      final expected = cases.map((c) => c['expected'] as bool).toList();

      // Assert
      expect(results, expected);
    });

    test('isDecimal works correctly', () {
      // Arrange
      final cases = <Map<String, Object?>>[
        {'value': null, 'expected': false},
        {'value': '', 'expected': false},
        {'value': '1', 'expected': true},
        {'value': '1,5', 'expected': true},
        {'value': 'x', 'expected': false},
      ];

      // Act
      final results =
          cases.map((c) => (c['value'] as String?).isDecimal).toList();
      final expected = cases.map((c) => c['expected'] as bool).toList();

      // Assert
      expect(results, expected);
    });

    test('toDecimal works correctly', () {
      // Arrange
      final cases = <Map<String, Object?>>[
        {'value': '1', 'expected': Decimal.parse('1')},
        {'value': '1.5', 'expected': Decimal.parse('1.5')},
        {'value': '1,5', 'expected': Decimal.parse('1.5')},
      ];

      // Act
      final results =
          cases.map((c) => (c['value'] as String?).toDecimal).toList();
      final expected = cases.map((c) => c['expected'] as Decimal).toList();

      // Assert
      expect(results, expected);
    });

    test('toDecimal throws on invalid input', () {
      // Arrange
      final cases = <String?>[null, '', 'abc'];

      // Act
      final actions = cases.map((v) => () => v.toDecimal).toList();

      // Assert
      expect(actions, everyElement(throwsFormatException));
    });

    test('toDateTimeOrNull works correctly', () {
      // Arrange
      final cases = <Map<String, Object?>>[
        {'value': null, 'expected': null},
        {'value': '', 'expected': null},
        {'value': '   ', 'expected': null},
        {'value': '2024-01-15', 'expected': DateTime(2024, 1, 15)},
        {
          'value': '2024-01-15T14:30:00Z',
          'expected': DateTime.utc(2024, 1, 15, 14, 30, 0),
        },
      ];

      // Act
      final results =
          cases.map((c) => (c['value'] as String?).toDateTimeOrNull).toList();
      final expected = cases.map((c) => c['expected'] as DateTime?).toList();

      // Assert
      expect(results, expected);
    });

    test('toDateTime works correctly', () {
      // Arrange
      final cases = <Map<String, Object?>>[
        {'value': '2024-06-01', 'expected': DateTime(2024, 6, 1)},
      ];

      // Act
      final results =
          cases.map((c) => (c['value'] as String).toDateTime).toList();
      final expected = cases.map((c) => c['expected'] as DateTime).toList();

      // Assert
      expect(results, expected);
    });

    test('toIntOrZero works correctly', () {
      // Arrange
      final cases = <Map<String, Object?>>[
        {'value': null, 'expected': 0},
        {'value': '', 'expected': 0},
        {'value': '42', 'expected': 42},
        {'value': '  7  ', 'expected': 7},
        {'value': '1,000', 'expected': 0},
      ];

      // Act
      final results =
          cases.map((c) => (c['value'] as String?).toIntOrZero).toList();
      final expected = cases.map((c) => c['expected'] as int).toList();

      // Assert
      expect(results, expected);
    });

    test('toInt works correctly', () {
      // Arrange
      final cases = <Map<String, Object?>>[
        {'value': '0', 'expected': 0},
        {'value': '99', 'expected': 99},
      ];

      // Act
      final results = cases.map((c) => (c['value'] as String).toInt).toList();
      final expected = cases.map((c) => c['expected'] as int).toList();

      // Assert
      expect(results, expected);
    });

    test('toInt throws on invalid input', () {
      // Arrange
      final cases = <String?>[null, '', 'x'];

      // Act
      final actions = cases.map((v) => () => v.toInt).toList();

      // Assert
      expect(actions, everyElement(throwsFormatException));
    });

    test('toDecimalOrZero works correctly', () {
      // Arrange
      final cases = <Map<String, Object?>>[
        {'value': '1', 'expected': Decimal.parse('1')},
        {'value': '1.5', 'expected': Decimal.parse('1.5')},
        {'value': '1,5', 'expected': Decimal.parse('1.5')},
        {'value': '0.01', 'expected': Decimal.parse('0.01')},
        {'value': 'abc', 'expected': Decimal.zero},
        {'value': '', 'expected': Decimal.zero},
        {'value': null, 'expected': Decimal.zero},
      ];

      // Act
      final results =
          cases.map((c) => (c['value'] as String?).toDecimalOrZero).toList();
      final expected = cases.map((c) => c['expected'] as Decimal).toList();

      // Assert
      expect(results, expected);
    });

    test('toDecimalOrNull works correctly', () {
      // Arrange
      final cases = <Map<String, Object?>>[
        {'value': null, 'expected': null},
        {'value': '', 'expected': null},
        {'value': '   ', 'expected': null},
        {'value': '1', 'expected': Decimal.parse('1')},
        {'value': '1.5', 'expected': Decimal.parse('1.5')},
        {'value': '1,5', 'expected': Decimal.parse('1.5')},
        {'value': 'abc', 'expected': null},
      ];

      // Act
      final results =
          cases.map((c) => (c['value'] as String?).toDecimalOrNull).toList();
      final expected = cases.map((c) => c['expected'] as Decimal?).toList();

      // Assert
      expect(results, expected);
    });
  });
}
