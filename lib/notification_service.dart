




import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling background message: ${message.messageId}");
  await NotificationService.showNotificationFromPayload(message.data);
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize Notification Plugin
  static Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );

    // Request permissions
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  // Store routine and schedule notifications
  static Future<void> storeAndScheduleRoutine({
    required String userId,
    required String routineName,
    required List<String> products,
    required TimeOfDay time,
    required bool isMorning,
    required String frequency,
    List<DateTime>? specificDays,
  }) async {
    try {
      // 1. Store in Firestore
      final routineData = {
        'userId': userId,
        'routineName': routineName,
        'products': products,
        'time': '${time.hour}:${time.minute}',
        'isMorning': isMorning,
        'frequency': frequency,
        'specificDays': specificDays?.map((day) => Timestamp.fromDate(day)).toList(),
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'active',
      };

      final docRef = await FirebaseFirestore.instance
          .collection('skincare_routines')
          .add(routineData);

      // 2. Schedule notifications
      if (specificDays != null && specificDays.isNotEmpty) {
        for (final day in specificDays) {
          await _scheduleSingleNotification(
            id: '${docRef.id}_${day.hashCode}'.hashCode,
            title: isMorning ? '🌞 Morning Routine' : '🌙 Evening Routine',
            body: 'Time to use: ${products.join(', ')}',
            scheduledTime: DateTime(
              day.year,
              day.month,
              day.day,
              time.hour,
              time.minute,
            ),
          );
        }
      } else {
        await _scheduleDailyNotification(
          id: docRef.id.hashCode,
          title: isMorning ? '🌞 Morning Routine' : '🌙 Evening Routine',
          body: 'Time to use: ${products.join(', ')}',
          time: time,
        );
      }

      print('✅ Routine stored and notifications scheduled');
    } catch (e) {
      print('❌ Error storing routine: $e');
      rethrow;
    }
  }

  static Future<void> _scheduleSingleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tz.TZDateTime localTime = tz.TZDateTime.from(scheduledTime, tz.local);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'skincare_reminders_channel',
      'Skincare Reminders',
      channelDescription: 'Notifications for skincare routine reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      localTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> _scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    final now = DateTime.now();
    DateTime scheduledTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final tz.TZDateTime localTime = tz.TZDateTime.from(scheduledTime, tz.local);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'skincare_reminders_channel',
      'Skincare Reminders',
      channelDescription: 'Notifications for skincare routine reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      localTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> showNotificationFromPayload(Map<String, dynamic> payload) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'skincare_reminders_channel',
      'Skincare Reminders',
      channelDescription: 'Notifications for skincare routine reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      payload['title'] ?? 'Skincare Reminder',
      payload['body'] ?? 'Time for your skincare routine!',
      details,
    );
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static void scheduleNotificationsFromFirebase(String uid, BuildContext context) {}

  static scheduleNotificationFromTimeOfDay(int i, String s, String t, TimeOfDay selectedTime) {}
}