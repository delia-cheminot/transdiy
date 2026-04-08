import 'package:decimal/decimal.dart';

String _sanitize(String? input) => input?.trim().replaceAll(',', '.') ?? '';

extension EmptyString on String? {
  bool get isEmpty => _sanitize(this).isEmpty;
}

// TODO this can be done on String only as text controllers are never null
extension DecimalParsing on String? {
  bool get isDecimal => toDecimalOrNull != null;

  Decimal get toDecimalOrZero {
    return Decimal.tryParse(_sanitize(this)) ?? Decimal.zero;
  }

  Decimal? get toDecimalOrNull {
    return Decimal.tryParse(_sanitize(this));
  }

  // TODO test
  Decimal get toDecimal => Decimal.parse(_sanitize(this));
}

extension DateTimeParsing on String? {
  // TODO test
  DateTime? get toDateTimeOrNull => DateTime.tryParse(_sanitize(this));

  DateTime get toDateTime => DateTime.parse(this!);
}

extension IntParsing on String? {
  int get intOrZero => int.tryParse(_sanitize(this)) ?? 0;

  int get toInt => int.parse(_sanitize(this));
}
