import 'package:sqflite/sqflite.dart';
import '../services/app_database.dart';
import 'medication_schedule.dart';

class MedicationScheduleRepository {
  /// Inserts a new [MedicationSchedule] into the database.
  /// Returns the id of the newly inserted schedule.
  static Future<int> insertSchedule(MedicationSchedule schedule) async {
    final db = await AppDatabase.instance.database;
    return await db.insert(
      'medication_schedules',
      schedule.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<MedicationSchedule>> getSchedules() async {
    final db = await AppDatabase.instance.database;
    final List<Map<String, Object?>> scheduleMap =
        await db.query('medication_schedules');
    return scheduleMap.map((e) => MedicationSchedule.fromMap(e)).toList();
  }

  static Future<void> updateSchedule(MedicationSchedule schedule) async {
    assert(schedule.id != null);
    final db = await AppDatabase.instance.database;
    await db.update(
      'medication_schedules',
      schedule.toMap(),
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  static Future<void> deleteScheduleFromId(int id) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      'medication_schedules',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteSchedule(MedicationSchedule schedule) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      'medication_schedules',
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }
}
