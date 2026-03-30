import 'package:timezone/timezone.dart';

class Date {
  final DateTime value;

  factory Date() => Date.today();

  Date.fromTZ(TZDateTime input) : value = _logicalDay(input);

  Date.fromDateTime(DateTime input) : value = _logicalDay(input);

  Date.today() : value = _logicalDay(DateTime.now());

  Date.fromString(String input) : value = DateTime.parse(input);

  bool get isToday => this == Date.today();

  int get daysAwayFromToday => differenceInDays(Date.today());

  int differenceInDays(Date other) =>
      value.difference(other.value).inDays.abs();

  @override
  String toString() {
    return value.toIso8601String();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Date && value == other.value;
  }

  @override
  int get hashCode => value.hashCode;

  // Applies the 4am rule: times before 4am belong to the previous day.
  static DateTime _logicalDay(DateTime input) {
    final dayDifference = input.hour < 4 ? 1 : 0;
    return DateTime.utc(input.year, input.month, input.day - dayDifference);
  }
}
