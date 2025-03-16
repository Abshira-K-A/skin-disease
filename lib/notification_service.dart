// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

//   static void initialize() {
//     final AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings initSettings = InitializationSettings(android: androidInit);
//     _notificationsPlugin.initialize(initSettings);
//      tz.initializeTimeZones();
//   }

//   static void scheduleNotification(int id, String title, String body, DateTime scheduledTime) {
//     _notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledTime, tz.local),
//       const NotificationDetails(
//         android: AndroidNotificationDetails("channelId", "channelName", importance: Importance.high),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

//   static void scheduleNotificationsFromFirebase(String userId) {
//     FirebaseFirestore.instance
//         .collection("skincare_routines")
//         .where("userId", isEqualTo: userId)
//         .snapshots()
//         .listen((snapshot) {
//       for (var doc in snapshot.docs) {
//         String timing = doc['timing'];
//         DateTime scheduledTime = convertTimingToDateTime(timing);
//         scheduleNotification(doc.id.hashCode, "Skincare Reminder", doc['products'], scheduledTime);
//       }
//     });
//   }

//   static DateTime convertTimingToDateTime(String timing) {
//     if (timing.contains("morning")) {
//       return DateTime.now().add(Duration(hours: 9)); // 9 AM
//     } else if (timing.contains("night")) {
//       return DateTime.now().add(Duration(hours: 21)); // 9 PM
//     } else {
//       return DateTime.now().add(Duration(minutes: 1)); // Default to 1 min later for testing
//     }
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    final AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initSettings =
        InitializationSettings(android: androidInit);
    _notificationsPlugin.initialize(initSettings);
    tz.initializeTimeZones();
  }

  static Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
     const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static void scheduleNotificationsFromFirebase(String userId) {
    FirebaseFirestore.instance
        .collection("skincare_routines")
        .where("userId", isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        String timing = doc['timing'];
        DateTime scheduledTime = convertTimingToDateTime(timing);
        scheduleNotification(doc.id.hashCode, "Skincare Reminder",
            doc['products'], scheduledTime);
      }
    });
  }

  static DateTime convertTimingToDateTime(String timing) {
     DateTime now = DateTime.now();
    if (timing.contains("morning")) {
      return DateTime.now().add(Duration(hours: 9)); // 9 AM
    } else if (timing.contains("night")) {
      return DateTime.now().add(Duration(hours: 21)); // 9 PM
    } else {
      return DateTime.now().add(Duration(minutes: 1)); // Default to 1 min later for testing
    }
  }
}
