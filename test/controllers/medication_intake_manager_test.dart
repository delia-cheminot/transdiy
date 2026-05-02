import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mona/controllers/medication_intake_manager.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/data/model/generic_supply_item.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/model/medication_supply_item.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/supply_item_provider.dart';

@GenerateNiceMocks([
  MockSpec<MedicationIntakeProvider>(),
  MockSpec<SupplyItemProvider>(),
])
import 'medication_intake_manager_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('flutter_timezone'),
    (MethodCall call) async {
      if (call.method == 'getLocalTimezone') return 'UTC';
      return null;
    },
  );

  late MockMedicationIntakeProvider mockMedicationIntakeProvider;
  late MockSupplyItemProvider mockSupplyItemProvider;
  late MedicationIntakeManager manager;

  setUp(() {
    mockMedicationIntakeProvider = MockMedicationIntakeProvider();
    mockSupplyItemProvider = MockSupplyItemProvider();
    manager = MedicationIntakeManager(
        mockMedicationIntakeProvider, mockSupplyItemProvider);
  });

  group('MedicationIntakeManager', () {
    group('takeMedication', () {
      group('takenDateTime validation', () {
        final localDate = DateTime(2025, 9, 14, 12, 0);

        test('throws ArgumentError when takenDateTime is not UTC', () async {
          // Arrange
          final schedule = _buildSchedule();

          // Act / Assert
          await expectLater(
            manager.takeMedication(
              dose: Decimal.parse('2'),
              scheduledDateTime: localDate,
              takenDateTime: localDate,
              schedule: schedule,
            ),
            throwsArgumentError,
          );
        });

        test('does not add an intake when takenDateTime is not UTC', () async {
          // Arrange
          final schedule = _buildSchedule();

          // Act
          try {
            await manager.takeMedication(
              dose: Decimal.parse('2'),
              scheduledDateTime: localDate,
              takenDateTime: localDate,
              schedule: schedule,
            );
          } on ArgumentError {/* swallowed */}

          // Assert
          verifyNever(mockMedicationIntakeProvider.add(any));
        });

        test('does not update the supply item when takenDateTime is not UTC',
            () async {
          // Arrange
          final schedule = _buildSchedule();
          final supplyItem = _buildMedicationSupplyItem();

          // Act
          try {
            await manager.takeMedication(
              dose: Decimal.parse('2'),
              scheduledDateTime: localDate,
              takenDateTime: localDate,
              schedule: schedule,
              supplyItem: supplyItem,
            );
          } on ArgumentError {/* swallowed */}

          // Assert
          verifyNever(mockSupplyItemProvider.updateItem(any));
        });
      });

      group('MedicationIntake creation', () {
        late MedicationIntake addedIntake;
        final dose = Decimal.parse('3');
        final scheduledDate = DateTime(2025, 9, 14, 10, 30);
        final takenDate = DateTime.utc(2025, 9, 14, 12, 0);

        setUp(() async {
          // Arrange
          final supplyItem = _buildMedicationSupplyItem(
            id: 99,
            administrationRoute: AdministrationRoute.injection,
            ester: Ester.enanthate,
          );
          final schedule = _buildSchedule(
            id: 42,
            dose: dose,
            administrationRoute: AdministrationRoute.injection,
            ester: Ester.enanthate,
          );

          when(mockMedicationIntakeProvider.add(any)).thenAnswer((inv) async {
            addedIntake = inv.positionalArguments.first as MedicationIntake;
          });

          // Act
          await manager.takeMedication(
            dose: dose,
            scheduledDateTime: scheduledDate,
            takenDateTime: takenDate,
            supplyItem: supplyItem,
            schedule: schedule,
            side: InjectionSide.right,
          );
        });

        test('marks the intake as taken', () {
          // Assert
          expect(addedIntake.isTaken, isTrue);
        });

        test('propagates dose to the intake', () {
          // Assert
          expect(addedIntake.dose, dose);
        });

        test('propagates scheduledDateTime to the intake', () {
          // Assert
          expect(addedIntake.scheduledDateTime, scheduledDate);
        });

        test('propagates takenDateTime to the intake', () {
          // Assert
          expect(addedIntake.takenDateTime, takenDate);
        });

        test('sets takenTimeZone from the local timezone', () {
          // Assert
          expect(addedIntake.takenTimeZone, 'UTC');
        });

        test('propagates side to the intake', () {
          // Assert
          expect(addedIntake.side, InjectionSide.right);
        });

        test('propagates scheduleId from the schedule', () {
          // Assert
          expect(addedIntake.scheduleId, 42);
        });

        test('propagates molecule from the schedule', () {
          // Assert
          expect(addedIntake.molecule, KnownMolecules.estradiol);
        });

        test('propagates administrationRoute from the schedule', () {
          // Assert
          expect(
              addedIntake.administrationRoute, AdministrationRoute.injection);
        });

        test('propagates ester from the schedule', () {
          // Assert
          expect(addedIntake.ester, Ester.enanthate);
        });

        test('sets supplyItemId from the supplyItem', () {
          // Assert
          expect(addedIntake.supplyItemId, 99);
        });
      });

      group('null supplyItem', () {
        late MedicationIntake addedIntake;

        setUp(() async {
          // Arrange
          final schedule = _buildSchedule();
          final date = DateTime.utc(2025, 9, 14, 12, 0);

          when(mockMedicationIntakeProvider.add(any)).thenAnswer((inv) async {
            addedIntake = inv.positionalArguments.first as MedicationIntake;
          });

          // Act
          await manager.takeMedication(
            dose: Decimal.parse('2'),
            scheduledDateTime: date,
            takenDateTime: date,
            supplyItem: null,
            schedule: schedule,
          );
        });

        test('sets supplyItemId on the intake to null', () {
          // Assert
          expect(addedIntake.supplyItemId, isNull);
        });

        test('does not call the supply provider', () {
          // Assert
          verifyNever(mockSupplyItemProvider.updateItem(any));
        });
      });

      group('GenericSupply', () {
        late MedicationIntake addedIntake;
        late GenericSupply updatedSupplyItem;
        final supplyItem = _buildGenericSupply(id: 7, amount: 5);

        setUp(() async {
          // Arrange
          final schedule = _buildSchedule(
            administrationRoute: AdministrationRoute.injection,
          );
          final date = DateTime.utc(2025, 9, 14, 12, 0);

          when(mockMedicationIntakeProvider.add(any)).thenAnswer((inv) async {
            addedIntake = inv.positionalArguments.first as MedicationIntake;
          });
          when(mockSupplyItemProvider.updateItem(any)).thenAnswer((inv) async {
            updatedSupplyItem = inv.positionalArguments.first as GenericSupply;
          });

          // Act
          await manager.takeMedication(
            dose: Decimal.parse('2'),
            scheduledDateTime: date,
            takenDateTime: date,
            supplyItem: supplyItem,
            schedule: schedule,
            deadSpace: Decimal.parse('100'),
          );
        });

        test('decrements amount by 1', () {
          // Assert
          expect(updatedSupplyItem.amount, supplyItem.amount - 1);
        });

        test('sets supplyItemId on the intake', () {
          // Assert
          expect(addedIntake.supplyItemId, supplyItem.id);
        });
      });

      group('MedicationSupplyItem', () {
        group('with no deadSpace', () {
          late MedicationSupplyItem updatedSupplyItem;
          final supplyItem = _buildMedicationSupplyItem(
            usedDose: Decimal.parse('1'),
            concentration: Decimal.parse('1'),
          );
          final dose = Decimal.parse('2');

          setUp(() async {
            // Arrange
            final schedule = _buildSchedule(dose: dose);
            final date = DateTime.utc(2025, 9, 14, 12, 0);

            when(mockSupplyItemProvider.updateItem(any))
                .thenAnswer((inv) async {
              updatedSupplyItem =
                  inv.positionalArguments.first as MedicationSupplyItem;
            });

            // Act
            await manager.takeMedication(
              dose: dose,
              scheduledDateTime: date,
              takenDateTime: date,
              supplyItem: supplyItem,
              schedule: schedule,
            );
          });

          test('increases usedDose by the given dose', () {
            // Assert
            expect(updatedSupplyItem.usedDose, supplyItem.usedDose + dose);
          });
        });

        group('with deadSpace > 0', () {
          late MedicationIntake addedIntake;
          late MedicationSupplyItem updatedSupplyItem;
          final supplyItem = _buildMedicationSupplyItem(
            usedDose: Decimal.parse('1'),
            concentration: Decimal.parse('10'),
          );
          final dose = Decimal.parse('2');
          // 100 μL × 0.001 mL/μL × concentration 10 = 1 extra dose unit.
          final deadSpace = Decimal.parse('100');
          final expectedExtra = Decimal.parse('1');

          setUp(() async {
            // Arrange
            final schedule = _buildSchedule(dose: dose);
            final date = DateTime.utc(2025, 9, 14, 12, 0);

            when(mockMedicationIntakeProvider.add(any)).thenAnswer((inv) async {
              addedIntake = inv.positionalArguments.first as MedicationIntake;
            });
            when(mockSupplyItemProvider.updateItem(any))
                .thenAnswer((inv) async {
              updatedSupplyItem =
                  inv.positionalArguments.first as MedicationSupplyItem;
            });

            // Act
            await manager.takeMedication(
              dose: dose,
              scheduledDateTime: date,
              takenDateTime: date,
              supplyItem: supplyItem,
              schedule: schedule,
              deadSpace: deadSpace,
            );
          });

          test('adds the deadSpace dose to usedDose', () {
            // Assert
            expect(
              updatedSupplyItem.usedDose,
              supplyItem.usedDose + dose + expectedExtra,
            );
          });

          test('records the original dose (without deadSpace) on the intake',
              () {
            // Assert
            expect(addedIntake.dose, dose);
          });
        });

        group('with deadSpace == 0', () {
          late MedicationSupplyItem updatedSupplyItem;
          final supplyItem = _buildMedicationSupplyItem(
            usedDose: Decimal.parse('1'),
            concentration: Decimal.parse('10'),
          );
          final dose = Decimal.parse('2');

          setUp(() async {
            // Arrange
            final schedule = _buildSchedule(dose: dose);
            final date = DateTime.utc(2025, 9, 14, 12, 0);

            when(mockSupplyItemProvider.updateItem(any))
                .thenAnswer((inv) async {
              updatedSupplyItem =
                  inv.positionalArguments.first as MedicationSupplyItem;
            });

            // Act
            await manager.takeMedication(
              dose: dose,
              scheduledDateTime: date,
              takenDateTime: date,
              supplyItem: supplyItem,
              schedule: schedule,
              deadSpace: Decimal.zero,
            );
          });

          test('does not adjust usedDose', () {
            // Assert
            expect(updatedSupplyItem.usedDose, supplyItem.usedDose + dose);
          });
        });
      });
    });

    group('deleteIntake', () {
      group('when supply lookup returns null', () {
        final intake = _buildIntake(supplyItemId: 10);

        setUp(() async {
          // Act
          await manager.deleteIntake(intake);
        });

        test('deletes the intake on the provider', () {
          // Assert
          verify(mockMedicationIntakeProvider.deleteIntake(intake)).called(1);
        });

        test('does not call updateItem', () {
          // Assert
          verifyNever(mockSupplyItemProvider.updateItem(any));
        });
      });

      group('GenericSupply', () {
        late GenericSupply updatedSupplyItem;
        final supplyItem = _buildGenericSupply(id: 7, amount: 5);
        final intake = _buildIntake(supplyItemId: supplyItem.id);

        setUp(() async {
          // Arrange
          when(mockSupplyItemProvider.getItemById(supplyItem.id))
              .thenReturn(supplyItem);
          when(mockSupplyItemProvider.updateItem(any)).thenAnswer((inv) async {
            updatedSupplyItem = inv.positionalArguments.first as GenericSupply;
          });

          // Act
          await manager.deleteIntake(intake);
        });

        test('increments amount by 1', () {
          // Assert
          expect(updatedSupplyItem.amount, supplyItem.amount + 1);
        });

        test('deletes the intake on the provider', () {
          // Assert
          verify(mockMedicationIntakeProvider.deleteIntake(intake)).called(1);
        });
      });

      group('MedicationSupplyItem', () {
        group('when intake.dose is within usedDose', () {
          late MedicationSupplyItem updatedSupplyItem;
          final supplyItem = _buildMedicationSupplyItem(
            usedDose: Decimal.parse('5'),
          );
          final dose = Decimal.parse('2');
          final intake = _buildIntake(supplyItemId: supplyItem.id, dose: dose);

          setUp(() async {
            // Arrange
            when(mockSupplyItemProvider.getItemById(supplyItem.id))
                .thenReturn(supplyItem);
            when(mockSupplyItemProvider.updateItem(any))
                .thenAnswer((inv) async {
              updatedSupplyItem =
                  inv.positionalArguments.first as MedicationSupplyItem;
            });

            // Act
            await manager.deleteIntake(intake);
          });

          test('decreases usedDose by intake.dose', () {
            // Assert
            expect(updatedSupplyItem.usedDose, supplyItem.usedDose - dose);
          });

          test('deletes the intake on the provider', () {
            // Assert
            verify(mockMedicationIntakeProvider.deleteIntake(intake)).called(1);
          });
        });

        group('when intake.dose exceeds usedDose', () {
          late MedicationSupplyItem updatedSupplyItem;
          final supplyItem = _buildMedicationSupplyItem(
            usedDose: Decimal.parse('1'),
          );
          final intake = _buildIntake(
            supplyItemId: supplyItem.id,
            dose: Decimal.parse('5'),
          );

          setUp(() async {
            // Arrange
            when(mockSupplyItemProvider.getItemById(supplyItem.id))
                .thenReturn(supplyItem);
            when(mockSupplyItemProvider.updateItem(any))
                .thenAnswer((inv) async {
              updatedSupplyItem =
                  inv.positionalArguments.first as MedicationSupplyItem;
            });

            // Act
            await manager.deleteIntake(intake);
          });

          test('clamps usedDose to zero', () {
            // Assert
            expect(updatedSupplyItem.usedDose, Decimal.zero);
          });
        });

        group('when intake.dose is zero', () {
          final supplyItem = _buildMedicationSupplyItem(
            usedDose: Decimal.parse('5'),
          );
          final intake = _buildIntake(
            supplyItemId: supplyItem.id,
            dose: Decimal.zero,
          );

          setUp(() async {
            // Arrange
            when(mockSupplyItemProvider.getItemById(supplyItem.id))
                .thenReturn(supplyItem);

            // Act
            await manager.deleteIntake(intake);
          });

          test('does not call updateItem', () {
            // Assert
            verifyNever(mockSupplyItemProvider.updateItem(any));
          });

          test('deletes the intake on the provider', () {
            // Assert
            verify(mockMedicationIntakeProvider.deleteIntake(intake)).called(1);
          });
        });
      });
    });

    group('getNextSide', () {
      test('returns right when last side is left', () {
        // Arrange
        final firstIntake = MedicationIntake(
          id: 1,
          scheduledDateTime: DateTime(2025, 9, 14, 10, 30),
          dose: Decimal.parse('2.5'),
          takenDateTime: DateTime.utc(2025, 9, 14, 12, 0),
          takenTimeZone: 'Etc/UTC',
          scheduleId: 42,
          side: InjectionSide.left,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.gel,
        );
        when(mockMedicationIntakeProvider.getLastTakenIntake())
            .thenReturn(firstIntake);

        // Act
        final InjectionSide nextSide = manager.getNextSide();

        // Assert
        expect(nextSide, InjectionSide.right);
      });

      test('returns left when last side is right', () {
        // Arrange
        final lastIntake = MedicationIntake(
          id: 2,
          scheduledDateTime: DateTime(2025, 9, 15, 10, 30),
          dose: Decimal.parse('2.5'),
          takenDateTime: DateTime.utc(2025, 9, 15, 12, 0),
          takenTimeZone: 'Etc/UTC',
          scheduleId: 42,
          side: InjectionSide.right,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.gel,
        );
        when(mockMedicationIntakeProvider.getLastTakenIntake())
            .thenReturn(lastIntake);

        // Act / Assert
        expect(manager.getNextSide(), InjectionSide.left);
      });

      test('returns left when there is no last intake', () {
        // Arrange
        when(mockMedicationIntakeProvider.getLastTakenIntake())
            .thenReturn(null);

        // Act / Assert
        expect(manager.getNextSide(), InjectionSide.left);
      });

      test('returns left when last intake side is null', () {
        // Arrange
        final intake = MedicationIntake(
          id: 3,
          scheduledDateTime: DateTime(2025, 9, 16, 10, 30),
          dose: Decimal.parse('2.5'),
          takenDateTime: DateTime.utc(2025, 9, 16, 12, 0),
          takenTimeZone: 'Etc/UTC',
          scheduleId: 42,
          side: null,
          molecule: KnownMolecules.estradiol,
          administrationRoute: AdministrationRoute.gel,
        );
        when(mockMedicationIntakeProvider.getLastTakenIntake())
            .thenReturn(intake);

        // Act / Assert
        expect(manager.getNextSide(), InjectionSide.left);
      });
    });
  });
}

MedicationSchedule _buildSchedule({
  int? id,
  Decimal? dose,
  AdministrationRoute administrationRoute = AdministrationRoute.oral,
  Ester? ester,
}) {
  return MedicationSchedule(
    id: id,
    name: 'ScheduleSingle',
    dose: dose ?? Decimal.parse('2'),
    intervalDays: 1,
    molecule: KnownMolecules.estradiol,
    administrationRoute: administrationRoute,
    ester: ester,
    notificationTimes: List.empty(),
  );
}

MedicationSupplyItem _buildMedicationSupplyItem({
  int id = 10,
  Decimal? totalDose,
  Decimal? usedDose,
  Decimal? concentration,
  AdministrationRoute administrationRoute = AdministrationRoute.oral,
  Ester? ester,
}) {
  return MedicationSupplyItem(
    id: id,
    name: 'SupplySingle',
    totalDose: totalDose ?? Decimal.parse('10'),
    usedDose: usedDose ?? Decimal.parse('1'),
    concentration: concentration ?? Decimal.parse('1'),
    molecule: KnownMolecules.estradiol,
    administrationRoute: administrationRoute,
    ester: ester,
  );
}

GenericSupply _buildGenericSupply({
  int id = 7,
  String name = 'Syringe',
  int amount = 5,
}) {
  return GenericSupply(
    id: id,
    name: name,
    amount: amount,
  );
}

MedicationIntake _buildIntake({
  int? id,
  Decimal? dose,
  int? supplyItemId,
}) {
  return MedicationIntake(
    id: id,
    scheduledDateTime: DateTime(2025, 9, 14, 10, 30),
    dose: dose ?? Decimal.parse('2'),
    molecule: KnownMolecules.estradiol,
    administrationRoute: AdministrationRoute.oral,
    supplyItemId: supplyItemId,
  );
}
