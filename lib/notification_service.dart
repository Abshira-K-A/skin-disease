
// //--------------------------------------------------------------
// import 'dart:typed_data';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:flutter/material.dart';

// class NotificationService {
//   // Use only the static instance for consistency
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   /// Initialize notifications with proper channels
//   static Future<void> initialize() async {
//     // Initialize timezone database
//     tz.initializeTimeZones();
    
//     // Android initialization
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
    
//     // iOS initialization
//     const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     // Combined initialization settings
//     const InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );

//     // Initialize the plugin
//     await flutterLocalNotificationsPlugin.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (details) {
//         // Handle when user taps on notification
//       },
//     );

//     // Create notification channel (Android 8.0+)
//     await _createNotificationChannel();
//   }

//   static Future<void> _createNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'skincare_reminders_channel',
//       'Skincare Reminders',
//       description: 'Notifications for your skincare routine',
//       importance: Importance.max,
//       playSound: true,
//       enableVibration: true,
//     );
    
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   /// Schedule a one-time notification at specific time
//   static Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required TimeOfDay time,
//     required DateTime date,
//     String? payload,
//   }) async {
//     final scheduledTime = tz.TZDateTime(
//       tz.local,
//       date.year,
//       date.month,
//       date.day,
//       time.hour,
//       time.minute,
//     );

//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'skincare_reminders_channel',
//       'Skincare Reminders',
//       channelDescription: 'Notifications for skincare routine reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//     );
    
//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//       sound: 'default',
//     );

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       scheduledTime,
//       const NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       ),
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       payload: payload,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }

//   /// Schedule daily notification (either recurring or for specific date)
//   static Future<void> scheduleDailyNotification({
//     required int id,
//     required String title,
//     required String body,
//     required TimeOfDay time,
//     required String payload,
//     DateTime? specificDate,
//   }) async {
//     final tz.TZDateTime scheduledTime = specificDate != null
//         ? tz.TZDateTime(
//             tz.local,
//             specificDate.year,
//             specificDate.month,
//             specificDate.day,
//             time.hour,
//             time.minute,
//           )
//         : _nextInstanceOfTime(time);

//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'skincare_reminders_channel',
//       'Skincare Reminders',
//       channelDescription: 'Notifications for skincare routine reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//     );
    
//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//       sound: 'default',
//     );

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       scheduledTime,
//       const NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       ),
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       payload: payload,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       matchDateTimeComponents: specificDate == null 
//           ? DateTimeComponents.time 
//           : null,
//     );
//   }

//   /// Helper to calculate next instance of time
//   static tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
//     final now = tz.TZDateTime.now(tz.local);
//     var scheduledDate = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       time.hour,
//       time.minute,
//     );

//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }

//     return scheduledDate;
//   }

//   /// Cancel specific notification
//   static Future<void> cancelNotification(int id) async {
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }

//   /// Cancel all notifications
//   static Future<void> cancelAllNotifications() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }

//   /// Show immediate notification (for testing)
//   static Future<void> showInstantNotification({
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'skincare_reminders_channel',
//       'Skincare Reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//     );
    
//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     await flutterLocalNotificationsPlugin.show(
//       0, // Notification ID
//       title,
//       body,
//       const NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       ),
//       payload: payload,
//     );
//   }

//   static void scheduleNotificationsFromFirebase(String uid, BuildContext context) {}
// }


// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:flutter/material.dart';  // This includes TimeOfDay


// class NotificationService {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // 🔹 Initialize Notification Plugin
//   static Future<void> initialize() async {
//     tz.initializeTimeZones(); // ✅ Initialize timezones first
//      tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

//     const AndroidInitializationSettings androidInitSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final InitializationSettings initSettings =
//         InitializationSettings(android: androidInitSettings);

//     await flutterLocalNotificationsPlugin.initialize(initSettings);

//     // ✅ Request permission for Android 13+
//     final androidPlugin = flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();
//     await androidPlugin?.requestNotificationsPermission();
//   }

//   // 🔹 Schedule Notification (Fixed for v19.0.0)
//   // Original method accepting DateTime
// static Future<void> scheduleNotification(
//     int id, String title, String body, DateTime scheduledTime) async {
//   print("🔹 Scheduling Notification (Original Time): $scheduledTime");

//   final tz.TZDateTime localTime = tz.TZDateTime.from(scheduledTime, tz.local);
//   print("⏳ Converted to Local Time Zone: $localTime");

//   // const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//   //   'medication_channel',
//   //   'Medication Reminders',
//   //   channelDescription: 'Sends reminders for medication and doctor appointments.',
//   //   importance: Importance.high,
//   //   priority: Priority.high,
//   // );
//    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//      'skincare_reminders_channel',
//      'Skincare Reminders',
//             channelDescription: 'Notifications for skincare routine reminders',
//        importance: Importance.max,
//        priority: Priority.high,
//        playSound: true,
//        enableVibration: true,
//      );
  

//   const NotificationDetails details = NotificationDetails(android: androidDetails);

//   await flutterLocalNotificationsPlugin.zonedSchedule(
//     id,
//     title,
//     body,
//     localTime,
//     details,
//     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     matchDateTimeComponents: DateTimeComponents.time, // Repeat daily at the same time
//   );

//   print("✅ Notification Scheduled at: $localTime");
// }

// // New method accepting TimeOfDay, renamed to avoid duplication
// static Future<void> scheduleNotificationFromTimeOfDay(
//     int id, String title, String body, TimeOfDay selectedTime) async {
//   final DateTime now = DateTime.now();

//   // Convert the selected time to a DateTime object
//   final DateTime scheduledTime = DateTime(
//     now.year,
//     now.month,
//     now.day,
//     selectedTime.hour,
//     selectedTime.minute,
//   );

//   // If the scheduled time is before now, set it for the next day
//   final scheduledDate = scheduledTime.isBefore(now)
//       ? scheduledTime.add(Duration(days: 1))
//       : scheduledTime;

//   // Convert the scheduled time to TZDateTime (timezone aware)
//   final tz.TZDateTime localTime = tz.TZDateTime.from(scheduledDate, tz.local);

//   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'skincare_reminders_channel',
//        'Skincare Reminders',
//        channelDescription: 'Notifications for skincare routine reminders',
//        importance: Importance.max,
//        priority: Priority.high,
//        playSound: true,
//        enableVibration: true,
//      );

//   const NotificationDetails details = NotificationDetails(android: androidDetails);

//   await flutterLocalNotificationsPlugin.zonedSchedule(
//     id,
//     title,
//     body,
//     localTime,
//     details,
//     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     matchDateTimeComponents: DateTimeComponents.time, // Repeat daily at the same time
//   );

//   print("✅ Notification Scheduled at: $localTime");
// }

//   static cancelAllNotifications() {}

//   static scheduleDailyNotification({required int id, required String title, required String body, required TimeOfDay time, required String payload, DateTime? specificDate}) {}

// }


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/material.dart';

// Background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling background message: ${message.messageId}");
}

// Initialize Firebase Messaging
class FirebaseNotificationService {
  static Future<void> initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    String? token = await messaging.getToken();
    print("FCM Token: $token");

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received: ${message.notification?.title}");
    });

    // Handle when app is opened by tapping the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message clicked!");
    });

    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
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

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }
  Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings settings =
      InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(settings);
}

  // Schedule Notification with DateTime
  static Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    print("🔹 Scheduling Notification (Original Time): $scheduledTime");

    final tz.TZDateTime localTime = tz.TZDateTime.from(scheduledTime, tz.local);
    print("⏳ Converted to Local Time Zone: $localTime");

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

    print("✅ Notification Scheduled at: $localTime");
  }

  // Schedule Notification with TimeOfDay
 /*  static Future<void> scheduleNotificationFromTimeOfDay(
      int id, String title, String body, TimeOfDay selectedTime) async {
    final DateTime now = DateTime.now();
    final DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final scheduledDate = scheduledTime.isBefore(now)
        ? scheduledTime.add(const Duration(days: 1))
        : scheduledTime;

    final tz.TZDateTime localTime = tz.TZDateTime.from(scheduledDate, tz.local);

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
print("Scheduled Time: $scheduledDate");
print("Current Time: $now");

    print("✅ Notification Scheduled at: $localTime");
  } 
 */
// static Future<void> scheduleNotificationFromTimeOfDay(
//     int id, String title, String body, TimeOfDay selectedTime) async {
//   final DateTime now = DateTime.now();
//   final DateTime scheduleTime = DateTime(
//     now.year,
//     now.month,
//     now.day,
//     selectedTime.hour,
//     selectedTime.minute,
//   ).add(Duration(seconds: 5));  // Schedule 5 seconds from now for testing

//   final tz.TZDateTime localTime = tz.TZDateTime.from(scheduleTime, tz.local);

//   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//     'skincare_reminders_channel',
//     'Skincare Reminders',
//     channelDescription: 'Notifications for skincare routine reminders',
//     importance: Importance.max,
//     priority: Priority.high,
//     playSound: true,
//     enableVibration: true,
//   );

//   const NotificationDetails details = NotificationDetails(android: androidDetails);

//   await flutterLocalNotificationsPlugin.zonedSchedule(
//     id,
//     title,
//     body,
//     localTime,
//     details,
//     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//     matchDateTimeComponents: DateTimeComponents.time,
//   );

//   // Send an immediate test notification to ensure notifications work
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     "Test Notification",
//     "If this appears, notifications are working!",
//     details,
//   );

//   print("✅ Notification Scheduled at: $localTime");
// }

  static Future<void> scheduleNotificationFromTimeOfDay(
      int id, String title, String body, TimeOfDay selectedTime) async {
    final DateTime now = DateTime.now();
    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(Duration(days: 1));
    }

    final tz.TZDateTime localTime = tz.TZDateTime.from(scheduledTime, tz.local);

    print("🔔 Scheduling notification for: $localTime");

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

    print("✅ Notification Scheduled Successfully at: $localTime");
  }



  static Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required String payload,
    DateTime? specificDate,
  }) async {
    DateTime scheduledDate;
    
    if (specificDate != null) {
      scheduledDate = DateTime(
        specificDate.year,
        specificDate.month,
        specificDate.day,
        time.hour,
        time.minute,
      );
    } else {
      final now = DateTime.now();
      scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
      
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }

    final tz.TZDateTime localTime = tz.TZDateTime.from(scheduledDate, tz.local);

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
      matchDateTimeComponents: specificDate == null 
          ? DateTimeComponents.time 
          : null,
    );
  }

  static void scheduleNotificationsFromFirebase(String uid, BuildContext context) {}
}