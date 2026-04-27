import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:mona/services/db/app_database.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BackupService {
  bool get isDesktop =>
      Platform.isLinux || Platform.isWindows || Platform.isMacOS;

  static const _tables = [
    'medication_intakes',
    'medication_schedules',
    'supply_items',
    'blood_tests',
  ];

  Future<String> _generateBackupJson() async {
    final db = await AppDatabase.getInstance().database;
    final packageInfo = await PackageInfo.fromPlatform();

    final data = {
      for (final table in _tables) table: await db.query(table),
    };

    final backupData = {
      'metadata': {
        'app_version': packageInfo.version,
        'database_version': await db.getVersion(),
        'export_date': DateTime.now().toIso8601String(),
      },
      'data': data,
    };

    return const JsonEncoder.withIndent('  ').convert(backupData);
  }

  Future<void> _processImport(Map<String, dynamic> backupData) async {
    final db = await AppDatabase.getInstance().database;
    final dataSection = backupData['data'] as Map<String, dynamic>;

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
  }

  Future<bool> _createSafetyBackup() async {
    try {
      final jsonString = await _generateBackupJson();
      final tempDir = await getTemporaryDirectory();

      // Save silently to the app's hidden cache
      final file = File('${tempDir.path}/mona_safety_backup.json');
      await file.writeAsString(jsonString);
      return true;
    } catch (e) {
      print('Safety backup failed: $e');
      return false;
    }
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

  Future<bool> restoreSafetyBackup() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/mona_safety_backup.json');

      if (!await file.exists()) return false;

      final jsonString = await file.readAsString();
      final Map<String, dynamic> backupData = jsonDecode(jsonString);

      _validateBackup(backupData);
      await _processImport(backupData);

      await file.delete();
      return true;
    } catch (e) {
      print('Restore failed: $e');
      return false;
    }
  }

  Future<String?> exportData() async {
    final jsonString = await _generateBackupJson();
    final bytes = Uint8List.fromList(utf8.encode(jsonString));

    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Mona Backup',
      fileName: 'mona_backup.json',
      type: FileType.custom,
      allowedExtensions: ['json'],
      bytes: bytes,
    );

    if (outputFile != null) {
      if (isDesktop && !outputFile.endsWith('.json')) {
        outputFile += '.json';
      }
      if (isDesktop) {
        await File(outputFile).writeAsString(jsonString);
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
      try {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final Map<String, dynamic> backupData = jsonDecode(jsonString);

        _validateBackup(backupData);

        await _createSafetyBackup();

        await _processImport(backupData);

        return true;
      } catch (e) {
        print('Backup import failed: $e');
        return false;
      }
    }
    return false;
  }
}
