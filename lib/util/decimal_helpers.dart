import 'package:decimal/decimal.dart';

Decimal parseDecimal(String text) =>
    Decimal.parse(text.trim().replaceAll(',', '.'));

Decimal? parseOptionalDecimal(String decimalString) {
  final decimal = decimalString.trim();
  if (decimal.isEmpty) return null;

  return parseDecimal(decimal);
}
