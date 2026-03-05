import 'package:decimal/decimal.dart';

String? requiredString(String? value) =>
    value == null || value.isEmpty ? 'Required field' : null;

String? requiredDate(DateTime? value) =>
    value == null ? 'Required field' : null;

String? positiveDecimal(String? value) {
  final parsed = Decimal.tryParse(value?.replaceAll(',', '.') ?? '');
  return parsed == null || parsed <= Decimal.zero
      ? 'Must be a positive number'
      : null;
}

String? requiredPositiveDecimal(String? value) =>
    requiredString(value) ?? positiveDecimal(value);

String? positiveInt(String? value) {
  final parsed = int.tryParse(value ?? '');
  return parsed == null || parsed <= 0 ? 'Must be a positive number' : null;
}

String? requiredPositiveInt(String? value) =>
    requiredString(value) ?? positiveInt(value);
