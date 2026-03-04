import 'package:decimal/decimal.dart';

Decimal parseDecimal(String text) {
  final sanitizedText = text.replaceAll(',', '.');
  return Decimal.parse(sanitizedText);
}

