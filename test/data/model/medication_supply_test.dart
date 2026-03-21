import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/data/model/medication_supply.dart';

void main() {
  group('MedicationSupply model', () {
    test('toMap and fromMap should preserve values', () {
      // Arrange
      final item = MedicationSupply(
        id: 1,
        name: 'Test Item',
        totalDose: Decimal.parse('100'),
        usedDose: Decimal.parse('20'),
        concentration: Decimal.parse('10'),
        quantity: 2,
        molecule: KnownMolecules.estradiol,
        administrationRoute: AdministrationRoute.injection,
        ester: Ester.undecylate,
      );

      // Act
      final map = item.toMap();
      final fromMap = MedicationSupply.fromMap(map);

      // Assert
      expect(
        fromMap,
        isA<MedicationSupply>()
            .having((s) => s.id, 'id', item.id)
            .having((s) => s.name, 'name', item.name)
            .having((s) => s.totalDose, 'totalDose', item.totalDose)
            .having((s) => s.usedDose, 'usedDose', item.usedDose)
            .having((s) => s.concentration, 'concentration', item.concentration)
            .having((s) => s.quantity, 'quantity', item.quantity)
            .having((s) => s.molecule, 'molecule', item.molecule)
            .having((s) => s.administrationRoute, 'administrationRoute',
                item.administrationRoute)
            .having((s) => s.ester, 'ester', item.ester),
      );
    });

    test('isValid returns correct values for multiple cases', () {
      // Arrange
      final testCases = [
        {
          'name': 'Valid Item',
          'totalDose': Decimal.fromInt(100),
          'concentration': Decimal.fromInt(10),
          'usedDose': Decimal.fromInt(50),
          'quantity': 1,
          'molecule': KnownMolecules.estradiol,
          'administrationRoute': AdministrationRoute.patch,
          'expected': true,
        },
        {
          'name': '',
          'totalDose': Decimal.zero,
          'concentration': Decimal.zero,
          'usedDose': Decimal.fromInt(-1),
          'quantity': null,
          'molecule': KnownMolecules.estradiol,
          'administrationRoute': AdministrationRoute.patch,
          'expected': false,
        },
        {
          'name': 'No Dose',
          'totalDose': Decimal.zero,
          'concentration': Decimal.one,
          'usedDose': Decimal.zero,
          'quantity': null,
          'molecule': KnownMolecules.estradiol,
          'administrationRoute': AdministrationRoute.patch,
          'expected': false,
        },
        {
          'name': 'Negative Used',
          'totalDose': Decimal.fromInt(10),
          'concentration': Decimal.one,
          'usedDose': Decimal.fromInt(-5),
          'quantity': null,
          'molecule': KnownMolecules.estradiol,
          'administrationRoute': AdministrationRoute.patch,
          'expected': false,
        },
        {
          'name': 'Dose Per Unit Zero',
          'totalDose': Decimal.fromInt(10),
          'concentration': Decimal.zero,
          'usedDose': Decimal.zero,
          'quantity': null,
          'molecule': KnownMolecules.estradiol,
          'administrationRoute': AdministrationRoute.patch,
          'expected': false,
        },
        {
          'name': 'Valid with quantity',
          'totalDose': Decimal.fromInt(20),
          'concentration': Decimal.fromInt(2),
          'usedDose': Decimal.fromInt(4),
          'quantity': 2,
          'molecule': KnownMolecules.estradiol,
          'administrationRoute': AdministrationRoute.patch,
          'expected': true,
        },
      ];

      // Act
      final results = testCases.map((testCase) {
        final item = MedicationSupply(
          name: testCase['name'] as String,
          totalDose: testCase['totalDose'] as Decimal,
          concentration: testCase['concentration'] as Decimal,
          usedDose: testCase['usedDose'] as Decimal,
          quantity: testCase['quantity'] as int? ?? 0,
          molecule: testCase['molecule'] as Molecule,
          administrationRoute:
              testCase['administrationRoute'] as AdministrationRoute,
        );
        return item.isValid();
      }).toList();

      // Assert
      expect(
        results,
        testCases.map((e) => e['expected'] as bool).toList(),
        reason: 'isValid results do not match expected values',
      );
    });

    group('validators', () {
      test('validateTotalAmount', () {
        // Arrange
        final cases = [
          {'value': null, 'expected': isNotNull},
          {'value': '', 'expected': isNotNull},
          {'value': '0', 'expected': isNotNull},
          {'value': '-5', 'expected': isNotNull},
          {'value': '10', 'expected': isNull},
        ];

        // Act
        final results = cases
            .map((c) => MedicationSupply.validateTotalAmount(c['value'] as String?))
            .toList();
        final expected = cases.map((c) => c['expected'] as Matcher).toList();

        // Assert
        expect(results, expected);
      });

      test('validateName', () {
        // Arrange
        final cases = [
          {'value': null, 'expected': isNotNull},
          {'value': '', 'expected': isNotNull},
          {'value': 'Something', 'expected': isNull},
        ];

        // Act
        final results = cases
            .map((c) => MedicationSupply.validateName(c['value'] as String?))
            .toList();
        final expected = cases.map((c) => c['expected'] as Matcher).toList();

        // Assert
        expect(results, expected);
      });

      test('validateUsedAmount', () {
        // Arrange
        const total = '100';
        final validator = MedicationSupply.usedAmountValidator(total);
        final cases = [
          {'value': null, 'expected': isNotNull},
          {'value': '', 'expected': isNotNull},
          {'value': '-1', 'expected': isNotNull},
          {'value': '200', 'expected': isNotNull},
          {'value': '50', 'expected': isNull},
        ];

        // Act
        final results =
            cases.map((c) => validator(c['value'] as String?)).toList();
        final expected = cases.map((c) => c['expected'] as Matcher).toList();

        expect(results, expected);
      });

      test('validateConcentration', () {
        // Arrange
        final cases = [
          {'value': null, 'expected': isNotNull},
          {'value': '', 'expected': isNotNull},
          {'value': '0', 'expected': isNotNull},
          {'value': '-1', 'expected': isNotNull},
          {'value': '2.5', 'expected': isNull},
        ];

        // Act
        final results = cases
            .map((c) => MedicationSupply.validateConcentration(c['value'] as String?))
            .toList();
        final expected = cases.map((c) => c['expected'] as Matcher).toList();

        // Assert
        expect(results, expected);
      });

      test('validateMolecule works correctly', () {
        // Arrange
        final cases = [
          {'value': null, 'expected': isNotNull},
          {'value': KnownMolecules.decapeptyl, 'expected': isNull},
        ];

        // Act
        final results = cases
            .map((c) => MedicationSupply.validateMolecule(c['value'] as Molecule?))
            .toList();
        final expected = cases.map((c) => c['expected'] as Matcher).toList();

        // Assert
        expect(results, expected);
      });

      test('validateAdministrationRoute works correctly', () {
        // Arrange
        final cases = [
          {'value': null, 'expected': isNotNull},
          {'value': AdministrationRoute.implant, 'expected': isNull},
        ];

        // Act
        final results = cases
            .map((c) => MedicationSupply.validateAdministrationRoute(
                c['value'] as AdministrationRoute?))
            .toList();
        final expected = cases.map((c) => c['expected'] as Matcher).toList();

        // Assert
        expect(results, expected);
      });

      test('validateEster works correctly', () {
        // Arrange
        final cases = [
          {
            'molecule': null,
            'route': null,
            'value': null,
            'expected': isNull,
          },
          {
            'molecule': KnownMolecules.estradiol,
            'route': AdministrationRoute.injection,
            'value': null,
            'expected': isNotNull,
          },
          {
            'molecule': KnownMolecules.estradiol,
            'route': AdministrationRoute.injection,
            'value': Ester.enanthate,
            'expected': isNull,
          },
          {
            'molecule': KnownMolecules.estradiol,
            'route': AdministrationRoute.oral,
            'value': Ester.enanthate,
            'expected': isNull,
          },
          {
            'molecule': KnownMolecules.estradiol,
            'route': AdministrationRoute.oral,
            'value': null,
            'expected': isNull,
          },
        ];

        // Act
        final results = cases.map((c) {
          final validator = MedicationSupply.esterValidator(
            c['molecule'] as Molecule?,
            c['route'] as AdministrationRoute?,
          );
          return validator(c['value'] as Ester?);
        }).toList();
        final expected = cases.map((c) => c['expected'] as Matcher).toList();

        // Assert
        expect(results, expected);
      });
    });

    test('canUseDose should return true if within totalDose', () {
      // Arrange
      final item = MedicationSupply(
        name: 'Dose Test',
        totalDose: Decimal.fromInt(100),
        concentration: Decimal.one,
        usedDose: Decimal.fromInt(20),
        molecule: KnownMolecules.progesterone,
        administrationRoute: AdministrationRoute.suppository,
      );

      // Act
      final cases = [
        {'value': item.canUseDose(Decimal.fromInt(80)), 'expected': true},
        {'value': item.canUseDose(Decimal.fromInt(81)), 'expected': false}
      ];

      // Assert
      expect(cases.map((c) => c['value']), cases.map((c) => c['expected']));
    });

    test('remainingDose returns correct value', () {
      // Arrange
      final item = MedicationSupply(
        name: 'Remaining',
        totalDose: Decimal.fromInt(100),
        usedDose: Decimal.fromInt(30),
        concentration: Decimal.one,
        molecule: KnownMolecules.progesterone,
        administrationRoute: AdministrationRoute.suppository,
      );

      // Act
      final remaining = item.remainingDose;

      // Assert
      expect(remaining, Decimal.fromInt(70));
    });

    group('Dose/Amount calculations', () {
      test('getAmount returns correct amount', () {
        // Arrange
        final item = MedicationSupply(
          name: 'Calc Test',
          totalDose: Decimal.fromInt(100),
          concentration: Decimal.parse('2.5'),
          usedDose: Decimal.zero,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.patch,
        );

        final doses = [
          {'dose': Decimal.fromInt(10), 'expected': Decimal.parse('4')},
          {'dose': Decimal.zero, 'expected': Decimal.zero},
        ];

        // Act & Assert
        for (final d in doses) {
          expect(
              item.getAmount(d['dose'] as Decimal), d['expected'] as Decimal);
        }
      });

      test('getDose returns correct dose', () {
        // Arrange
        final item = MedicationSupply(
          name: 'Calc Test',
          totalDose: Decimal.fromInt(100),
          concentration: Decimal.parse('2.5'),
          usedDose: Decimal.zero,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.patch,
        );

        final amounts = [
          {'amount': Decimal.parse('4'), 'expected': Decimal.fromInt(10)},
          {'amount': Decimal.zero, 'expected': Decimal.zero},
        ];

        // Act & Assert
        for (final a in amounts) {
          expect(
              item.getDose(a['amount'] as Decimal), a['expected'] as Decimal);
        }
      });
    });
  });
}
