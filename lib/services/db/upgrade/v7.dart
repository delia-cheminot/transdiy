import 'package:mona/services/db/upgrade/db_upgrade.dart';
import 'package:sqflite/sqlite_api.dart';

class DbUpgradeV7 implements DbUpgrade {
  @override
  Future<void> upgrade(Database db, int oldVersion, int newVersion) async {
    await _addnotes(db);
  }

  Future<void> _addnotes(Database db) async {
    await db.execute('ALTER TABLE medication_intakes ADD COLUMN notes TEXT');
  }
}
