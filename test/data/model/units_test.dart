import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/units.dart';

void main() {
  group('UnitValue', () {
    test('estradiol converts same does not change value', () {
      final value = UnitValue(200.toDecimal(), EstradiolUnit.pg_mL);
      final converted = value.inUnit(EstradiolUnit.pg_mL);

      expect(converted, 200.0);
    });

    test('estradiol converts from pg/mL to pmol/L', () {
      final value = UnitValue(200.toDecimal(), EstradiolUnit.pg_mL);
      final converted = value.inUnit(EstradiolUnit.pmol_L);

      expect(converted, moreOrLessEquals(734.20, epsilon: 0.01));
    });

    test('estradiol converts from pmol/L to pg/mL', () {
      final value = UnitValue(700.toDecimal(), EstradiolUnit.pmol_L);
      final converted = value.inUnit(EstradiolUnit.pg_mL);

      expect(converted, moreOrLessEquals(190.68, epsilon: 0.01));
    });

    test('testosterone converts same does not change value', () {
      final value = UnitValue(250.toDecimal(), TestosteroneUnit.ng_dL);
      final converted = value.inUnit(TestosteroneUnit.ng_dL);

      expect(converted, 250.0);
    });

    test('testosterone converts from ng/dL to nmol/L', () {
      final value = UnitValue(250.toDecimal(), TestosteroneUnit.ng_dL);
      final converted = value.inUnit(TestosteroneUnit.nmol_L);

      expect(converted, moreOrLessEquals(8.67, epsilon: 0.01));
    });

    test('testosterone converts from nmol/L to ng/dL', () {
      final value = UnitValue(8.toDecimal(), TestosteroneUnit.nmol_L);
      final converted = value.inUnit(TestosteroneUnit.ng_dL);

      expect(converted, moreOrLessEquals(230.72, epsilon: 0.01));
    });
  });
}
