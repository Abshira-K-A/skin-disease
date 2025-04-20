




// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// // Background message handler
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling background message: ${message.messageId}");
//   await NotificationService.showNotificationFromPayload(message.data);
// }

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // Initialize Notification Plugin
//   static Future<void> initialize() async {
//     tz.initializeTimeZones();
//     tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

//     const AndroidInitializationSettings androidInitSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final InitializationSettings initSettings =
//         InitializationSettings(android: androidInitSettings);

//     await flutterLocalNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         // Handle notification tap
//       },
//     );

//     // Request permissions
//     final androidPlugin = flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();
//     await androidPlugin?.requestNotificationsPermission();
//   }

//   // Store routine and schedule notifications
//   static Future<void> storeAndScheduleRoutine({
//     required String userId,
//     required String routineName,
//     required List<String> products,
//     required TimeOfDay time,
//     required bool isMorning,
//     required String frequency,
//     List<DateTime>? specificDays,
//   }) async {
//     try {
//       // 1. Store in Firestore
//       final routineData = {
//         'userId': userId,
//         'routineName': routineName,
//         'products': products,
//         'time': '${time.hour}:${time.minute}',
//         'isMorning': isMorning,
//         'frequency': frequency,
//         'specificDays': specificDays?.map((day) => Timestamp.fromDate(day)).toList(),
//         'createdAt': FieldValue.serverTimestamp(),
//         'status': 'active',
//       };

//       final docRef = await FirebaseFirestore.instance
//           .collection('skincare_routines')
//           .add(routineData);

//       // 2. Schedule notifications
//       if (specificDays != null && specificDays.isNotEmpty) {
//         for (final day in specificDays) {
//           await _scheduleSingleNotification(
//             id: '${docRef.id}_${day.hashCode}'.hashCode,
//             title: isMorning ? '🌞 Morning Routine' : '🌙 Evening Routine',
//             body: 'Time to use: ${products.join(', ')}',
//             scheduledTime: DateTime(
//               day.year,
//               day.month,
//               day.day,
//               time.hour,
//               time.minute,
//             ),
//           );
//         }
//       } else {
//         await _scheduleDailyNotification(
//           id: docRef.id.hashCode,
//           title: isMorning ? '🌞 Morning Routine' : '🌙 Evening Routine',
//           body: 'Time to use: ${products.join(', ')}',
//           time: time,
//         );
//       }

//       print('✅ Routine stored and notifications scheduled');
//     } catch (e) {
//       print('❌ Error storing routine: $e');
//       rethrow;
//     }
//   }

//   static Future<void> _scheduleSingleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledTime,
//   }) async {
//     final tz.TZDateTime localTime = tz.TZDateTime.from(scheduledTime, tz.local);

//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'skincare_reminders_channel',
//       'Skincare Reminders',
//       channelDescription: 'Notifications for skincare routine reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//     );

//     const NotificationDetails details = NotificationDetails(android: androidDetails);

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       localTime,
//       details,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

//   static Future<void> _scheduleDailyNotification({
//     required int id,
//     required String title,
//     required String body,
//     required TimeOfDay time,
//   }) async {
//     final now = DateTime.now();
//     DateTime scheduledTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

//     if (scheduledTime.isBefore(now)) {
//       scheduledTime = scheduledTime.add(const Duration(days: 1));
//     }

//     final tz.TZDateTime localTime = tz.TZDateTime.from(scheduledTime, tz.local);

//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'skincare_reminders_channel',
//       'Skincare Reminders',
//       channelDescription: 'Notifications for skincare routine reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//     );

//     const NotificationDetails details = NotificationDetails(android: androidDetails);

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       localTime,
//       details,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }

//   static Future<void> showNotificationFromPayload(Map<String, dynamic> payload) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'skincare_reminders_channel',
//       'Skincare Reminders',
//       channelDescription: 'Notifications for skincare routine reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails details = NotificationDetails(android: androidDetails);

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       payload['title'] ?? 'Skincare Reminder',
//       payload['body'] ?? 'Time for your skincare routine!',
//       details,
//     );
//   }

//   static Future<void> cancelAllNotifications() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }

//   static void scheduleNotificationsFromFirebase(String uid, BuildContext context) {}

//   static scheduleNotificationFromTimeOfDay(int i, String s, String t, TimeOfDay selectedTime, {String? frequency}) {}
// }



import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzData;
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Timezone setup
    tzData.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(initSettings);
  }
 

  static Future<void> scheduleDailyNotification({
  required int id,
  required String title,
  required String body,
  required TimeOfDay time,
}) async {
  final now = tz.TZDateTime.now(tz.local);
  var scheduledDate = tz.TZDateTime(  // Changed from final to var
    tz.local,
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );
  
  // If the scheduled time is in the past, add one day
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  print("🔔 Scheduling notification at: $scheduledDate");

  await _notificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    scheduledDate,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_notification_channel_id',
        'Daily Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

  static bool scheduledDateIsPast(DateTime now, TimeOfDay selectedTime) {
    final selectedDateTime =
        DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
    return selectedDateTime.isBefore(now);
  }

  Future<void> showNotificationFromPayload(Map<String, String> payload) async {
    await _notificationsPlugin.show(
      0,
      payload['title'],
      payload['body'],
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  static Future<void> scheduleNotificationsFromFirebase(String uid, BuildContext context) async {
    // 🔧 Example: Fetch routines from Firestore and schedule them
    final snapshot = await FirebaseFirestore.instance
        .collection('skincare_routines')
        .where('userId', isEqualTo: uid)
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final timeParts = (data['time'] as String).split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final timeOfDay = TimeOfDay(hour: hour, minute: minute);

      await scheduleDailyNotification(
        id: doc.id.hashCode,
        title: data['isMorning'] == true ? '🌞 Morning Routine' : '🌙 Evening Routine',
        body: 'Time to use: ${(data['products'] as List<dynamic>).join(', ')}',
        time: timeOfDay,
      );
    }
  }
}
