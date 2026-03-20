import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:mona/services/app_database.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqflite.dart';

class BackupService {
  Future<String?> exportData() async {
    final db = await AppDatabase.getInstance().database;

    final packageInfo = await PackageInfo.fromPlatform();
    final appVersion = packageInfo.version;
    final dbVersion = await db.getVersion();

    final intakes = await db.query('medication_intakes');
    final schedules = await db.query('medication_schedules');
    final supplies = await db.query('supply_items');

    final backupData = {
      'metadata': {
        'app_version': appVersion,
        'database_version': dbVersion,
        'export_date': DateTime.now().toIso8601String(),
      },
      'medication_intakes': intakes,
      'medication_schedules': schedules,
      'supply_items': supplies,
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(backupData);

    final bytes = Uint8List.fromList(utf8.encode(jsonString));

    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Mona Backup',
      fileName: 'mona_backup.json',
      type: FileType.custom,
      allowedExtensions: ['json'],
      bytes: bytes,
    );

    if (outputFile != null) {
      if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
        if (!outputFile.endsWith('.json')) {
          outputFile += '.json';
        }
        final file = File(outputFile);
        await file.writeAsString(jsonString);
      }
      return outputFile;
    }

    return null;
  }

  Future<bool> importData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final jsonString = await file.readAsString();
      final Map<String, dynamic> backupData = jsonDecode(jsonString);

      final db = await AppDatabase.getInstance().database;

      await db.transaction((txn) async {
        await txn.delete('medication_intakes');
        await txn.delete('medication_schedules');
        await txn.delete('supply_items');

        if (backupData.containsKey('medication_intakes')) {
          for (var item in backupData['medication_intakes']) {
            await txn.insert(
                'medication_intakes', Map<String, dynamic>.from(item));
          }
        }
        if (backupData.containsKey('medication_schedules')) {
          for (var item in backupData['medication_schedules']) {
            await txn.insert(
                'medication_schedules', Map<String, dynamic>.from(item));
          }
        }
        if (backupData.containsKey('supply_items')) {
          for (var item in backupData['supply_items']) {
            await txn.insert('supply_items', Map<String, dynamic>.from(item));
          }
        }
      });
      return true;
    }
    return false;
  }
}
