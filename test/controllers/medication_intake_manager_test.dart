import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:transdiy/controllers/medication_intake_manager.dart';
import 'package:transdiy/data/model/medication_intake.dart';
import 'package:transdiy/data/model/medication_schedule.dart';
import 'package:transdiy/data/model/supply_item.dart';
import '../mocks/mocks.mocks.dart';

void main() {
  late MedicationIntakeManager manager;
  late MockMedicationIntakeProvider mockMedicationIntakeState;
  late MockSupplyItemManager mockSupplyItemManager;
  late MockMedicationScheduleProvider mockMedicationScheduleProvider;

  setUp(() {
    mockMedicationIntakeState = MockMedicationIntakeProvider();
    mockMedicationScheduleProvider = MockMedicationScheduleProvider();
    mockSupplyItemManager = MockSupplyItemManager();
    manager = MedicationIntakeManager(
        mockMedicationIntakeState, mockMedicationScheduleProvider);
  });

  group('MedicationIntakeManager', () {
    test('should take medication correctly', () async {
      final intake = MedicationIntake(
        id: 1,
        scheduledDateTime: DateTime.now(),
        dose: Decimal.parse('1'),
      );

      final supplyItem = SupplyItem(
        id: 1,
        name: 'TestSupply',
        totalDose: Decimal.parse('10'),
        usedDose: Decimal.parse('2'),
        dosePerUnit: Decimal.parse('5'),
      );

      await manager.takeMedication(intake, supplyItem, mockSupplyItemManager);

      expect(intake.isTaken, true);
      verify(mockMedicationIntakeState.updateIntake(intake)).called(1);
      verify(mockSupplyItemManager.useDose(supplyItem, intake.dose)).called(1);
    });

    test('should throw ArgumentError when taking medication already taken',
        () async {
      final intake = MedicationIntake(
        id: 1,
        scheduledDateTime: DateTime.now(),
        takenDateTime: DateTime.now(),
        dose: Decimal.parse('1'),
      );

      final supplyItem = SupplyItem(
        id: 1,
        name: 'TestSupply',
        totalDose: Decimal.parse('10'),
        usedDose: Decimal.parse('2'),
        dosePerUnit: Decimal.parse('5'),
      );

      expect(
          () async => await manager.takeMedication(
              intake, supplyItem, mockSupplyItemManager),
          throwsArgumentError);
    });

    test('should take medication with custom date', () async {
      final intake = MedicationIntake(
        id: 1,
        scheduledDateTime: DateTime.now(),
        dose: Decimal.parse('1'),
      );

      final supplyItem = SupplyItem(
        id: 1,
        name: 'TestSupply',
        totalDose: Decimal.parse('10'),
        usedDose: Decimal.parse('2'),
        dosePerUnit: Decimal.parse('5'),
      );

      final customDate = DateTime.now().add(Duration(days: 1));

      await manager.takeMedication(intake, supplyItem, mockSupplyItemManager,
          takenDate: customDate);

      expect(intake.isTaken, true);
      expect(intake.takenDateTime, customDate);
      verify(mockMedicationIntakeState.updateIntake(intake)).called(1);
    });

    test('should handle case when not enough medication is remaining',
        () async {
      final intake = MedicationIntake(
        id: 1,
        scheduledDateTime: DateTime.now(),
        dose: Decimal.parse('15'),
      );

      final supplyItem = SupplyItem(
        id: 1,
        name: 'TestSupply',
        totalDose: Decimal.parse('10'),
        usedDose: Decimal.parse('9'),
        dosePerUnit: Decimal.parse('1'),
      );

      Decimal remainingDose = Decimal.parse('1'); // 1mg remaining in the supply
      Decimal doseToAdd =
          Decimal.parse('14'); // 14mg to be added in a new intake

      when(mockMedicationIntakeState.addIntake(intake.scheduledDateTime, any))
          .thenAnswer((_) async {});

      await manager.takeMedication(intake, supplyItem, mockSupplyItemManager);

      expect(intake.dose, remainingDose);

      verify(mockMedicationIntakeState.addIntake(
        intake.scheduledDateTime,
        doseToAdd,
      )).called(1);

      verify(mockSupplyItemManager.useDose(
              supplyItem, supplyItem.totalDose - supplyItem.usedDose))
          .called(1);
      expect(intake.isTaken, true);
    });

    test('should update schedule last taken date if scheduleId is present',
        () async {
      final intake = MedicationIntake(
        id: 1,
        scheduledDateTime: DateTime.now(),
        dose: Decimal.parse('1'),
        scheduleId: 42,
      );

      final supplyItem = SupplyItem(
        id: 1,
        name: 'TestSupply',
        totalDose: Decimal.parse('10'),
        usedDose: Decimal.parse('2'),
        dosePerUnit: Decimal.parse('5'),
      );

      final schedule = MedicationSchedule(
        id: 42,
        name: 'Test Med',
        dose: Decimal.parse('1'),
        intervalDays: 7,
      );

      when(mockMedicationScheduleProvider.getScheduleById(42))
          .thenReturn(schedule);
      when(mockMedicationScheduleProvider.updateSchedule(any))
          .thenAnswer((_) async {});

      await manager.takeMedication(intake, supplyItem, mockSupplyItemManager);

      expect(schedule.lastTaken.day, DateTime.now().day);
      verify(mockMedicationScheduleProvider.updateSchedule(schedule)).called(1);
    });
  });
}
