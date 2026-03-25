import 'package:mona/services/db/upgrade/db_upgrade.dart';
import 'package:sqflite/sqlite_api.dart';

class DbUpgradeV2 implements DbUpgrade {

  @override
  Future<void> upgrade(Database db, int oldVersion, int newVersion) async {

    // medication_schedules migration
    _upgradeMedicationSchedules(db);

    // supply_items migration
    _upgradeSupplyItems(db);

    // medication_intakes migration
    _upgradeMedicationIntakes(db);

  }

  Future<void> _upgradeMedicationSchedules(Database db) async {
    await db.execute('''
      CREATE TABLE medication_schedules_new(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dose TEXT NOT NULL,
        intervalDays INTEGER NOT NULL,
        startDate TEXT NOT NULL,
        moleculeJson TEXT NOT NULL,
        administrationRouteName TEXT NOT NULL,
        esterName TEXT
      )
      ''');

    await db.execute('''
      INSERT INTO medication_schedules_new (
        id, name, dose, intervalDays, startDate,
        moleculeJson, administrationRouteName, esterName
      )
      SELECT
        id, name, dose, intervalDays, startDate,
        '{"name":"estradiol","unit":"mg"}',
        'injection',
        'enanthate'
      FROM medication_schedules
      ''');

    await db.execute('DROP TABLE medication_schedules');
    await db.execute(
        'ALTER TABLE medication_schedules_new RENAME TO medication_schedules');
  }

  Future<void> _upgradeSupplyItems(Database db) async {
    await db.execute('''
      CREATE TABLE supply_items_new(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        totalDose TEXT NOT NULL,
        usedDose TEXT NOT NULL,
        concentration TEXT NOT NULL,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        moleculeJson TEXT NOT NULL,
        administrationRouteName TEXT NOT NULL,
        esterName TEXT
      )
      ''');

    await db.execute('''
      INSERT INTO supply_items_new (
        id, totalDose, usedDose, concentration, name, quantity,
        moleculeJson, administrationRouteName, esterName
      )
      SELECT
        id, totalDose, usedDose, dosePerUnit, name, quantity,
        '{"name":"estradiol","unit":"mg"}',
        'injection',
        'enanthate'
      FROM supply_items
      ''');

    await db.execute('DROP TABLE supply_items');
    await db.execute('ALTER TABLE supply_items_new RENAME TO supply_items');
  }

  Future<void> _upgradeMedicationIntakes(Database db) async {
    await db.execute('''
      CREATE TABLE medication_intakes_new(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        scheduledDateTime TEXT NOT NULL,
        takenDateTime TEXT,
        dose TEXT NOT NULL,
        scheduleId INTEGER,
        side TEXT,
        moleculeJson TEXT NOT NULL,
        administrationRouteName TEXT NOT NULL,
        esterName TEXT
      )
      ''');

    await db.execute('''
      INSERT INTO medication_intakes_new (
        id, scheduledDateTime, takenDateTime, dose,
        scheduleId, side, moleculeJson,
        administrationRouteName, esterName
      )
      SELECT
        id, scheduledDateTime, takenDateTime, dose,
        scheduleId, side,
        '{"name":"estradiol","unit":"mg"}',
        'injection',
        'enanthate'
      FROM medication_intakes
      ''');

    await db.execute('DROP TABLE medication_intakes');
    await db.execute(
        'ALTER TABLE medication_intakes_new RENAME TO medication_intakes');
  }
}