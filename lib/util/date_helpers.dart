DateTime normalizeDate(DateTime date) {
  return DateTime.utc(date.year, date.month, date.day);
}

DateTime normalizedToday() {
  final now = DateTime.now();
  return normalizeDate(now);
}

int daysBetweenDate(DateTime date, {DateTime? origin}) {
  final reference = origin ?? DateTime.now();
  return normalizeDate(date).difference(normalizeDate(reference)).inDays.abs();
}

bool isSameDayAs(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
