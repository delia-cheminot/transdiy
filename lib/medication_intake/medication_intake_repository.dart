import 'package:sqflite/sqflite.dart';
import '../services/app_database.dart';
import 'medication_intake.dart';

class MedicationIntakeRepository {
  /// Inserts a new [MedicationIntake] into the database.
  /// Returns the id of the newly inserted intake.
  static Future<int> insertIntake(MedicationIntake intake) async {
    final db = await AppDatabase.instance.database;
    return await db.insert(
      'medication_intakes',
      intake.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<MedicationIntake>> getIntakes() async {
    final db = await AppDatabase.instance.database;
    final List<Map<String, Object?>> intakeMap =
        await db.query('medication_intakes');
    return intakeMap.map((e) => MedicationIntake.fromMap(e)).toList();
  }

  static Future<void> updateIntake(MedicationIntake intake) async {
    assert(intake.id != null);
    final db = await AppDatabase.instance.database;
    await db.update(
      'medication_intakes',
      intake.toMap(),
      where: 'id = ?',
      whereArgs: [intake.id],
    );
  }

  static Future<void> deleteIntakeFromId(int id) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      'medication_intakes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteIntake(MedicationIntake intake) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      'medication_intakes',
      where: 'id = ?',
      whereArgs: [intake.id],
    );
  }
}