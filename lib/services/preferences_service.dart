import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mona/data/model/molecule.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService extends ChangeNotifier {
  static const _notificationsEnabledKey = 'notifications_enabled';
  static const _customMoleculesKey = 'custom_molecules';
  static const _languageTagKey = 'language_tag';

  static const bool defaultNotificationsEnabled = false;
  static const String defaultLanguageCode = 'en';

  static const _autoCheckUpdatesKey = 'auto_check_updates';
  static const bool defaultAutoCheckUpdates = false;

  late final SharedPreferences _prefs;

  PreferencesService._(this._prefs);

  bool get autoCheckUpdatesEnabled =>
      _prefs.getBool(_autoCheckUpdatesKey) ?? defaultAutoCheckUpdates;

  Future<void> setAutoCheckUpdatesEnabled(bool isEnabled) async {
    await _prefs.setBool(_autoCheckUpdatesKey, isEnabled);
    notifyListeners();
  }

  bool get notificationsEnabled =>
      _prefs.getBool(_notificationsEnabledKey) ?? defaultNotificationsEnabled;

  String get languageTag =>
      _prefs.getString(_languageTagKey) ?? defaultLanguageCode;

  Future<void> setNotificationsEnabled(bool isEnabled) async {
    await _prefs.setBool(_notificationsEnabledKey, isEnabled);
    notifyListeners();
  }

  Future<void> setLanguageTag(String code) async {
    await _prefs.setString(_languageTagKey, code);
    notifyListeners();
  }

  List<Molecule> get customMolecules {
    final jsonString = _prefs.getString(_customMoleculesKey);
    if (jsonString == null) return [];

    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded
        .map((e) => Molecule.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  List<Molecule> get allMolecules {
    const builtIn = KnownMolecules.all;
    final custom = customMolecules;
    final Map<String, Molecule> map = {};

    for (final m in [...builtIn, ...custom]) {
      map[m.normalizedName] = m; // remove duplicates
    }

    return map.values.toList();
  }

  List<DropdownMenuItem<Molecule>> moleculeDropdownItems(
          AppLocalizations localizations) =>
      allMolecules
          .map(
            (molecule) => DropdownMenuItem<Molecule>(
              value: molecule,
              child: Text(molecule.localizedName(localizations)),
            ),
          )
          .toList();

  Future<void> addCustomMolecule(Molecule molecule) async {
    final existing = customMolecules;

    if (allMolecules.any((m) => m.normalizedName == molecule.normalizedName)) {
      return;
    }

    final updated = [...existing, molecule];
    final jsonString = jsonEncode(updated.map((m) => m.toJson()).toList());

    await _prefs.setString(_customMoleculesKey, jsonString);
    notifyListeners();
  }

  Future<void> removeCustomMolecule(String name) async {
    final updated = customMolecules
        .where((m) => m.normalizedName != name.trim().toLowerCase())
        .toList();

    final jsonString = jsonEncode(updated.map((m) => m.toJson()).toList());

    await _prefs.setString(_customMoleculesKey, jsonString);
    notifyListeners();
  }

  bool get shouldShowScheduleDialog =>
      _prefs.getBool('show_schedule_dialog') ?? true;

  Future<void> setShowScheduleDialog(bool value) {
    return _prefs.setBool('show_schedule_dialog', value);
  }

  static Future<PreferencesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService._(prefs);
  }
}
