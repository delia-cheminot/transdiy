import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:mona/services/app_database.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqflite.dart';

class BackupService {
  bool get isDesktop =>
      Platform.isLinux || Platform.isWindows || Platform.isMacOS;

  static const _tables = [
    'medication_intakes',
    'medication_schedules',
    'supply_items',
  ];

  Future<String?> exportData() async {
    final db = await AppDatabase.getInstance().database;

    final packageInfo = await PackageInfo.fromPlatform();
    final appVersion = packageInfo.version;
    final dbVersion = await db.getVersion();

    final data = {
      for (final table in _tables) table: await db.query(table),
    };

    final backupData = {
      'metadata': {
        'app_version': appVersion,
        'database_version': dbVersion,
        'export_date': DateTime.now().toIso8601String(),
      },
      'data': data
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
      if (isDesktop) {
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

  void _validateBackup(Map<String, dynamic> backupData) {
    if (!backupData.containsKey('metadata')) {
      throw const FormatException('Invalid backup: missing metadata');
    }

    if (!backupData.containsKey('data') || backupData['data'] is! Map) {
      throw const FormatException(
          'Invalid backup: missing or invalid data object');
    }

    final dataSection = backupData['data'] as Map<String, dynamic>;

    for (final table in _tables) {
      if (dataSection.containsKey(table) &&
          dataSection[table] != null &&
          dataSection[table] is! List) {
        throw FormatException('Invalid backup: $table must be a list');
      }
    }
  }

  Future<bool> importData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      try {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final Map<String, dynamic> backupData = jsonDecode(jsonString);

        _validateBackup(backupData);

        final dataSection = backupData['data'] as Map<String, dynamic>;

        final db = await AppDatabase.getInstance().database;

        await db.transaction((txn) async {
          for (final table in _tables) {
            await txn.delete(table);
          }

          for (final table in _tables) {
            if (dataSection.containsKey(table) && dataSection[table] != null) {
              for (final item in dataSection[table]) {
                await txn.insert(table, Map<String, dynamic>.from(item));
              }
            }
          }
        });
        return true;
      } catch (e) {
        print('Backup import failed: $e');
        return false;
      }
    }
    return false;
  }
}
