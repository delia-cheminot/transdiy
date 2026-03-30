import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/date.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
  });

  group('Date', () {
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

    group('Date.fromTZ', () {
      test('3:59am Paris summer time (UTC+2) belongs to the previous day', () {
        // Arrange
        final paris = getLocation('Europe/Paris');
        final input = TZDateTime(paris, 2026, 7, 15, 3, 59);

        // Act
        final date = Date.fromTZ(input);

        // Assert
        expect(date.value, DateTime.utc(2026, 7, 14));
      });

      test(
          'same UTC timestamp in different timezones can yield different logical days',
          () {
        // Arrange
        final utc = DateTime.utc(2026, 3, 30, 2, 30);
        final tokyo = getLocation(
            'Asia/Tokyo'); // In Tokyo (UTC+9) that's 11:30am → logical day is March 30
        final newYork = getLocation(
            'America/New_York'); // In New York (UTC-5) that's 9:30pm March 29 → logical day is March 29

        // Act
        final dateTokyo = Date.fromTZ(TZDateTime.from(utc, tokyo));
        final dateNewYork = Date.fromTZ(TZDateTime.from(utc, newYork));

        // Assert
        expect(dateTokyo.value, DateTime.utc(2026, 3, 30));
        expect(dateNewYork.value, DateTime.utc(2026, 3, 29));
      });
    });

    group('Date.fromString / toString round-trip', () {
      test('round-trip preserves the date', () {
        // Arrange
        final original = Date.fromDateTime(DateTime(2026, 3, 30, 12, 0));

        // Act
        final restored = Date.fromString(original.toString());

        // Assert
        expect(restored, original);
      });
    });

    group('Date.isToday', () {
      test('Date.today() is today', () {
        // Arrange
        final date = Date.today();

        // Act & Assert
        expect(date.isToday, isTrue);
      });

      test('yesterday is not today', () {
        // Arrange
        final yesterday = Date.fromDateTime(
          DateTime.now().subtract(const Duration(days: 1)),
        );

        // Act & Assert
        expect(yesterday.isToday, isFalse);
      });
    });

    group('Date.differenceInDays', () {
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
        final before = Date.fromTZ(TZDateTime(paris, 2026, 3, 28, 12, 0));
        final after = Date.fromTZ(TZDateTime(paris, 2026, 3, 29, 12, 0));

        // Act
        final diff = after.differenceInDays(before);

        // Assert
        expect(diff, 1);
      });
    });

    group('Date.daysAwayFromToday', () {
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
  });
}
