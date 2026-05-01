import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/l10n/app_localizations_en.dart';
import 'package:mona/util/validators.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('validators', () {
    test('requiredString works correctly', () {
      // Arrange
      final cases = [
        {'value': null, 'expected': isNotNull},
        {'value': '', 'expected': isNotNull},
        {'value': 'hello', 'expected': isNull},
        {'value': '   ', 'expected': isNotNull},
      ];

      // Act
      final results = cases
          .map((c) => requiredString(l10n, c['value'] as String?))
          .toList();
      final expected = cases.map((c) => c['expected'] as Matcher).toList();

      // Assert
      expect(results, expected);
    });

    test('requiredDate works correctly', () {
      // Arrange
      final cases = [
        {'value': null, 'expected': isNotNull},
        {'value': DateTime.now(), 'expected': isNull},
      ];

      // Act
      final results = cases
          .map((c) => requiredDateTime(l10n, c['value'] as DateTime?))
          .toList();
      final expected = cases.map((c) => c['expected'] as Matcher).toList();

      // Assert
      expect(results, expected);
    });

    test('requiredMolecule works correctly', () {
      // Arrange
      final cases = [
        {'value': null, 'expected': isNotNull},
        {'value': KnownMolecules.bicalutamide, 'expected': isNull},
      ];

      // Act
      final results = cases
          .map((c) => requiredMolecule(l10n, c['value'] as Molecule?))
          .toList();
      final expected = cases.map((c) => c['expected'] as Matcher).toList();

      // Assert
      expect(results, expected);
    });

    test('requiredAdministrationRoute works correctly', () {
      // Arrange
      final cases = [
        {'value': null, 'expected': isNotNull},
        {'value': AdministrationRoute.suppository, 'expected': isNull},
      ];

      // Act
      final results = cases
          .map((c) => requiredAdministrationRoute(
                l10n,
                c['value'] as AdministrationRoute?,
              ))
          .toList();
      final expected = cases.map((c) => c['expected'] as Matcher).toList();

      // Assert
      expect(results, expected);
    });

    test('strictlyPositiveDecimal works correctly', () {
      // Arrange
      final cases = [
        // null / empty
        {'value': null, 'expected': isNull},
        {'value': '', 'expected': isNull},

        // invalid format
        {'value': 'abc', 'expected': isNotNull},
        {'value': '1..2', 'expected': isNotNull},

        // zero & negative
        {'value': '0', 'expected': isNotNull},
        {'value': '0.0', 'expected': isNotNull},
        {'value': '-1', 'expected': isNotNull},
        {'value': '-0.1', 'expected': isNotNull},

        // valid positives
        {'value': '1', 'expected': isNull},
        {'value': '.1', 'expected': isNull},
        {'value': '10.5', 'expected': isNull},

        // comma support
        {'value': '1,5', 'expected': isNull},
        {'value': ',01', 'expected': isNull},

        // tricky edge cases
        {'value': ' 1', 'expected': isNull},
        {'value': '1 ', 'expected': isNull},
      ];

      // Act
      final results = cases
          .map((c) => strictlyPositiveDecimal(l10n, c['value'] as String?))
          .toList();
      final expected = cases.map((c) => c['expected'] as Matcher).toList();

      // Assert
      expect(results, expected);
    });

    test('positiveDecimal works correctly', () {
      // Arrange
      final cases = [
        // null / empty
        {'value': null, 'expected': isNull},
        {'value': '', 'expected': isNull},

        // invalid format
        {'value': 'abc', 'expected': isNotNull},
        {'value': '1..2', 'expected': isNotNull},

        // negative
        {'value': '-1', 'expected': isNotNull},
        {'value': '-0.1', 'expected': isNotNull},

        // valid positives & zero
        {'value': '1', 'expected': isNull},
        {'value': '.1', 'expected': isNull},
        {'value': '10.5', 'expected': isNull},
        {'value': '0', 'expected': isNull},
        {'value': '0.0', 'expected': isNull},

        // comma support
        {'value': '1,5', 'expected': isNull},
        {'value': ',01', 'expected': isNull},

        // tricky edge cases
        {'value': ' 1', 'expected': isNull},
        {'value': '1 ', 'expected': isNull},
      ];

      // Act
      final results = cases
          .map((c) => positiveDecimal(l10n, c['value'] as String?))
          .toList();
      final expected = cases.map((c) => c['expected'] as Matcher).toList();

      // Assert
      expect(results, expected);
    });

    test('positiveInt works correctly', () {
      // Arrange
      final cases = [
        // null / empty
        {'value': null, 'expected': isNull},
        {'value': '', 'expected': isNull},

        // invalid format
        {'value': 'abc', 'expected': isNotNull},
        {'value': '1..2', 'expected': isNotNull},

        // negative & zero
        {'value': '-1', 'expected': isNotNull},
        {'value': '-0.1', 'expected': isNotNull},
        {'value': '0', 'expected': isNotNull},
        {'value': '0.0', 'expected': isNotNull},

        // decimals
        {'value': '.1', 'expected': isNotNull},
        {'value': '10.5', 'expected': isNotNull},

        // ints
        {'value': '1', 'expected': isNull},
        {'value': '4', 'expected': isNull},

        // tricky edge cases
        {'value': ' 1', 'expected': isNull},
        {'value': '1 ', 'expected': isNull},
      ];

      // Act
      final results =
          cases.map((c) => positiveInt(l10n, c['value'] as String?)).toList();
      final expected = cases.map((c) => c['expected'] as Matcher).toList();

      // Assert
      expect(results, expected);
    });

    test('requiredStrictlyPositiveDecimal works correctly', () {
      // Arrange
      final cases = [
        // null / empty
        {'value': null, 'expected': isNotNull},
        {'value': '', 'expected': isNotNull},

        // invalid format
        {'value': 'abc', 'expected': isNotNull},
        {'value': '1..2', 'expected': isNotNull},

        // zero & negative
        {'value': '0', 'expected': isNotNull},
        {'value': '0.0', 'expected': isNotNull},
        {'value': '-1', 'expected': isNotNull},
        {'value': '-0.1', 'expected': isNotNull},

        // valid positives
        {'value': '1', 'expected': isNull},
        {'value': '.1', 'expected': isNull},
        {'value': '10.5', 'expected': isNull},

        // comma support
        {'value': '1,5', 'expected': isNull},
        {'value': ',01', 'expected': isNull},

        // tricky edge cases
        {'value': ' 1', 'expected': isNull},
        {'value': '1 ', 'expected': isNull},
      ];

      // Act
      final results = cases
          .map((c) =>
              requiredStrictlyPositiveDecimal(l10n, c['value'] as String?))
          .toList();
      final expected = cases.map((c) => c['expected'] as Matcher).toList();

      // Assert
      expect(results, expected);
    });

    test('requiredPositiveDecimal works correctly', () {
      // Arrange
      final cases = [
        // null / empty
        {'value': null, 'expected': isNotNull},
        {'value': '', 'expected': isNotNull},

        // invalid format
        {'value': 'abc', 'expected': isNotNull},
        {'value': '1..2', 'expected': isNotNull},

        // negative
        {'value': '-1', 'expected': isNotNull},
        {'value': '-0.1', 'expected': isNotNull},

        // valid positives & zero
        {'value': '1', 'expected': isNull},
        {'value': '.1', 'expected': isNull},
        {'value': '10.5', 'expected': isNull},
        {'value': '0', 'expected': isNull},
        {'value': '0.0', 'expected': isNull},

        // comma support
        {'value': '1,5', 'expected': isNull},
        {'value': ',01', 'expected': isNull},

        // tricky edge cases
        {'value': ' 1', 'expected': isNull},
        {'value': '1 ', 'expected': isNull},
      ];

      // Act
      final results = cases
          .map((c) => requiredPositiveDecimal(l10n, c['value'] as String?))
          .toList();
      final expected = cases.map((c) => c['expected'] as Matcher).toList();

      // Assert
      expect(results, expected);
    });

    test('requiredPositiveInt works correctly', () {
      // Arrange
      final cases = [
        // null / empty
        {'value': null, 'expected': isNotNull},
        {'value': '', 'expected': isNotNull},

        // invalid format
        {'value': 'abc', 'expected': isNotNull},
        {'value': '1..2', 'expected': isNotNull},

        // negative & zero
        {'value': '-1', 'expected': isNotNull},
        {'value': '-0.1', 'expected': isNotNull},
        {'value': '0', 'expected': isNotNull},
        {'value': '0.0', 'expected': isNotNull},

        // decimals
        {'value': '.1', 'expected': isNotNull},
        {'value': '10.5', 'expected': isNotNull},

        // ints
        {'value': '1', 'expected': isNull},
        {'value': '4', 'expected': isNull},

        // tricky edge cases
        {'value': ' 1', 'expected': isNull},
        {'value': '1 ', 'expected': isNull},
      ];

      // Act
      final results = cases
          .map((c) => requiredPositiveInt(l10n, c['value'] as String?))
          .toList();
      final expected = cases.map((c) => c['expected'] as Matcher).toList();

      // Assert
      expect(results, expected);
    });
  });
}
