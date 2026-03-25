import 'package:decimal/decimal.dart';

extension EmptyString on String? {
  String get _trimmedString => this?.trim().replaceAll(',', '.') ?? '';

  bool get isEmpty => _trimmedString.isEmpty;
}

// TODO this can be done on String only as text controllers are never null
extension DecimalParsing on String? {
  Decimal get toDecimalOrZero =>
      Decimal.tryParse(_trimmedString) ?? Decimal.zero;

  Decimal? get toDecimalOrNull => Decimal.tryParse(_trimmedString);

  // TODO test
  Decimal get toDecimal => Decimal.parse(_trimmedString);
}

extension DateTimeParsing on String? {
  // TODO test
  DateTime? get toDateTimeOrNull => DateTime.tryParse(_trimmedString);

  DateTime get toDateTime => DateTime.parse(this!);
}

extension IntParsing on String? {
  int get intOrZero => int.tryParse(_trimmedString) ?? 0;

  int get toInt => int.parse(_trimmedString);
}
