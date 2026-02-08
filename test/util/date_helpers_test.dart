import 'package:flutter_test/flutter_test.dart';
import 'package:mona/util/date_helpers.dart';

void main() {
  group('date_helpers', () {
    group('normalizeDate', () {
      test('removes time from DateTime', () {
        final date = DateTime(2026, 2, 8, 15, 30, 45);
        final normalized = normalizeDate(date);

        expect(normalized.year, equals(2026));
        expect(normalized.month, equals(2));
        expect(normalized.day, equals(8));
        expect(normalized.hour, equals(0));
        expect(normalized.minute, equals(0));
        expect(normalized.second, equals(0));
        expect(normalized.millisecond, equals(0));
      });

      test('returns same date for already normalized DateTime', () {
        final date = DateTime(2026, 2, 8);
        final normalized = normalizeDate(date);

        expect(normalized, equals(date));
      });
    });

    group('normalizedToday', () {
      test('returns today without time', () {
        final today = normalizedToday();
        final now = DateTime.now();

        expect(today.year, equals(now.year));
        expect(today.month, equals(now.month));
        expect(today.day, equals(now.day));
        expect(today.hour, equals(0));
        expect(today.minute, equals(0));
        expect(today.second, equals(0));
      });

      test('is equal to normalizeDate(now)', () {
        final today = normalizedToday();
        final normalized = normalizeDate(DateTime.now());

        expect(today, equals(normalized));
      });
    });
  });
}
