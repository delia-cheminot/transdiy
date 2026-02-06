import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService extends ChangeNotifier {
  static const _notificationHourKey = 'notification_hour';
  static const _notificationMinuteKey = 'notification_minute';
  static const _notificationsEnabledKey = 'notifications_enabled';

  static const int defaultHour = 18;
  static const int defaultMinute = 0;
  static const bool defaultNotificationsEnabled = true;

  late SharedPreferences _prefs;

  PreferencesService._(this._prefs);

  static Future<PreferencesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService._(prefs);
  }

  TimeOfDay get notificationTime => TimeOfDay(
        hour: _prefs.getInt(_notificationHourKey) ?? defaultHour,
        minute: _prefs.getInt(_notificationMinuteKey) ?? defaultMinute,
      );
  bool get notificationsEnabled =>
      _prefs.getBool(_notificationsEnabledKey) ?? defaultNotificationsEnabled;

  Future<void> setNotificationHour(int hour) async {
    await _prefs.setInt(_notificationHourKey, hour);
    notifyListeners();
  }

  Future<void> setNotificationMinute(int minute) async {
    await _prefs.setInt(_notificationMinuteKey, minute);
    notifyListeners();
  }

  Future<void> setNotificationTime(TimeOfDay time) async {
    await setNotificationHour(time.hour);
    await setNotificationMinute(time.minute);
  }

  Future<void> setNotificationsEnabled(bool isEnabled) async {
    await _prefs.setBool(_notificationsEnabledKey, isEnabled);
    notifyListeners();
  }
}
