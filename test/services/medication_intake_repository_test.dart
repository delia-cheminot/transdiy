import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:transdiy/data/model/medication_intake.dart';
import 'package:transdiy/data/repositories/medication_intake_repository.dart';
import 'package:transdiy/services/app_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Initialize sqflite_common_ffi
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Database tests', () {
    setUp(() async {
      // Initialize the AppDatabase instance and clean the database before each test
      final db = await AppDatabase.instance.database;
      await db.delete('medication_intakes');
    });

    tearDownAll(() async {
      // Close the database after all tests
      await AppDatabase.instance.close();
    });

    test('Database is created', () async {
      // Initialize the database
      final db = await AppDatabase.instance.database;

      // Check that the database path is correct
      final dbPath = await getDatabasesPath();
      final expectedPath = join(dbPath, 'app_database.db');
      expect(db.path, expectedPath);

      // Check that the database is open
      expect(db.isOpen, true);
    });

    test('Insert and retrieve a MedicationIntake', () async {
      final intake = MedicationIntake(
          scheduledDateTime: DateTime.now(), dose: Decimal.parse('1'));
      int insertedId = await MedicationIntakeRepository.insertIntake(intake);
      final intakes = await MedicationIntakeRepository.getIntakes();
      expect(intakes.length, 1);
      expect(intakes[0].id, insertedId);
    });

    test('Update a MedicationIntake', () async {
      DateTime firstDateTime = DateTime.now();
      DateTime secondDateTime = firstDateTime.add(Duration(days: 1));
      final intake = MedicationIntake(
          scheduledDateTime: firstDateTime, dose: Decimal.parse('1'));
      int insertedId = await MedicationIntakeRepository.insertIntake(intake);
      final updatedIntake = MedicationIntake(
        id: insertedId,
        scheduledDateTime: firstDateTime,
        takenDateTime: secondDateTime,
        dose: Decimal.parse('1'),
      );
      await MedicationIntakeRepository.updateIntake(updatedIntake);
      final intakes = await MedicationIntakeRepository.getIntakes();
      expect(intakes.length, 1);
      expect(intakes[0].takenDateTime, secondDateTime);
      // Check that the intake is now taken
      expect(intakes[0].isTaken, true);
    });

    test('Delete a MedicationIntake', () async {
      final intake = MedicationIntake(
          scheduledDateTime: DateTime.now(), dose: Decimal.parse('1'));
      int insertedId = await MedicationIntakeRepository.insertIntake(intake);
      await MedicationIntakeRepository.deleteIntakeFromId(insertedId);
      final intakesAfterDelete = await MedicationIntakeRepository.getIntakes();
      expect(intakesAfterDelete.length, 0);
    });

    test('Only delete the specified MedicationIntake', () async {
      final intake1 = MedicationIntake(
          scheduledDateTime: DateTime.now(), dose: Decimal.parse('1'));
      final intake2 = MedicationIntake(
          scheduledDateTime: DateTime.now(), dose: Decimal.parse('1'));
      int insertedId1 = await MedicationIntakeRepository.insertIntake(intake1);
      int insertedId2 = await MedicationIntakeRepository.insertIntake(intake2);
      await MedicationIntakeRepository.deleteIntakeFromId(insertedId1);
      final intakesAfterDelete = await MedicationIntakeRepository.getIntakes();
      expect(intakesAfterDelete.length, 1);
      expect(intakesAfterDelete[0].id, insertedId2);
    });
  });
}
