
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'notification_service.dart';
// import 'main_page.dart';

// final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
//     GlobalKey<ScaffoldMessengerState>(); // ✅ Global key for Snackbar

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   tz.initializeTimeZones(); // ✅ Initialize time zones for notifications
//   await Firebase.initializeApp(); // ✅ Ensure Firebase is initialized
//   await NotificationService.initialize(); // ✅ Initialize notifications

//   await _checkLocationPermission(); // ✅ Request location permission before starting app

//   runApp(const MyApp());
// }

// /// ✅ **Requests Location Permission at Startup**
// Future<void> _checkLocationPermission() async {
//   LocationPermission permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied ||
//       permission == LocationPermission.deniedForever) {
//     await Geolocator.requestPermission();
//   }
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     _scheduleUserNotifications();
//   }

//   /// ✅ **Schedules Notifications When User Logs In**
//   void _scheduleUserNotifications() async {
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user != null) {
//        NotificationService.scheduleNotificationsFromFirebase(user.uid, context);

//  // ✅ Fixed missing argument
//         print("✅ Notifications scheduled for ${user.uid}");
//       } else {
//         print("⚠️ No user logged in, skipping notification scheduling.");
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "SkinCure",
//       scaffoldMessengerKey: scaffoldMessengerKey, // ✅ Assign global key for Snackbars
//       theme: ThemeData(
//         primarySwatch: Colors.deepOrange,
//         brightness: Brightness.light,
//       ),
//       darkTheme: ThemeData(
//         brightness: Brightness.dark, // ✅ Supports dark mode
//       ),
//       themeMode: ThemeMode.light, // ✅ **Forced light mode globally**
//       home: const MainPage(),
//     );
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:skinCure/notification_service.dart';
//import 'notification_service.dart';
import 'main_page.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>(); // ✅ Global key for Snackbar

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // ✅ Initialize time zones for notifications
  await Firebase.initializeApp();// ✅ Ensure Firebase is initialized
 // await NotificationService.initializeNotifications();
  await NotificationService.initialize(); // ✅ Initialize notifications

  await _checkLocationPermission(); // ✅ Request location permission before starting app

  runApp(const MyApp());
}

/// ✅ **Requests Location Permission at Startup**
Future<void> _checkLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    await Geolocator.requestPermission();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _scheduleUserNotifications();
  }

  /// ✅ **Schedules Notifications When User Logs In**
  void _scheduleUserNotifications() async {
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      NotificationService notificationService = NotificationService();
      notificationService.scheduleNotificationsFromFirebase(user.uid, context);
      print("✅ Notifications scheduled for ${user.uid}");
    } else {
      print("⚠️ No user logged in, skipping notification scheduling.");
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SkinCure",
      scaffoldMessengerKey: scaffoldMessengerKey, // ✅ Assign global key for Snackbars
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // ✅ Supports dark mode
      ),
      themeMode: ThemeMode.light, // ✅ **Forced light mode globally**
      home: const MainPage(),
    );
  }
}

