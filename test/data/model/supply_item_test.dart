import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/data/model/supply_item.dart';

void main() {
  group('SupplyItem model', () {
    test('toMap and fromMap should preserve values', () {
      final item = SupplyItem(
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

      final map = item.toMap();
      final fromMap = SupplyItem.fromMap(map);

      expect(
        fromMap,
        isA<SupplyItem>()
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

      final results = testCases.map((testCase) {
        final item = SupplyItem(
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

      expect(
        results,
        testCases.map((e) => e['expected'] as bool).toList(),
        reason: 'isValid results do not match expected values',
      );
    });

    group('validators', () {
      test('validateTotalAmount', () {
        expect(
          [
            SupplyItem.validateTotalAmount(null),
            SupplyItem.validateTotalAmount(''),
            SupplyItem.validateTotalAmount('0'),
            SupplyItem.validateTotalAmount('-5'),
            SupplyItem.validateTotalAmount('10'),
          ],
          [
            isNotNull,
            isNotNull,
            isNotNull,
            isNotNull,
            isNull,
          ],
        );
      });

      test('validateName', () {
        expect(
          [
            SupplyItem.validateName(null),
            SupplyItem.validateName(''),
            SupplyItem.validateName('Something'),
          ],
          [
            isNotNull,
            isNotNull,
            isNull,
          ],
        );
      });

      test('validateUsedAmount', () {
        const total = '100';
        final validator = SupplyItem.usedAmountValidator(total);

        final cases = [
          {'value': null, 'expected': isNotNull},
          {'value': '', 'expected': isNotNull},
          {'value': '-1', 'expected': isNotNull},
          {'value': '200', 'expected': isNotNull},
          {'value': '50', 'expected': isNull},
        ];

        final results =
            cases.map((c) => validator(c['value'] as String?)).toList();

        final expected = cases.map((c) => c['expected'] as Matcher).toList();

        expect(results, expected);
      });

      test('validateConcentration', () {
        expect(
          [
            SupplyItem.validateConcentration(null),
            SupplyItem.validateConcentration(''),
            SupplyItem.validateConcentration('0'),
            SupplyItem.validateConcentration('-1'),
            SupplyItem.validateConcentration('2.5'),
          ],
          [
            isNotNull,
            isNotNull,
            isNotNull,
            isNotNull,
            isNull,
          ],
        );
      });

      test('canUseDose should return true if within totalDose', () {
        final item = SupplyItem(
          name: 'Dose Test',
          totalDose: Decimal.fromInt(100),
          concentration: Decimal.one,
          usedDose: Decimal.fromInt(20),
          molecule: KnownMolecules.progesterone,
          administrationRoute: AdministrationRoute.suppository,
        );
        expect(
          [
            item.canUseDose(Decimal.fromInt(80)),
            item.canUseDose(Decimal.fromInt(81))
          ],
          [true, false],
        );
      });

      test('remainingDose returns correct value', () {
        final item = SupplyItem(
          name: 'Remaining',
          totalDose: Decimal.fromInt(100),
          usedDose: Decimal.fromInt(30),
          concentration: Decimal.one,
          molecule: KnownMolecules.progesterone,
          administrationRoute: AdministrationRoute.suppository,
        );
        expect(item.remainingDose, Decimal.fromInt(70));
      });
    });
  });
}
