import 'package:mona/services/db/upgrade/db_upgrade.dart';
import 'package:sqflite/sqlite_api.dart';

class DbUpgradeV3 implements DbUpgrade {

  @override
  Future<void> upgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute(
        "ALTER TABLE medication_schedules ADD COLUMN notificationTimes TEXT NOT NULL DEFAULT '[]'"
    );
  }

}