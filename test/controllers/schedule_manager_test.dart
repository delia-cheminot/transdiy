import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mona/controllers/schedule_manager.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/util/date_helpers.dart';

@GenerateNiceMocks([
  MockSpec<MedicationScheduleProvider>(),
  MockSpec<MedicationIntakeProvider>(),
])
import 'schedule_manager_test.mocks.dart';

void main() {
  late MockMedicationScheduleProvider mockScheduleProvider;
  late MockMedicationIntakeProvider mockIntakeProvider;
  late ScheduleManager manager;

  setUp(() {
    mockScheduleProvider = MockMedicationScheduleProvider();
    mockIntakeProvider = MockMedicationIntakeProvider();

    manager = ScheduleManager(
      mockScheduleProvider,
      mockIntakeProvider,
    );
  });

  group('ScheduleManager - getSchedulesByStatus', () {
    late MedicationSchedule todaySchedule;
    late MedicationSchedule todayOverdueSchedule;
    late MedicationSchedule overdueSchedule;
    late MedicationSchedule upcomingSchedule;

    setUp(() {
      final today = normalizedToday();

      todaySchedule = MedicationSchedule(
        id: 1,
        name: 'TodayMed',
        dose: Decimal.one,
        intervalDays: 2,
        startDate: today,
      );
      when(mockIntakeProvider.getLastIntakeDateForSchedule(1))
          .thenReturn(today.subtract(const Duration(days: 2)));

      todayOverdueSchedule = MedicationSchedule(
        id: 4,
        name: 'TodayLateMed',
        dose: Decimal.one,
        intervalDays: 2,
        startDate: today.subtract(const Duration(days: 4)),
      );
      when(mockIntakeProvider.getLastIntakeDateForSchedule(4))
          .thenReturn(today.subtract(const Duration(days: 3)));

      overdueSchedule = MedicationSchedule(
        id: 2,
        name: 'OverdueMed',
        dose: Decimal.one,
        intervalDays: 2,
        startDate: today.subtract(const Duration(days: 9)),
      );
      when(mockIntakeProvider.getLastIntakeDateForSchedule(2))
          .thenReturn(today.subtract(const Duration(days: 4)));

      upcomingSchedule = MedicationSchedule(
        id: 3,
        name: 'UpcomingMed',
        dose: Decimal.one,
        intervalDays: 2,
        startDate: today.add(const Duration(days: 10)),
      );
      when(mockIntakeProvider.getLastIntakeDateForSchedule(3)).thenReturn(null);

      when(mockScheduleProvider.schedules).thenReturn([
        todaySchedule,
        todayOverdueSchedule,
        overdueSchedule,
        upcomingSchedule,
      ]);
    });

    test('returns only today schedules (not late)', () {
      final result = manager.getSchedulesByStatus(ScheduleStatus.today);
      expect(result, [todaySchedule]);
    });

    test('returns only todayOverdue schedules', () {
      final result = manager.getSchedulesByStatus(ScheduleStatus.todayOverdue);
      expect(result, [todayOverdueSchedule]);
    });

    test('returns only overdue schedules', () {
      final result = manager.getSchedulesByStatus(ScheduleStatus.overdue);
      expect(result, [overdueSchedule]);
    });

    test('returns only upcoming schedules', () {
      final result = manager.getSchedulesByStatus(ScheduleStatus.upcoming);
      expect(result, [upcomingSchedule]);
    });

    test('all schedules accounted for across statuses', () {
      final today = manager.getSchedulesByStatus(ScheduleStatus.today);
      final todayOverdue =
          manager.getSchedulesByStatus(ScheduleStatus.todayOverdue);
      final overdue = manager.getSchedulesByStatus(ScheduleStatus.overdue);
      final upcoming = manager.getSchedulesByStatus(ScheduleStatus.upcoming);

      final combined = [...today, ...todayOverdue, ...overdue, ...upcoming];
      expect(combined.length, 4);
      expect(
          combined,
          containsAll([
            todaySchedule,
            todayOverdueSchedule,
            overdueSchedule,
            upcomingSchedule
          ]));
    });
  });
}
