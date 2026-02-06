DateTime normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

DateTime normalizedToday() {
  final now = DateTime.now();
  return normalizeDate(now);
}
