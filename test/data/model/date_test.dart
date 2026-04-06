import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/date.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
  });

  group('Date', () {
    group('constructor', () {
      test('throws if value is not UTC', () {
        // Arrange
        final invalidDate = DateTime(2026, 3, 30, 12, 0);

        // Act & Assert
        expect(() => Date(invalidDate), throwsArgumentError);
      });

      test('throws if value is not at midnight', () {
        // Arrange
        final invalidDate = DateTime.utc(2026, 3, 30, 12, 0);

        // Act & Assert
        expect(() => Date(invalidDate), throwsArgumentError);
      });

      test('accepts valid UTC midnight date', () {
        // Arrange
        final validDate = DateTime.utc(2026, 3, 30);

        // Act
        final date = Date(validDate);

        // Assert
        expect(date.value, validDate);
      });
    });

    group('Date.fromDateTime', () {
      test('3:59am belongs to the previous day', () {
        // Arrange
        final input = DateTime(2026, 3, 30, 3, 59);

        // Act
        final date = Date.fromDateTime(input);

        // Assert
        expect(date.value, DateTime.utc(2026, 3, 29));
      });

      test('4:00am belongs to the current day', () {
        // Arrange
        final input = DateTime(2026, 3, 30, 4, 0);

        // Act
        final date = Date.fromDateTime(input);

        // Assert
        expect(date.value, DateTime.utc(2026, 3, 30));
      });

      test('midnight belongs to the previous day', () {
        // Arrange
        final input = DateTime(2026, 3, 30, 0, 0);

        // Act
        final date = Date.fromDateTime(input);

        // Assert
        expect(date.value, DateTime.utc(2026, 3, 29));
      });

      test('noon belongs to the current day', () {
        // Arrange
        final input = DateTime(2026, 3, 30, 12, 0);

        // Act
        final date = Date.fromDateTime(input);

        // Assert
        expect(date.value, DateTime.utc(2026, 3, 30));
      });

      test('3:59am on the 1st rolls back to the last day of the previous month',
          () {
        // Arrange
        final input = DateTime(2026, 3, 1, 3, 59);

        // Act
        final date = Date.fromDateTime(input);

        // Assert
        expect(date.value, DateTime.utc(2026, 2, 28));
      });

      test('3:59am on Jan 1st rolls back to Dec 31st of the previous year', () {
        // Arrange
        final input = DateTime(2026, 1, 1, 3, 59);

        // Act
        final date = Date.fromDateTime(input);

        // Assert
        expect(date.value, DateTime.utc(2025, 12, 31));
      });
    });

    group('Date.fromString / toString', () {
      test('round-trip preserves the date', () {
        // Arrange
        final original = Date.fromDateTime(DateTime(2026, 3, 30, 12, 0));

        // Act
        final restored = Date.fromString(original.toString());

        // Assert
        expect(restored, original);
      });

      test('throws if string is not UTC midnight', () {
        // Arrange
        final invalidString = '2026-03-30T12:00:00Z';

        // Act & Assert
        expect(() => Date.fromString(invalidString), throwsArgumentError);
      });

      test('throws if string is not in ISO format', () {
        // Arrange
        final invalidString = '03/30/2026';

        // Act & Assert
        expect(() => Date.fromString(invalidString), throwsFormatException);
      });
    });

    group('today', () {
      test('Date.today() is today (or yesterday if it is before 4am)', () {
        // Arrange
        final now = DateTime.now().toUtc();
        final logicalDay =
            now.hour < 4 ? now.subtract(const Duration(days: 1)) : now;
        final todayWithConstructor = Date(
            DateTime.utc(logicalDay.year, logicalDay.month, logicalDay.day));

        // Act
        final today = Date.today();

        // Assert
        expect(today, todayWithConstructor);
      });

      test('isToday is true for today', () {
        // Arrange
        final today = Date.today();

        // Act & Assert
        expect(today.isToday, isTrue);
      });

      test('isToday is false for dates other than today', () {
        // Arrange
        final yesterday = Date.fromDateTime(
          DateTime.now().subtract(const Duration(days: 1)),
        );

        // Act & Assert
        expect(yesterday.isToday, isFalse);
      });
    });

    group('differenceInDays', () {
      test('difference between two identical dates is 0', () {
        // Arrange
        final a = Date.fromDateTime(DateTime(2026, 3, 30, 12, 0));
        final b = Date.fromDateTime(DateTime(2026, 3, 30, 14, 0));

        // Act
        final diff = a.differenceInDays(b);

        // Assert
        expect(diff, 0);
      });

      test('difference between two dates is correct', () {
        // Arrange
        final a = Date.fromDateTime(DateTime(2026, 3, 30, 12, 0));
        final b = Date.fromDateTime(DateTime(2026, 3, 28, 12, 0));

        // Act & Assert
        expect(a.differenceInDays(b), 2);
      });

      test('difference across a DST change is still 1', () {
        // Arrange — France switches to summer time on March 29 2026 at 2am
        final paris = getLocation('Europe/Paris');
        final before = Date.fromDateTime(TZDateTime(paris, 2026, 3, 28, 12, 0));
        final after = Date.fromDateTime(TZDateTime(paris, 2026, 3, 29, 12, 0));

        // Act
        final diff = after.differenceInDays(before);

        // Assert
        expect(diff, 1);
      });
    });

    group('daysAwayFromToday', () {
      test('today is 0 days away', () {
        // Arrange
        final today = Date.today();

        // Act & Assert
        expect(today.daysAwayFromToday, 0);
      });

      test('yesterday and tomorrow are both 1 day away', () {
        // Arrange
        final now = DateTime.now();
        final yesterday =
            Date.fromDateTime(now.subtract(const Duration(days: 1)));
        final tomorrow = Date.fromDateTime(now.add(const Duration(days: 1)));

        // Act & Assert
        expect(yesterday.daysAwayFromToday, 1);
        expect(tomorrow.daysAwayFromToday, 1);
      });
    });

    group('position relative to today', () {
      test('isBeforeToday is true for past dates', () {
        // Arrange
        final yesterday = Date.today().subtract(const Duration(days: 1));

        // Act & Assert
        expect(yesterday.isBeforeToday, isTrue);
      });

      test('isBeforeToday is false for today and future dates', () {
        // Arrange
        final today = Date.today();
        final tomorrow = Date.today().add(const Duration(days: 1));

        // Act & Assert
        expect(
            [today.isBeforeToday, tomorrow.isBeforeToday], [isFalse, isFalse]);
      });

      test('isAfterToday is true for future dates', () {
        // Arrange
        final tomorrow = Date.today().add(const Duration(days: 1));

        // Act & Assert
        expect(tomorrow.isAfterToday, isTrue);
      });

      test('isAfterToday is false for today and past dates', () {
        // Arrange
        final today = Date.today();
        final yesterday = Date.today().subtract(const Duration(days: 1));

        // Act & Assert
        expect(
            [today.isAfterToday, yesterday.isAfterToday], [isFalse, isFalse]);
      });
    });

    group('isBefore, isAfter, isSameDayAs', () {
      group('isSameDayAs', () {
        final cases = [
          (
            description: 'same day',
            a: Date(DateTime.utc(2024, 6, 15)),
            b: Date(DateTime.utc(2024, 6, 15)),
            expected: true,
          ),
          (
            description: 'different day',
            a: Date(DateTime.utc(2024, 6, 15)),
            b: Date(DateTime.utc(2024, 6, 16)),
            expected: false,
          ),
        ];

        for (final c in cases) {
          test(c.description, () {
            final result = c.a.isSameDayAs(c.b);
            expect(result, c.expected);
          });
        }
      });

      group('isBefore', () {
        final cases = [
          (
            description: 'date is before other',
            a: Date(DateTime.utc(2024, 6, 15)),
            b: Date(DateTime.utc(2024, 6, 16)),
            expected: true,
          ),
          (
            description: 'date is after other',
            a: Date(DateTime.utc(2024, 6, 15)),
            b: Date(DateTime.utc(2024, 6, 14)),
            expected: false,
          ),
          (
            description: 'same day',
            a: Date(DateTime.utc(2024, 6, 15)),
            b: Date(DateTime.utc(2024, 6, 15)),
            expected: false,
          ),
        ];

        for (final c in cases) {
          test(c.description, () {
            final result = c.a.isBefore(c.b);
            expect(result, c.expected);
          });
        }
      });

      group('isAfter', () {
        final cases = [
          (
            description: 'date is after other',
            a: Date(DateTime.utc(2024, 6, 15)),
            b: Date(DateTime.utc(2024, 6, 14)),
            expected: true,
          ),
          (
            description: 'date is before other',
            a: Date(DateTime.utc(2024, 6, 15)),
            b: Date(DateTime.utc(2024, 6, 16)),
            expected: false,
          ),
          (
            description: 'same day',
            a: Date(DateTime.utc(2024, 6, 15)),
            b: Date(DateTime.utc(2024, 6, 15)),
            expected: false,
          ),
        ];

        for (final c in cases) {
          test(c.description, () {
            final result = c.a.isAfter(c.b);
            expect(result, c.expected);
          });
        }
      });
    });

    group('add and subtract', () {
      test('adding a duration results in the correct date', () {
        // Arrange
        final date = Date(DateTime.utc(2024, 6, 15));

        // Act
        final newDate = date.add(const Duration(days: 5));

        // Assert
        expect(newDate.value, DateTime.utc(2024, 6, 20));
      });

      test('subtracting a duration results in the correct date', () {
        // Arrange
        final date = Date(DateTime.utc(2024, 6, 15));

        // Act
        final newDate = date.subtract(const Duration(days: 10));

        // Assert
        expect(newDate.value, DateTime.utc(2024, 6, 5));
      });
    });

    group('export', () {
      test('toDateTime returns a DateTime at midnight of the same day', () {
        // Arrange
        final date = Date(DateTime.utc(2024, 6, 15));

        // Act
        final dateTime = date.toDateTime();

        // Assert
        expect(dateTime, DateTime(2024, 6, 15));
      });

      test('toUtcDateTime returns the original UTC DateTime value', () {
        // Arrange
        final date = Date(DateTime.utc(2024, 6, 15));

        // Act
        final utcDateTime = date.toUtcDateTime();

        // Assert
        expect(utcDateTime, DateTime.utc(2024, 6, 15));
      });

      test('toString returns the ISO string representation of the date', () {
        // Arrange
        final date = Date(DateTime.utc(2024, 6, 15));

        // Act
        final string = date.toString();

        // Assert
        expect(string, '2024-06-15T00:00:00.000Z');
      });
    });
  });
}
