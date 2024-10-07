import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:transdiy/medication_intake/medication_intake.dart';
import 'package:transdiy/medication_intake/medication_intake_manager.dart';
import 'package:transdiy/supply_item/supply_item.dart';
import 'mocks.mocks.dart';

void main() {
  late MedicationIntakeManager manager;
  late MockMedicationIntakeState mockMedicationIntakeState;
  late MockSupplyItemManager mockSupplyItemManager;

  setUp(() {
    mockMedicationIntakeState = MockMedicationIntakeState();
    mockSupplyItemManager = MockSupplyItemManager();
    manager = MedicationIntakeManager(mockMedicationIntakeState);
  });

  group('MedicationIntakeManager', () {
    test('should take medication correctly', () async {
      final intake = MedicationIntake(
        id: 1,
        scheduledDateTime: DateTime.now(),
        quantity: 1.0,
      );

      final supplyItem = SupplyItem(
        id: 1,
        name: 'TestSupply',
        volume: 10.0,
        usedVolume: 2.0,
        quantity: 1,
        concentration: 5.0,
      );

      final volumeToUse = intake.quantity / supplyItem.concentration;

      await manager.takeMedication(intake, supplyItem, mockSupplyItemManager);

      expect(intake.isTaken, true);
      verify(mockMedicationIntakeState.updateIntake(intake)).called(1);
      verify(mockSupplyItemManager.useVolume(supplyItem, volumeToUse)).called(1);
    });

    test('should throw ArgumentError when taking medication already taken', () async {
      final intake = MedicationIntake(
        id: 1,
        scheduledDateTime: DateTime.now(),
        takenDateTime: DateTime.now(),
        quantity: 1.0,
      );

      final supplyItem = SupplyItem(
        id: 1,
        name: 'TestSupply',
        volume: 10.0,
        usedVolume: 2.0,
        quantity: 1,
        concentration: 5.0,
      );

      expect(
        () async => await manager.takeMedication(intake, supplyItem, mockSupplyItemManager), 
        throwsArgumentError
      );
    });

    test('should take medication with custom date', () async {
      final intake = MedicationIntake(
        id: 1,
        scheduledDateTime: DateTime.now(),
        quantity: 1.0,
      );

      final supplyItem = SupplyItem(
        id: 1,
        name: 'TestSupply',
        volume: 10.0,
        usedVolume: 2.0,
        quantity: 1,
        concentration: 5.0,
      );

      final customDate = DateTime.now().add(Duration(days: 1));

      await manager.takeMedication(intake, supplyItem, mockSupplyItemManager, takenDate: customDate);

      expect(intake.isTaken, true);
      expect(intake.takenDateTime, customDate);
      verify(mockMedicationIntakeState.updateIntake(intake)).called(1);
    });

    test('should handle case when not enough medication is remaining', () async {
      final intake = MedicationIntake(
        id: 1,
        scheduledDateTime: DateTime.now(),
        quantity: 15.0,
      );

      final supplyItem = SupplyItem(
        id: 1,
        name: 'TestSupply',
        volume: 10.0,
        usedVolume: 9.0,
        quantity: 1,
        concentration: 1.0,
      );

      double remainingQuantity = 1.0; // 1mg remaining in the supply
      double quantityToAdd = 14.0; // 14mg to be added in a new intake

      when(mockMedicationIntakeState.addIntake(intake.scheduledDateTime, any))
          .thenAnswer((_) async {});

      await manager.takeMedication(intake, supplyItem, mockSupplyItemManager);

      expect(intake.quantity, remainingQuantity);

      verify(mockMedicationIntakeState.addIntake(
        intake.scheduledDateTime,
        quantityToAdd,
      )).called(1);

      verify(mockSupplyItemManager.useVolume(supplyItem, supplyItem.volume - supplyItem.usedVolume)).called(1);
      expect(intake.isTaken, true);
    });
  });
}