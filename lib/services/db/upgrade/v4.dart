import 'package:mona/services/db/upgrade/db_upgrade.dart';
import 'package:sqflite/sqlite_api.dart';

class DbUpgradeV4 implements DbUpgrade {

  @override
  Future<void> upgrade(Database db, int oldVersion, int newVersion) async {
    _upgradeMedicationIntakes(db);
  }

  Future<void> _upgradeMedicationIntakes(Database db) async {
    await db.execute('''
      CREATE TABLE medication_intakes_new (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        scheduledDateTime TEXT NOT NULL,
        takenDateTime TEXT,
        dose TEXT NOT NULL,
        scheduleId INTEGER,
        side TEXT,
        moleculeJson TEXT NOT NULL,
        administrationRouteName TEXT NOT NULL,
        esterName TEXT,
        supplyItemId INTEGER,
        FOREIGN KEY (supplyItemId) REFERENCES supply_items(id) ON DELETE SET NULL
      );
      ''');

    await db.execute('''
      INSERT INTO medication_intakes_new (
        id, scheduledDateTime, takenDateTime, dose,
        scheduleId, side, moleculeJson,
        administrationRouteName, esterName, supplyItemId
      )
      SELECT
        id, scheduledDateTime, takenDateTime, dose,
        scheduleId, side, moleculeJson,
        administrationRouteName, esterName,
        null
      FROM medication_intakes
      ''');

    await db.execute('DROP TABLE medication_intakes');
    await db.execute(
        'ALTER TABLE medication_intakes_new RENAME TO medication_intakes');
  }

}