import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('PreferencesService', () {
    group('notificationTime', () {
      test('should return default notification time when not set', () async {
        // Arrange
        final service = await PreferencesService.init();

        // Act
        final time = service.notificationTime;

        // Assert
        expect(time.hour, PreferencesService.defaultHour);
        expect(time.minute, PreferencesService.defaultMinute);
      });

      test('should return saved notification time', () async {
        // Arrange
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('notification_hour', 14);
        await prefs.setInt('notification_minute', 30);
        final service = await PreferencesService.init();

        // Act
        final time = service.notificationTime;

        // Assert
        expect(time.hour, 14);
        expect(time.minute, 30);
      });
    });

    group('notificationsEnabled', () {
      test('should return default notifications enabled state when not set',
          () async {
        // Arrange
        final service = await PreferencesService.init();

        // Act
        final enabled = service.notificationsEnabled;

        // Assert
        expect(enabled, PreferencesService.defaultNotificationsEnabled);
      });

      test('should return saved notifications enabled state', () async {
        // Arrange
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('notifications_enabled', false);
        final service = await PreferencesService.init();

        // Act
        final enabled = service.notificationsEnabled;

        // Assert
        expect(enabled, isFalse);
      });
    });

    group('setNotificationTime', () {
      test('should set both hour and minute', () async {
        // Arrange
        final service = await PreferencesService.init();
        const time = TimeOfDay(hour: 10, minute: 20);

        // Act
        await service.setNotificationTime(time);

        // Assert
        expect(service.notificationTime.hour, 10);
        expect(service.notificationTime.minute, 20);
      });
    });

    group('setNotificationsEnabled', () {
      test('should set notifications enabled and notify listeners', () async {
        // Arrange
        final service = await PreferencesService.init();
        var listenerNotified = false;
        service.addListener(() {
          listenerNotified = true;
        });

        // Act
        await service.setNotificationsEnabled(false);

        // Assert
        expect(service.notificationsEnabled, isFalse);
        expect(listenerNotified, isTrue);
      });
    });
  });
}
