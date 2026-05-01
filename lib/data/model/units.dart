// ignore_for_file: constant_identifier_names
import 'package:decimal/decimal.dart';

abstract interface class Unit<T> implements Enum {
  final String name;

  Unit(this.name);

  num convert(num value, T into);
}

enum EstradiolUnit implements Unit<EstradiolUnit> {
  pg_mL("pg/mL"),
  pmol_L("pmol/L");

  @override
  final String name;

  const EstradiolUnit(this.name);

  @override
  num convert(num value, EstradiolUnit into) {
    if (into == this) return value;
    return switch (into) {
      EstradiolUnit.pg_mL => value / 3.671,
      EstradiolUnit.pmol_L => value * 3.671
    };
  }

  @override
  String toString() {
    return name;
  }

  factory EstradiolUnit.parse(String value) {
    return EstradiolUnit.values.firstWhere((unit) => unit.name == value);
  }
}

enum TestosteroneUnit implements Unit<TestosteroneUnit> {
  ng_dL("ng/dL"),
  nmol_L("nmol/L");

  @override
  final String name;

  const TestosteroneUnit(this.name);

  factory TestosteroneUnit.parse(String value) {
    return TestosteroneUnit.values.firstWhere((unit) => unit.name == value);
  }

  @override
  num convert(num value, TestosteroneUnit into) {
    if (into == this) return value;
    return switch (into) {
      TestosteroneUnit.ng_dL => value * 28.84,
      TestosteroneUnit.nmol_L => value / 28.84
    };
  }

  @override
  String toString() {
    return name;
  }
}

enum Units {
  pg_mL_ng_dL(
      estradiol: EstradiolUnit.pg_mL, testosterone: TestosteroneUnit.ng_dL),
  pmol_L_nmol_L(
      estradiol: EstradiolUnit.pmol_L, testosterone: TestosteroneUnit.nmol_L);

  final EstradiolUnit estradiol;
  final TestosteroneUnit testosterone;

  const Units({required this.estradiol, required this.testosterone});

  String get name {
    return "${estradiol.name} & ${testosterone.name}";
  }

  @override
  String toString() {
    return name;
  }
}

class UnitValue<U extends Unit> {
  final Decimal value;
  final U unit;

  UnitValue(this.value, this.unit);

  double inUnit(U unit) {
    return this.unit.convert(value.toDouble(), unit).toDouble();
  }

  @override
  String toString() {
    return "$value $unit";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitValue &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          unit == other.unit;

  @override
  int get hashCode => Object.hash(value, unit);
}
