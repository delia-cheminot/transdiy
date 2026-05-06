import 'package:mona/services/db/upgrade/db_upgrade.dart';
import 'package:sqflite/sqflite.dart';

class DbUpgradeV7 implements DbUpgrade {
  @override
  Future<void> upgrade(Database db, int oldVersion, int newVersion) async {
    await _upgradeBloodTest(db);
  }

  Future<void> _upgradeBloodTest(Database db) async {
    // add blood test units
    await db.execute('ALTER TABLE blood_tests ADD COLUMN estradiolUnit TEXT');
    await db
        .execute('ALTER TABLE blood_tests ADD COLUMN testosteroneUnit TEXT');
    // assume existing entries use pg/mL & ng/dL
    await db.execute(
        "UPDATE blood_tests SET estradiolUnit = 'pg/mL', testosteroneUnit = 'ng/dL'");
  }
}
