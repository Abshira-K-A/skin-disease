// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   /// ✅ **Initialize Notifications & Request Permission**
//   static Future<void> initialize() async {
//     tz.initializeTimeZones(); // Ensure timezones are initialized

//     const AndroidInitializationSettings androidInit =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final InitializationSettings initSettings =
//         InitializationSettings(android: androidInit);

//     await _notificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (response) {
//         print("🔔 Notification Clicked: ${response.payload}");
//       },
//     );

//     await requestNotificationPermission();
//     await createNotificationChannel(); // Ensure the channel is created
//   }

//   static Future<void> createNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'skincare_channel', // id
//       'Skincare Notifications', // title
//       description: 'Reminders for your skincare routines',
//       importance: Importance.high,
//     );

//     await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
//   }

//   /// ✅ **Request Notification Permission (Android 13+)**
//   static Future<void> requestNotificationPermission() async {
//     final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
//         _notificationsPlugin.resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();

//     if (androidPlugin != null) {
//       final bool? granted = await androidPlugin.requestNotificationsPermission();
//       if (granted == true) {
//         print("✅ Notification permission granted");
//       } else {
//         print("⚠️ Notification permission denied");
//       }
//     }
//   }

//   /// ✅ **Schedule a Notification**
//   static Future<void> scheduleNotification(
//       int id, String title, String body, DateTime scheduledTime) async {
//     try {
//        print("📅 Scheduling notification: ID=$id, Title=$title, Time=$scheduledTime");
//       await _notificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         tz.TZDateTime.from(scheduledTime, tz.local),
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'skincare_channel',
//             'Skincare Notifications',
//             channelDescription: 'Reminders for your skincare routines',
//             importance: Importance.high,
//             priority: Priority.high,
//           playSound: true,
//           fullScreenIntent: true,     // 🟢 Show on lock screen
//           visibility: NotificationVisibility.public, // 🟢 Ensure visibility 
//           ),
//         ),
//         androidScheduleMode: AndroidScheduleMode.inexact,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//             matchDateTimeComponents: DateTimeComponents.time, // 🔄 Repeat Daily
//       );
//       print("✅ Notification scheduled for $scheduledTime");
//     } catch (e) {
//       print("⚠️ Error scheduling notification: $e");
//     }
//   }

//   /// ✅ **Schedule Notifications from Firebase (Shows Snackbar in Schedule Routine Page)**
//   static void scheduleNotificationsFromFirebase(String userId, BuildContext context) async {
//     var collection = FirebaseFirestore.instance.collection("skincare_routines");

//     // 🔹 Fetch existing routines once
//     var snapshot = await collection.where("userId", isEqualTo: userId).get();
//     for (var doc in snapshot.docs) {
//       _scheduleRoutineNotification(doc, context);
//     }

//     // 🔹 Listen for real-time changes
//     collection.where("userId", isEqualTo: userId).snapshots().listen((snapshot) {
//       for (var doc in snapshot.docs) {
//         _scheduleRoutineNotification(doc, context);
//       }
//     });

//     print("✅ Notifications scheduled from Firebase for user: $userId");
//   }

//   /// ✅ **Helper Function to Schedule Notification**
//   static void _scheduleRoutineNotification(DocumentSnapshot doc, BuildContext context) {
//     try {
//       String timing = doc['timing'];
//       DateTime scheduledTime = convertTimingToDateTime(timing);
//       scheduleNotification(doc.id.hashCode, "Skincare Reminder", doc['products'], scheduledTime);

//       // ✅ Show confirmation message inside Schedule Routine Page
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("✅ Reminder successfully set for $timing!"),
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }

//     } catch (e) {
//       print("⚠️ Error reading routine data: $e");
//     }
//   }

//   /// ✅ **Convert Time Strings to `DateTime`**
//   static DateTime convertTimingToDateTime(String timing) {
//     try {
//       DateTime now = DateTime.now();
//       final RegExp timeRegex = RegExp(r"(\d{1,2}):(\d{2})\s?(AM|PM)?", caseSensitive: false);
//       final Match? match = timeRegex.firstMatch(timing);

//       if (match != null) {
//         int hour = int.parse(match.group(1)!);
//         int minute = int.parse(match.group(2)!);
//         String? period = match.group(3)?.toUpperCase();

//         if (period == "PM" && hour < 12) hour += 12;
//         if (period == "AM" && hour == 12) hour = 0;

//         DateTime scheduleTime = DateTime(now.year, now.month, now.day, hour, minute);

//         // ✅ Ensure notifications are always in the future
//         if (scheduleTime.isBefore(now)) {
//           scheduleTime = scheduleTime.add(const Duration(days: 1));
//         }

//         print("⏰ Parsed Time: $scheduleTime");
//         return scheduleTime;
//       } else {
//         throw "Invalid time format: $timing";
//       }
//     } catch (e) {
//       print("⚠️ Error parsing time: $e");
//       return DateTime.now().add(const Duration(minutes: 1)); // Default to 1 min later
//     }
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  DateTime now = DateTime.now();  // Get the current date and time
  print("Default Time: $now");
  NotificationService.initialize(); // Initialize notifications
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// ✅ **Initialize Notifications & Request Permission**
  static Future<void> initialize() async {
    tz.initializeTimeZones(); // Ensure timezones are initialized

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        print("🔔 Notification Clicked: ${response.payload}");
      },
    );

    await requestNotificationPermission();
    await createNotificationChannel(); // Ensure the channel is created
  }

  static Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'skincare_channel', // id
      'Skincare Notifications', // title
      description: 'Reminders for your skincare routines',
      importance: Importance.high,
    );

    await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  /// ✅ **Request Notification Permission (Android 13+)**
  static Future<void> requestNotificationPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final bool? granted = await androidPlugin.requestNotificationsPermission();
      if (granted == true) {
        print("✅ Notification permission granted");
      } else {
        print("⚠️ Notification permission denied");
      }
    }
  }

  /// ✅ **Schedule a Notification**
  static Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    try {
       print("📅 Scheduling notification: ID=$id, Title=$title, Time=$scheduledTime");
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'skincare_channel',
            'Skincare Notifications',
            channelDescription: 'Reminders for your skincare routines',
            importance: Importance.high,
            priority: Priority.high,
          playSound: true,
          fullScreenIntent: true,     // 🟢 Show on lock screen
          visibility: NotificationVisibility.public, // 🟢 Ensure visibility 
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time, // 🔄 Repeat Daily
      );
      print("✅ Notification scheduled for $scheduledTime");
    } catch (e) {
      print("⚠️ Error scheduling notification: $e");
    }
  }

  /// ✅ **Schedule Notifications from Firebase (Shows Snackbar in Schedule Routine Page)**
  static void scheduleNotificationsFromFirebase(String userId, BuildContext context) async {
    var collection = FirebaseFirestore.instance.collection("skincare_routines");

    // 🔹 Fetch existing routines once
    var snapshot = await collection.where("userId", isEqualTo: userId).get();
    for (var doc in snapshot.docs) {
      _scheduleRoutineNotification(doc, context);
    }

    // 🔹 Listen for real-time changes
    collection.where("userId", isEqualTo: userId).snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        _scheduleRoutineNotification(doc, context);
      }
    });

    print("✅ Notifications scheduled from Firebase for user: $userId");
  }

  /// ✅ **Helper Function to Schedule Notification**
  static void _scheduleRoutineNotification(DocumentSnapshot doc, BuildContext context) {
    try {
      String timing = doc['timing'];
      DateTime scheduledTime = convertTimingToDateTime(timing);
      scheduleNotification(doc.id.hashCode, "Skincare Reminder", doc['products'], scheduledTime);

      // ✅ Show confirmation message inside Schedule Routine Page
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ Reminder successfully set for $timing!"),
            duration: Duration(seconds: 3),
          ),
        );
      }

    } catch (e) {
      print("⚠️ Error reading routine data: $e");
    }
  }

  /// ✅ **Convert Time Strings to `DateTime`**
  static DateTime convertTimingToDateTime(String timing) {
    try {
      DateTime now = DateTime.now();
      final RegExp timeRegex = RegExp(r"(\d{1,2}):(\d{2})\s?(AM|PM)?", caseSensitive: false);
      final Match? match = timeRegex.firstMatch(timing);

      if (match != null) {
        int hour = int.parse(match.group(1)!);
        int minute = int.parse(match.group(2)!);
        String? period = match.group(3)?.toUpperCase();

        if (period == "PM" && hour < 12) hour += 12;
        if (period == "AM" && hour == 12) hour = 0;

        DateTime scheduleTime = DateTime(now.year, now.month, now.day, hour, minute);

        // ✅ Ensure notifications are always in the future
        if (scheduleTime.isBefore(now)) {
          scheduleTime = scheduleTime.add(const Duration(days: 1));
        }

        print("⏰ Parsed Time: $scheduleTime");
        return scheduleTime;
      } else {
        throw "Invalid time format: $timing";
      }
    } catch (e) {
      print("⚠️ Error parsing time: $e");
      return DateTime.now().add(const Duration(minutes: 1)); // Default to 1 min later
    }
  }
}

