import 'package:decimal/decimal.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/date.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/util/string_parsing.dart';

String? strictlyPositiveDecimal(String? value) {
  if (value.isEmpty) return null;

  return value.toDecimalOrZero <= Decimal.zero
      ? 'Must be a positive number'
      : null;
}

String? positiveDecimal(String? value) {
  if (value.isEmpty) return null;

  return (!value.isDecimal || value.toDecimalOrZero < Decimal.zero)
      ? 'Must be a positive number'
      : null;
}

String? positiveInt(String? value) {
  if (value.isEmpty) return null;

  return value.intOrZero <= 0 ? 'Must be a positive number' : null;
}

String? requiredValue<T>(T? value) =>
    value == null ? 'Required field' : null;

String? requiredString(String? value) =>
    value.isEmpty ? 'Required field' : null;

String? requiredDateTime(DateTime? value) =>
    value == null ? 'Required field' : null;

String? requiredDate(Date? value) => value == null ? 'Required field' : null;

String? requiredStrictlyPositiveDecimal(String? value) =>
    requiredString(value) ?? strictlyPositiveDecimal(value);

String? requiredPositiveDecimal(String? value) =>
    requiredString(value) ?? positiveDecimal(value);

String? requiredPositiveInt(String? value) =>
    requiredString(value) ?? positiveInt(value);

String? requiredMolecule(Molecule? value) =>
    value == null ? 'Required field' : null;

String? requiredAdministrationRoute(AdministrationRoute? value) =>
    value == null ? 'Required field' : null;
