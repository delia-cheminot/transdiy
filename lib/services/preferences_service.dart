import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _notificationHourKey = 'notification_hour';
  static const _notificationMinuteKey = 'notification_minute';

  static const int defaultHour = 18;
  static const int defaultMinute = 0;

  late SharedPreferences _prefs;

  PreferencesService._(this._prefs);

  static Future<PreferencesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService._(prefs);
  }

  int get notificationHour =>
      _prefs.getInt(_notificationHourKey) ?? defaultHour;
  int get notificationMinute =>
      _prefs.getInt(_notificationMinuteKey) ?? defaultMinute;

  Future<void> setNotificationHour(int hour) async =>
      await _prefs.setInt(_notificationHourKey, hour);

  Future<void> setNotificationMinute(int minute) async =>
      await _prefs.setInt(_notificationMinuteKey, minute);
}
