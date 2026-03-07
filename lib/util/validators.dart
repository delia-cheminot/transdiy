import 'package:decimal/decimal.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/molecule.dart';

String? requiredString(String? value) =>
    value == null || value.isEmpty ? 'Required field' : null;

String? requiredDate(DateTime? value) =>
    value == null ? 'Required field' : null;

String? strictlyPositiveDecimal(String? value) {
  final parsed = Decimal.tryParse(value?.replaceAll(',', '.') ?? '');
  return parsed == null || parsed <= Decimal.zero
      ? 'Must be a positive number'
      : null;
}

String? positiveDecimal(String? value) {
  final parsed = Decimal.tryParse(value?.replaceAll(',', '.') ?? '');
  return parsed == null || parsed < Decimal.zero
      ? 'Must be a positive number'
      : null;
}

String? requiredStrictlyPositiveDecimal(String? value) =>
    requiredString(value) ?? strictlyPositiveDecimal(value);

String? requiredPositiveDecimal(String? value) =>
    requiredString(value) ?? positiveDecimal(value);

String? positiveInt(String? value) {
  final parsed = int.tryParse(value ?? '');
  return parsed == null || parsed <= 0 ? 'Must be a positive number' : null;
}

String? requiredPositiveInt(String? value) =>
    requiredString(value) ?? positiveInt(value);

String? requiredMolecule(Molecule? value) =>
    value == null ? 'Required field' : null;

String? requiredAdministrationRoute(AdministrationRoute? value) =>
    value == null ? 'Required field' : null;
