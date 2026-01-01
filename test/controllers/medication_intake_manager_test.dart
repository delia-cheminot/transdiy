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

  setUpAll(() {
    mockMedicationIntakeProvider = MockMedicationIntakeProvider();
    mockSupplyItemProvider = MockSupplyItemProvider();
  });

  group('MedicationIntakeManager', () {
    test('should take medication correctly', () async {
      final manager = MedicationIntakeManager(
          mockMedicationIntakeProvider, mockSupplyItemProvider);
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

      late MedicationIntake updatedIntake;
      when(mockMedicationIntakeProvider.updateIntake(any)).thenAnswer((inv) {
        updatedIntake = inv.positionalArguments.first as MedicationIntake;
        return Future.value();
      });

      await manager.takeMedication(intake, supplyItem);

      expect(updatedIntake.isTaken, true);
      verify(mockMedicationIntakeProvider.updateIntake(updatedIntake))
          .called(1);
      verify(mockSupplyItemProvider.updateItem(
              supplyItem.copyWith(usedDose: supplyItem.usedDose + intake.dose)))
          .called(1);
    });

    test('should throw ArgumentError when taking medication already taken',
        () async {
      final manager = MedicationIntakeManager(
          mockMedicationIntakeProvider, mockSupplyItemProvider);
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

      expect(() async => await manager.takeMedication(intake, supplyItem),
          throwsArgumentError);
    });

    test('should take medication with custom date', () async {
      final manager = MedicationIntakeManager(
          mockMedicationIntakeProvider, mockSupplyItemProvider);
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

      late MedicationIntake updatedIntake;
      when(mockMedicationIntakeProvider.updateIntake(any)).thenAnswer((inv) {
        updatedIntake = inv.positionalArguments.first as MedicationIntake;
        return Future.value();
      });

      final customDate = DateTime.now().add(Duration(days: 1));

      await manager.takeMedication(intake, supplyItem, takenDate: customDate);

      expect(updatedIntake.isTaken, true);
      expect(updatedIntake.takenDateTime, customDate);
      verify(mockMedicationIntakeProvider.updateIntake(updatedIntake))
          .called(1);
    });

    test('should handle case when not enough medication is remaining',
        () async {
      final manager = MedicationIntakeManager(
          mockMedicationIntakeProvider, mockSupplyItemProvider);
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

      late MedicationIntake updatedIntake;
      when(mockMedicationIntakeProvider.updateIntake(any)).thenAnswer((inv) {
        updatedIntake = inv.positionalArguments.first as MedicationIntake;
        return Future.value();
      });

      Decimal remainingDose = Decimal.parse('1'); // 1mg remaining in the supply
      Decimal doseToAdd =
          Decimal.parse('14'); // 14mg to be added in a new intake

      when(mockMedicationIntakeProvider.addIntake(
              intake.scheduledDateTime, any))
          .thenAnswer((_) async {});

      await manager.takeMedication(intake, supplyItem);

      expect(updatedIntake.dose, remainingDose);

      verify(mockMedicationIntakeProvider.addIntake(
        intake.scheduledDateTime,
        doseToAdd,
      )).called(1);

      verify(mockMedicationIntakeProvider.updateIntake(updatedIntake))
          .called(1);
      expect(updatedIntake.isTaken, true);
    });

    test('takeMedicationSimple consumes dose from single supply item',
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

      await manager.takeMedicationSimple(intake, supplyItem);

      expect(addedIntake.isTaken, true);
      verify(mockMedicationIntakeProvider.add(addedIntake)).called(1);
      verify(mockSupplyItemProvider.updateItem(
        supplyItem.copyWith(usedDose: supplyItem.usedDose + intake.dose),
      )).called(1);
    });

    test('takeMedicationSimple respects custom taken date', () async {
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

      await manager.takeMedicationSimple(intake, supplyItem,
          takenDate: customDate);

      expect(addedIntake.takenDateTime, customDate);
      verify(mockMedicationIntakeProvider.add(addedIntake)).called(1);
      verify(mockSupplyItemProvider.updateItem(
        supplyItem.copyWith(usedDose: supplyItem.usedDose + intake.dose),
      )).called(1);
    });

    test(
        'takeMedicationSimple throws when supply does not have enough remaining',
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

      when(mockMedicationIntakeProvider.add(any)).thenAnswer((_) async {});

      expect(() async => await manager.takeMedicationSimple(intake, supplyItem),
          throwsArgumentError);

      verifyNever(mockSupplyItemProvider.updateItem(any));
    });
  });
}
