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

    group('daysBetweenDate', () {
      final today = DateTime(2026, 3, 2);

      test('returns correct absolute difference for future date', () {
        final future = today.add(Duration(days: 5));
        expect(daysBetweenDate(future, origin: today), equals(5));
      });

      test('returns correct absolute difference for past date', () {
        final past = today.subtract(Duration(days: 3));
        expect(daysBetweenDate(past, origin: today), equals(3));
      });

      test('returns 0 if same date', () {
        expect(daysBetweenDate(today, origin: today), equals(0));
      });

      test('uses DateTime.now() if origin is null', () {
        final now = DateTime.now();
        final target = now.add(Duration(days: 2));
        expect(daysBetweenDate(target), equals(2));
      });
    });

    group('isSameDayAs', () {
      test('returns true for same day with different times', () {
        // Arrange
        final d1 = DateTime(2026, 3, 8, 10, 30);
        final d2 = DateTime(2026, 3, 8, 22, 15);

        // Act
        final isSameDay = isSameDayAs(d1, d2);

        // Assert
        expect(isSameDay, isTrue);
      });

      test('returns false for different days', () {
        // Arrange
        final d1 = DateTime(2026, 3, 8, 23, 59);
        final d2 = DateTime(2026, 3, 9, 0, 1);

        // Act
        final isSameDay = isSameDayAs(d1, d2);

        // Assert
        expect(isSameDay, isFalse);
      });

      test('returns true for identical DateTime', () {
        // Arrange
        final date = DateTime(2026, 3, 8);

        // Act
        final isSameDay = isSameDayAs(date, date);

        // Assert
        expect(isSameDay, isTrue);
      });
    });
  });
}
