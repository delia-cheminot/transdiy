import 'package:decimal/decimal.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/molecule.dart';

bool isEmptyString(String? value) => value == null || value.trim().isEmpty;

String? strictlyPositiveDecimal(String? value) {
  if (isEmptyString(value)) return null;

  final parsed = Decimal.tryParse(value!.trim().replaceAll(',', '.'));
  return parsed == null || parsed <= Decimal.zero
      ? 'Must be a positive number'
      : null;
}

String? positiveDecimal(String? value) {
  if (isEmptyString(value)) return null;

  final parsed = Decimal.tryParse(value!.trim().replaceAll(',', '.'));
  return parsed == null || parsed < Decimal.zero
      ? 'Must be a positive number'
      : null;
}

String? positiveInt(String? value) {
  if (isEmptyString(value)) return null;

  final parsed = int.tryParse(value!.trim());
  return parsed == null || parsed <= 0 ? 'Must be a positive number' : null;
}

String? requiredString(String? value) =>
    isEmptyString(value) ? 'Required field' : null;

String? requiredDate(DateTime? value) =>
    value == null ? 'Required field' : null;

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
