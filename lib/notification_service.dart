import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// ✅ **Initialize Notifications**
  static Future<void> initialize() async {
    tz.initializeTimeZones(); // Ensure time zones are initialized

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(settings);
  }

  /// ✅ **Schedules a Notification at a Specific Time**
  static Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledDateTime,
  ) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'Skincare Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// ✅ **Schedule Notifications from Firebase (Ensure It's Static)**
  static Future<void> scheduleNotificationsFromFirebase(String userId, context) async {
    print("🔔 Scheduling notifications for user: $userId");

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('channel_id', 'Scheduled Notifications',
            importance: Importance.high, priority: Priority.high);

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0, // Notification ID
      "Reminder!",
      "It's time for your skincare routine!",
      platformDetails,
    );
  }
}
