class Date {
  final DateTime value;

  Date(this.value) : assert(value.isUtc, 'Date value must be UTC');

  Date.fromDateTime(DateTime input) : value = _logicalDay(input);

  Date.today() : value = _logicalDay(DateTime.now());

  Date.fromString(String input)
      : assert(DateTime.parse(input).isUtc,
            'Date string must be UTC (e.g. "2024-01-01T00:00:00Z")'),
        value = DateTime.parse(input);

  int get year => value.year;
  int get month => value.month;
  int get day => value.day;
  bool get isToday => this == Date.today();
  bool get isBeforeToday => isBefore(Date.today());
  bool get isAfterToday => isAfter(Date.today());
  int get daysAwayFromToday => differenceInDays(Date.today()).abs();

  int differenceInDays(Date other) =>
      value.difference(other.value).inDays.abs();

  bool isSameDayAs(Date other) =>
      value.year == other.value.year &&
      value.month == other.value.month &&
      value.day == other.value.day;

  bool isBefore(Date other) => value.isBefore(other.value);

  bool isAfter(Date other) => value.isAfter(other.value);

  Date add(Duration duration) => Date(value.add(duration));

  Date subtract(Duration duration) {
    return Date(value.subtract(duration));
  }

  DateTime toUtcDateTime() => value;

  DateTime toLocalDateTime() => value.toLocal();

  @override
  String toString() {
    return value.toIso8601String();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Date && isSameDayAs(other);
  }

  @override
  int get hashCode => value.hashCode;

  // Applies the 4am rule: times before 4am belong to the previous day.
  static DateTime _logicalDay(DateTime input) {
    final dayDifference = input.hour < 4 ? 1 : 0;
    return DateTime.utc(input.year, input.month, input.day - dayDifference);
  }
}
