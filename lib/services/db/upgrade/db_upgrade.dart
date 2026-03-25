import 'package:sqflite/sqlite_api.dart';

abstract class DbUpgrade {
  Future<void> upgrade(Database db, int oldVersion, int newVersion);
}