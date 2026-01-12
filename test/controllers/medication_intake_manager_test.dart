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
    group('takeMedication', () {
      test('creates a taken MedicationIntake', () async {
        final manager = MedicationIntakeManager(
            mockMedicationIntakeProvider, mockSupplyItemProvider);
        final dose = Decimal.parse('2');
        final date = DateTime.now();
        const side = InjectionSide.left;

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

        await manager.takeMedication(dose, date, date, supplyItem, schedule, side);

        expect({
          addedIntake.dose,
          addedIntake.scheduledDateTime,
          addedIntake.takenDateTime,
          addedIntake.scheduleId,
          addedIntake.side,
        }, {
          dose,
          date,
          date,
          schedule.id,
          side,
        });
      });
      final expectedIntake = MedicationIntake(
        dose: dose,
        scheduledDateTime: date,
        takenDateTime: date,
        scheduleId: schedule.id,
        side: side,
      );

      await manager.takeMedication(
          dose, date, date, supplyItem, schedule, side);

      expect(addedIntake, expectedIntake);
    });

      test('decreases supply item dose', () async {
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
            dose, scheduledDate, takenDate, supplyItem, schedule, null);

        expect(updatedSupplyItem.usedDose, supplyItem.usedDose + dose);
      });
    });

    group('getNextSide', () {
      test('returns right when last side is left', () {
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

      test('returns left when last side is right', () {
        final lastIntake = MedicationIntake(
          id: 2,
          scheduledDateTime: DateTime(2025, 9, 15, 10, 30),
          dose: Decimal.parse('2.5'),
          takenDateTime: DateTime(2025, 9, 15, 12, 0),
          scheduleId: 42,
          side: InjectionSide.right,
        );

        when (mockMedicationIntakeProvider.getLastTakenIntake())
            .thenReturn(lastIntake);

        final manager = MedicationIntakeManager(
            mockMedicationIntakeProvider, mockSupplyItemProvider);

        expect(manager.getNextSide(), InjectionSide.left);
      });

      test('returns left when there is no last intake', () {
        when(mockMedicationIntakeProvider.getLastTakenIntake()).thenReturn(null);

        final manager = MedicationIntakeManager(
            mockMedicationIntakeProvider, mockSupplyItemProvider);

        expect(manager.getNextSide(), InjectionSide.left);
      });

      test('returns left when last intake side is null', () {
        final intake = MedicationIntake(
          id: 3,
          scheduledDateTime: DateTime(2025, 9, 16, 10, 30),
          dose: Decimal.parse('2.5'),
          takenDateTime: DateTime(2025, 9, 16, 12, 0),
          scheduleId: 42,
          side: null,
        );

        when(mockMedicationIntakeProvider.getLastTakenIntake()).thenReturn(intake);

        final manager = MedicationIntakeManager(
            mockMedicationIntakeProvider, mockSupplyItemProvider);

        expect(manager.getNextSide(), InjectionSide.left);
      });
    });
  });
}
