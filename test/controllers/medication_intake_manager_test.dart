import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:transdiy/controllers/medication_intake_manager.dart';
import 'package:transdiy/data/model/medication_intake.dart';
import 'package:transdiy/data/model/supply_item.dart';
import 'package:transdiy/data/providers/medication_intake_provider.dart';
import 'package:transdiy/data/providers/supply_item_provider.dart';

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
    test('takeMedication marks intake as taken',
        () async {
      final manager = MedicationIntakeManager(
          mockMedicationIntakeProvider, mockSupplyItemProvider);
      final intake = MedicationIntake(
        id: 10,
        scheduledDateTime: DateTime.now(),
        dose: Decimal.parse('2'),
      );

      final supplyItem = SupplyItem(
        id: 10,
        name: 'SupplySingle',
        totalDose: Decimal.parse('10'),
        usedDose: Decimal.parse('1'),
        dosePerUnit: Decimal.parse('1'),
      );

      late MedicationIntake addedIntake;
      when(mockMedicationIntakeProvider.add(any)).thenAnswer((inv) async {
        addedIntake = inv.positionalArguments.first as MedicationIntake;
        return Future.value();
      });

      await manager.takeMedication(intake, supplyItem);

      expect(addedIntake.isTaken, true);
    });

    test('takeMedication decreases supply item dose', () async {
      final manager = MedicationIntakeManager(
          mockMedicationIntakeProvider, mockSupplyItemProvider);
      final intake = MedicationIntake(
        id: 10,
        scheduledDateTime: DateTime.now(),
        dose: Decimal.parse('2'),
      );

      final supplyItem = SupplyItem(
        id: 10,
        name: 'SupplySingle',
        totalDose: Decimal.parse('10'),
        usedDose: Decimal.parse('1'),
        dosePerUnit: Decimal.parse('1'),
      );

      late SupplyItem updatedSupplyItem;
      when(mockSupplyItemProvider.updateItem(any)).thenAnswer((inv) async {
        updatedSupplyItem = inv.positionalArguments.first as SupplyItem;
        return Future.value();
      });

      await manager.takeMedication(intake, supplyItem);

      expect(updatedSupplyItem.usedDose, supplyItem.usedDose + intake.dose);
    });

    test('takeMedication respects custom taken date', () async {
      final manager = MedicationIntakeManager(
          mockMedicationIntakeProvider, mockSupplyItemProvider);
      final intake = MedicationIntake(
        id: 11,
        scheduledDateTime: DateTime.now(),
        dose: Decimal.parse('3'),
      );

      final supplyItem = SupplyItem(
        id: 11,
        name: 'SupplyDate',
        totalDose: Decimal.parse('10'),
        usedDose: Decimal.parse('1'),
        dosePerUnit: Decimal.parse('1'),
      );

      late MedicationIntake addedIntake;
      when(mockMedicationIntakeProvider.add(any)).thenAnswer((inv) {
        addedIntake = inv.positionalArguments.first as MedicationIntake;
        return Future.value();
      });

      final customDate = DateTime.now().add(Duration(days: 2));

      await manager.takeMedication(intake, supplyItem,
          takenDate: customDate);

      expect(addedIntake.takenDateTime, customDate);
    });

    test(
        'takeMedication clamps dose when supply does not have enough remaining and updates provider',
        () async {
      final manager = MedicationIntakeManager(
          mockMedicationIntakeProvider, mockSupplyItemProvider);
      final intake = MedicationIntake(
        id: 12,
        scheduledDateTime: DateTime.now(),
        dose: Decimal.parse('5'),
      );

      final supplyItem = SupplyItem(
        id: 12,
        name: 'SupplyLow',
        totalDose: Decimal.parse('4'),
        usedDose: Decimal.parse('1'),
        dosePerUnit: Decimal.parse('1'),
      );

      late SupplyItem updatedSupplyItem;
      when(mockSupplyItemProvider.updateItem(any)).thenAnswer((inv) async {
        updatedSupplyItem = inv.positionalArguments.first as SupplyItem;
        return Future.value();
      });

      await manager.takeMedication(intake, supplyItem);

      expect(updatedSupplyItem.usedDose, supplyItem.totalDose);
    });
  });
}
