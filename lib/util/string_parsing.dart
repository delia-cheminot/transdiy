import 'package:decimal/decimal.dart';

String _sanitize(String? input) => input?.trim().replaceAll(',', '.') ?? '';

extension EmptyString on String? {
  bool get isEmpty => _sanitize(this).isEmpty;
}

extension DecimalParsing on String? {
  bool get isDecimal => toDecimalOrNull != null;

  Decimal get toDecimalOrZero {
    return Decimal.tryParse(_sanitize(this)) ?? Decimal.zero;
  }

  Decimal? get toDecimalOrNull {
    return Decimal.tryParse(_sanitize(this));
  }

  Decimal get toDecimal => Decimal.parse(_sanitize(this));
}

extension DateTimeParsing on String? {
  DateTime? get toDateTimeOrNull => DateTime.tryParse(_sanitize(this));

  DateTime get toDateTime => DateTime.parse(this!);
}

extension IntParsing on String? {
  int get toIntOrZero => int.tryParse(_sanitize(this)) ?? 0;

  int get toInt => int.parse(_sanitize(this));
}
