


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:skinCure/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
//import 'notification_service.dart';
import 'main_page.dart';
//import 'package:skinCure/FirebaseService.dart';
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>(); // ✅ Global key for Snackbar

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

 void setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for notifications
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else {
    print('User declined or has not accepted permission');
  }

  // Get the FCM token
  String? token = await messaging.getToken();
  print("FCM Token: $token");

  // Listen for foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Foreground message received: ${message.notification?.title}");
  });

  // Handle messages when the app is opened from a notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("Notification clicked: ${message.notification?.title}");
  });
}
Future<void> initializeNotifications() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //tz.initializeTimeZones(); // ✅ Initialize time zones for notifications
  await Firebase.initializeApp();// ✅ Ensure Firebase is initialized
 // await NotificationService.initializeNotifications();
  await NotificationService.initialize(); // ✅ Initialize notifications
   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
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
      NotificationService.scheduleNotificationsFromFirebase(user.uid, context);
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

