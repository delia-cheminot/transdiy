import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transdiy/data/model/supply_item.dart';

void main() {
  group('SupplyItem model', () {
    test('toMap and fromMap should preserve values', () {
      final item = SupplyItem(
        id: 1,
        name: 'Test Item',
        totalDose: Decimal.parse('100'),
        usedDose: Decimal.parse('20'),
        dosePerUnit: Decimal.parse('10'),
        quantity: 2,
      );

      final map = item.toMap();
      final fromMap = SupplyItem.fromMap(map);

      expect(
        [
          fromMap.id,
          fromMap.name,
          fromMap.totalDose,
          fromMap.usedDose,
          fromMap.dosePerUnit,
          fromMap.quantity,
        ],
        [
          item.id,
          item.name,
          item.totalDose,
          item.usedDose,
          item.dosePerUnit,
          item.quantity,
        ],
      );
    });

    test('copy creates an identical object', () {
      final item = SupplyItem(
        id: 2,
        name: 'Copy Test',
        totalDose: Decimal.fromInt(50),
        dosePerUnit: Decimal.fromInt(5),
        usedDose: Decimal.fromInt(10),
        quantity: 1,
      );

      final copy = item.copy();
      expect(
        [
          copy.id,
          copy.name,
          copy.totalDose,
          copy.usedDose,
          copy.dosePerUnit,
          copy.quantity,
        ],
        [
          item.id,
          item.name,
          item.totalDose,
          item.usedDose,
          item.dosePerUnit,
          item.quantity,
        ],
      );
    });

    test('isValid returns correct values for multiple cases', () {
      final testCases = [
        {
          'name': 'Valid Item',
          'totalDose': Decimal.fromInt(100),
          'dosePerUnit': Decimal.fromInt(10),
          'usedDose': Decimal.fromInt(50),
          'quantity': 1,
          'expected': true,
        },
        {
          'name': '',
          'totalDose': Decimal.zero,
          'dosePerUnit': Decimal.zero,
          'usedDose': Decimal.fromInt(-1),
          'quantity': null,
          'expected': false,
        },
        {
          'name': 'No Dose',
          'totalDose': Decimal.zero,
          'dosePerUnit': Decimal.one,
          'usedDose': Decimal.zero,
          'quantity': null,
          'expected': false,
        },
        {
          'name': 'Negative Used',
          'totalDose': Decimal.fromInt(10),
          'dosePerUnit': Decimal.one,
          'usedDose': Decimal.fromInt(-5),
          'quantity': null,
          'expected': false,
        },
        {
          'name': 'Dose Per Unit Zero',
          'totalDose': Decimal.fromInt(10),
          'dosePerUnit': Decimal.zero,
          'usedDose': Decimal.zero,
          'quantity': null,
          'expected': false,
        },
        {
          'name': 'Valid with quantity',
          'totalDose': Decimal.fromInt(20),
          'dosePerUnit': Decimal.fromInt(2),
          'usedDose': Decimal.fromInt(4),
          'quantity': 2,
          'expected': true,
        },
      ];

      final results = testCases.map((testCase) {
        final item = SupplyItem(
          name: testCase['name'] as String,
          totalDose: testCase['totalDose'] as Decimal,
          dosePerUnit: testCase['dosePerUnit'] as Decimal,
          usedDose: testCase['usedDose'] as Decimal,
          quantity: testCase['quantity'] as int? ?? 0,
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
        expect(
          [
            SupplyItem.validateUsedAmount(null, '100'),
            SupplyItem.validateUsedAmount('', '100'),
            SupplyItem.validateUsedAmount('-1', '100'),
            SupplyItem.validateUsedAmount('50', 'invalid'),
            SupplyItem.validateUsedAmount('200', '100'),
            SupplyItem.validateUsedAmount('50', '100'),
          ],
          [
            isNotNull,
            isNotNull,
            isNotNull,
            isNotNull,
            isNotNull,
            isNull,
          ],
        );
      });

      test('validateDosePerUnit', () {
        expect(
          [
            SupplyItem.validateDosePerUnit(null),
            SupplyItem.validateDosePerUnit(''),
            SupplyItem.validateDosePerUnit('0'),
            SupplyItem.validateDosePerUnit('-1'),
            SupplyItem.validateDosePerUnit('2.5'),
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
          dosePerUnit: Decimal.one,
          usedDose: Decimal.fromInt(20),
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
          dosePerUnit: Decimal.one,
        );
        expect(item.remainingDose, Decimal.fromInt(70));
      });
    });
  });
}
