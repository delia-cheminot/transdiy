import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mona/controllers/medication_intake_manager.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/model/supply_item.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/supply_item_provider.dart';

@GenerateNiceMocks([
  MockSpec<MedicationIntakeProvider>(),
  MockSpec<SupplyItemProvider>(),
])
import 'medication_intake_manager_test.mocks.dart';

void main() {
  late MockMedicationIntakeProvider mockMedicationIntakeProvider;
  late MockSupplyItemProvider mockSupplyItemProvider;

  setUp(() {
    mockMedicationIntakeProvider = MockMedicationIntakeProvider();
    mockSupplyItemProvider = MockSupplyItemProvider();
  });

  group('MedicationIntakeManager', () {
    test('takeMedication creates a taken MedicationIntake', () async {
      final manager = MedicationIntakeManager(
          mockMedicationIntakeProvider, mockSupplyItemProvider);
      final dose = Decimal.parse('2');
      final date = DateTime.now();

      final supplyItem = SupplyItem(
        id: 10,
        name: 'SupplySingle',
        totalDose: Decimal.parse('10'),
        usedDose: Decimal.parse('1'),
        dosePerUnit: Decimal.parse('1'),
      );

      final schedule = MedicationSchedule(
        name: 'ScheduleSingle',
        dose: dose,
        intervalDays: 1,
      );

      late MedicationIntake addedIntake;
      when(mockMedicationIntakeProvider.add(any)).thenAnswer((inv) async {
        addedIntake = inv.positionalArguments.first as MedicationIntake;
        return Future.value();
      });

      final expectedIntake = MedicationIntake(
        dose: dose,
        scheduledDateTime: date,
        takenDateTime: date,
        scheduleId: schedule.id,
      );

      await manager.takeMedication(
          dose, date, date, supplyItem, schedule);

      expect(addedIntake, expectedIntake);
    });

    test('takeMedication decreases supply item dose', () async {
      final manager = MedicationIntakeManager(
          mockMedicationIntakeProvider, mockSupplyItemProvider);
      final dose = Decimal.parse('2');
      final scheduledDate = DateTime.now();
      final takenDate = DateTime.now();

      final supplyItem = SupplyItem(
        id: 10,
        name: 'SupplySingle',
        totalDose: Decimal.parse('10'),
        usedDose: Decimal.parse('1'),
        dosePerUnit: Decimal.parse('1'),
      );

      final schedule = MedicationSchedule(
        name: 'ScheduleSingle',
        dose: dose,
        intervalDays: 1,
      );

      late SupplyItem updatedSupplyItem;
      when(mockSupplyItemProvider.updateItem(any)).thenAnswer((inv) async {
        updatedSupplyItem = inv.positionalArguments.first as SupplyItem;
        return Future.value();
      });

      await manager.takeMedication(
          dose, scheduledDate, takenDate, supplyItem, schedule);

      expect(updatedSupplyItem.usedDose, supplyItem.usedDose + dose);
    });

    test('getNextSide returns correct side', () {
      final firstIntake = MedicationIntake(
        id: 1,
        scheduledDateTime: DateTime(2025, 9, 14, 10, 30),
        dose: Decimal.parse('2.5'),
        takenDateTime: DateTime(2025, 9, 14, 12, 0),
        scheduleId: 42,
        side: InjectionSide.left,
      );

      when (mockMedicationIntakeProvider.getLastTakenIntake())
          .thenReturn(firstIntake);

      final manager = MedicationIntakeManager(
          mockMedicationIntakeProvider, mockSupplyItemProvider);

      final InjectionSide nextSide = manager.getNextSide();

      expect(nextSide, InjectionSide.right);
    });
  });
}
