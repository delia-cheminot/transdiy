import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/date.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/l10n/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('MedicationSchedule', () {
    group('MedicationSchedule model', () {
      test('toMap and fromMap should preserve values', () {
        final schedule = MedicationSchedule(
          id: 1,
          name: 'Test Med',
          dose: Decimal.parse('10.5'),
          intervalDays: 7,
          startDate: Date.today(),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.injection,
          ester: Ester.cypionate,
          notificationTimes: List.from([
            TimeOfDay(hour: 12, minute: 30),
            TimeOfDay(hour: 18, minute: 30)
          ]),
        );

        final map = schedule.toMap();
        final fromMap = MedicationSchedule.fromMap(map);

        expect(
          fromMap,
          isA<MedicationSchedule>()
              .having((s) => s.id, 'id', schedule.id)
              .having((s) => s.name, 'name', schedule.name)
              .having((s) => s.dose, 'dose', schedule.dose)
              .having(
                  (s) => s.intervalDays, 'intervalDays', schedule.intervalDays)
              .having((s) => s.startDate, 'startDate', schedule.startDate)
              .having((s) => s.molecule, 'molecule', schedule.molecule)
              .having((s) => s.administrationRoute, 'administrationRoute',
                  schedule.administrationRoute)
              .having((s) => s.ester, 'ester', schedule.ester)
              .having((s) => s.notificationTimes, 'notificationTimes',
                  schedule.notificationTimes),
        );
      });

      test('validateName works correctly', () {
        expect(
          [
            MedicationSchedule.validateName(l10n, null),
            MedicationSchedule.validateName(l10n, ''),
            MedicationSchedule.validateName(l10n, 'Valid'),
          ],
          [
            isNotNull,
            isNotNull,
            isNull,
          ],
        );
      });

      test('validateDose works correctly', () {
        expect(
          [
            MedicationSchedule.validateDose(l10n, null),
            MedicationSchedule.validateDose(l10n, ''),
            MedicationSchedule.validateDose(l10n, '0'),
            MedicationSchedule.validateDose(l10n, '-1'),
            MedicationSchedule.validateDose(l10n, 'abc'),
            MedicationSchedule.validateDose(l10n, '2.5'),
          ],
          [
            isNotNull,
            isNotNull,
            isNotNull,
            isNotNull,
            isNotNull,
            isNull,
          ],
        );
      });

      test('validateIntervalDays works correctly', () {
        expect(
          [
            MedicationSchedule.validateIntervalDays(l10n, null),
            MedicationSchedule.validateIntervalDays(l10n, ''),
            MedicationSchedule.validateIntervalDays(l10n, '0'),
            MedicationSchedule.validateIntervalDays(l10n, '-2'),
            MedicationSchedule.validateIntervalDays(l10n, 'abc'),
            MedicationSchedule.validateIntervalDays(l10n, '7'),
          ],
          [
            isNotNull,
            isNotNull,
            isNotNull,
            isNotNull,
            isNotNull,
            isNull,
          ],
        );
      });

      test('validateStartDate works correctly', () {
        // Arrange
        final cases = [
          {'value': null, 'expected': isNotNull},
          {'value': Date.today(), 'expected': isNull},
        ];

        // Act
        final results = cases
            .map((c) => MedicationSchedule.validateStartDate(
                  l10n,
                  c['value'] as Date?,
                ))
            .toList();
        final expected = cases.map((c) => c['expected'] as Matcher).toList();

        // Assert
        expect(results, expected);
      });

      test('validateMolecule works correctly', () {
        // Arrange
        final cases = [
          {'value': null, 'expected': isNotNull},
          {'value': KnownMolecules.decapeptyl, 'expected': isNull},
        ];

        // Act
        final results = cases
            .map((c) => MedicationSchedule.validateMolecule(
                  l10n,
                  c['value'] as Molecule?,
                ))
            .toList();
        final expected = cases.map((c) => c['expected'] as Matcher).toList();

        // Assert
        expect(results, expected);
      });

      test('validateAdministrationRoute works correctly', () {
        // Arrange
        final cases = [
          {'value': null, 'expected': isNotNull},
          {'value': AdministrationRoute.implant, 'expected': isNull},
        ];

        // Act
        final results = cases
            .map((c) => MedicationSchedule.validateAdministrationRoute(
                  l10n,
                  c['value'] as AdministrationRoute?,
                ))
            .toList();
        final expected = cases.map((c) => c['expected'] as Matcher).toList();

        // Assert
        expect(results, expected);
      });

      test('validateEster works correctly', () {
        // Arrange
        final cases = [
          {
            'molecule': null,
            'route': null,
            'value': null,
            'expected': isNull,
          },
          {
            'molecule': KnownMolecules.estradiol,
            'route': AdministrationRoute.injection,
            'value': null,
            'expected': isNotNull,
          },
          {
            'molecule': KnownMolecules.estradiol,
            'route': AdministrationRoute.injection,
            'value': Ester.enanthate,
            'expected': isNull,
          },
          {
            'molecule': KnownMolecules.estradiol,
            'route': AdministrationRoute.oral,
            'value': Ester.enanthate,
            'expected': isNull,
          },
          {
            'molecule': KnownMolecules.estradiol,
            'route': AdministrationRoute.oral,
            'value': null,
            'expected': isNull,
          },
        ];

        // Act
        final results = cases.map((c) {
          final validator = MedicationSchedule.esterValidator(
            l10n,
            c['molecule'] as Molecule?,
            c['route'] as AdministrationRoute?,
          );
          return validator(c['value'] as Ester?);
        }).toList();
        final expected = cases.map((c) => c['expected'] as Matcher).toList();

        // Assert
        expect(results, expected);
      });
    });

    group('getNextDate', () {
      test('startDate > today -> returns startDate', () {
        final start = Date.today().add(Duration(days: 5));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(s.nextDate, start);
      });

      test('startDate == today -> returns startDate', () {
        final today = Date.today();
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: today,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(s.nextDate, today);
      });

      test(
          'today falls outside a scheduled date -> returns the next scheduled date',
          () {
        final start = Date.today().subtract(Duration(days: 4));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final expectedNext = Date.today().add(Duration(days: 3));
        expect(s.nextDate, expectedNext);
      });

      test('today falls exactly on a scheduled date -> returns today', () {
        final start = Date.today().subtract(Duration(days: 7));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(s.nextDate, Date.today());
      });

      test('intervalDays = 1 and startDate < today -> returns today', () {
        final start = Date.today().subtract(Duration(days: 9));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 1,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(s.nextDate, Date.today());
      });
    });

    group('getLastDate', () {
      test('startDate > today -> returns null', () {
        final start = Date.today().add(Duration(days: 5));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(s.previousDate, isNull);
      });

      test('startDate == today -> returns null', () {
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: Date.today(),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(s.previousDate, isNull);
      });

      test(
          'today falls outside a scheduled date -> returns the most recent past scheduled date',
          () {
        final start = Date.today().subtract(Duration(days: 4));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(s.previousDate, start);
      });

      test(
          'today falls exactly on a scheduled date -> returns scheduled date before today',
          () {
        final start = Date.today().subtract(Duration(days: 7));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(s.previousDate, start);
      });

      test('intervalDays = 1 and startDate < today -> returns yesterday', () {
        final start = Date.today().subtract(Duration(days: 9));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 1,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(s.previousDate, Date.today().subtract(Duration(days: 1)));
      });
    });

    group('Consistency checks between last and next date', () {
      test(
          'when startDate < today -> lastDate < nextDate and difference == intervalDays',
          () {
        final start = Date.today().subtract(Duration(days: 4));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final last = s.previousDate;
        final next = s.nextDate;

        expect(next.differenceInDays(last!), s.intervalDays);
      });

      test(
          'difference == intervalDays when today is exactly on a scheduled date',
          () {
        final start = Date.today().subtract(Duration(days: 7));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final last = s.previousDate;
        final next = s.nextDate;

        expect(next.differenceInDays(last!), s.intervalDays);
      });
    });

    group('getNextDates', () {
      test('today is an intake date -> first returned date is today', () {
        final start = Date.today().subtract(Duration(days: 7));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final dates = s.getNextDates(3);

        expect(dates.first, Date.today());
      });

      test(
          'today is not an intake date -> first returned date is next scheduled date',
          () {
        final start = Date.today().subtract(Duration(days: 4));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final dates = s.getNextDates(2);

        expect(dates.first, Date.today().add(Duration(days: 3)));
      });

      test('startDate is today -> first returned date is today', () {
        final today = Date.today();
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: today,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final dates = s.getNextDates(2);

        expect(dates.first, today);
      });

      test('startDate is in the future -> first returned date is startDate',
          () {
        final start = Date.today().add(Duration(days: 5));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final dates = s.getNextDates(2);

        expect(dates.first, start);
      });

      test('count = 1 -> returns exactly one date', () {
        final start = Date.today().subtract(Duration(days: 9));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final dates = s.getNextDates(1);

        expect(dates.length, 1);
      });

      test('count > 1 -> returns exactly count dates', () {
        final start = Date.today().subtract(Duration(days: 9));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final dates = s.getNextDates(4);

        expect(dates.length, 4);
      });

      test('returned dates are spaced by intervalDays', () {
        final start = Date.today().subtract(Duration(days: 9));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final dates = s.getNextDates(3);

        expect(dates[2].differenceInDays(dates[1]), 7);
      });

      test('count = 0 -> returns empty list', () {
        final start = Date.today().subtract(Duration(days: 9));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final dates = s.getNextDates(0);

        expect(dates, isEmpty);
      });

      test('count < 0 -> throws ArgumentError', () {
        final start = Date.today().subtract(Duration(days: 9));
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: start,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(
          () => s.getNextDates(-1),
          throwsArgumentError,
        );
      });
    });

    group('isScheduledForToday', () {
      test('returns true when today is a scheduled date', () {
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: Date.today(),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(s.isScheduledForToday(), isTrue);
      });

      test('returns false when next scheduled date is in future', () {
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: Date.today().add(Duration(days: 3)),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(s.isScheduledForToday(), isFalse);
      });

      test('returns false when next scheduled date is in past', () {
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: Date.today().subtract(Duration(days: 3)),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(s.isScheduledForToday(), isFalse);
      });
    });

    group('isLate', () {
      test('returns true when lastTaken is before lastDate', () {
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: Date.today().subtract(Duration(days: 14)),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final lastTaken = s.previousDate!.subtract(Duration(days: 1));

        expect(s.isLate(lastTaken), isTrue);
      });

      test('returns false when lastTaken is on lastDate', () {
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: Date.today().subtract(Duration(days: 14)),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final lastTaken = s.previousDate!;

        expect(s.isLate(lastTaken), isFalse);
      });

      test('returns false when lastTaken is after lastDate', () {
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: Date.today().subtract(Duration(days: 14)),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final lastTaken = s.previousDate!.add(Duration(days: 1));

        expect(s.isLate(lastTaken), isFalse);
      });

      test('returns true when lastTaken is null but schedule is overdue', () {
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: Date.today().subtract(Duration(days: 14)),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(s.isLate(null), isTrue);
      });

      test(
          'returns false when lastTaken is null but treatment is scheduled for today',
          () {
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: Date.today(),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(s.isLate(null), isFalse);
      });

      test(
          'returns false when lastTaken is null but next scheduled date is in the future',
          () {
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: Date.today().add(Duration(days: 3)),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(s.isLate(null), isFalse);
      });
    });

    group('isTakenTodayOrLater', () {
      test('returns false if no last taken', () {
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: Date.today().add(Duration(days: 3)),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        expect(s.isTakenTodayOrLater(null), false);
      });

      test('returns false if last taken date is before today', () {
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: Date.today().add(Duration(days: 3)),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final lastTakenDate = Date.today().subtract(const Duration(days: 1));

        expect(s.isTakenTodayOrLater(lastTakenDate), false);
      });

      test('returns true if last taken date is after today', () {
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: Date.today().add(Duration(days: 3)),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final lastTakenDate = Date.today().add(const Duration(days: 1));

        expect(s.isTakenTodayOrLater(lastTakenDate), true);
      });

      test('returns true if last taken date is today', () {
        final s = MedicationSchedule(
          name: 'A',
          dose: Decimal.one,
          intervalDays: 7,
          startDate: Date.today().add(Duration(days: 3)),
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.oral,
          notificationTimes: List.empty(),
        );

        final lastTakenDate = Date.today();

        expect(s.isTakenTodayOrLater(lastTakenDate), true);
      });
    });
  });
}
