// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'notification_service.dart';
// import 'main_page.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   tz.initializeTimeZones(); // Initialize timezone data
//   await Firebase.initializeApp();
//   NotificationService.initialize(); // Initialize notifications
//   runApp(const MyApp());
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
//     NotificationService.scheduleNotificationsFromFirebase("12345"); // Replace with actual user ID
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Colors.blue[900],
//       ),
//       home: const MainPage(),
//     );
//   }
// }



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'notification_service.dart';
// import 'main_page.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   tz.initializeTimeZones(); // ✅ Initialize timezone data
//   await Firebase.initializeApp(); // ✅ Ensure Firebase is initialized
//   NotificationService.initialize(); // ✅ Initialize notifications

//   runApp(const MyApp());
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

//   /// ✅ **Dynamically Get User ID Before Scheduling Notifications**
//   void _scheduleUserNotifications() async {
//     User? user = FirebaseAuth.instance.currentUser; // ✅ Get logged-in user
//     if (user != null) {
//       NotificationService.scheduleNotificationsFromFirebase(user.uid);
//     } else {
//       print("⚠️ No user logged in, skipping notification scheduling.");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "SkinCure",
//       theme: ThemeData(
//         primarySwatch: Colors.deepOrange,
//         brightness: Brightness.light,
//       ),
//       // darkTheme: ThemeData.dark(), // ✅ Dark mode support
//       // themeMode: ThemeMode.system, // ✅ Follows device theme
//       // home: const MainPage(),

//        darkTheme: ThemeData(
//         brightness: Brightness.dark, // ✅ Dark mode styling
//       ),
//       themeMode: ThemeMode.light, // ✅ **Forced light mode globally**
//       home: const MainPage(),
//     );
//   }
// }



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'notification_service.dart';
// import 'main_page.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   tz.initializeTimeZones(); // ✅ Initialize timezone data
//   await Firebase.initializeApp(); // ✅ Ensure Firebase is initialized
//   await NotificationService.initialize(); // ✅ Initialize notifications

//   runApp(const MyApp());
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

//   /// ✅ **Schedule Notifications Dynamically When User Logs In**
//   void _scheduleUserNotifications() async {
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user != null) {
//         NotificationService.scheduleNotificationsFromFirebase(user.uid);
//         print("✅ Notifications scheduled for ${user.uid}");
//         _showSnackbar("Reminder set successfully!"); // ✅ Show Snackbar
//       } else {
//         print("⚠️ No user logged in, skipping notification scheduling.");
//       }
//     });
//   }

//   /// ✅ **Show Snackbar for Confirmation**
//   void _showSnackbar(String message) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "SkinCure",
//       theme: ThemeData(
//         primarySwatch: Colors.deepOrange,
//         brightness: Brightness.light,
//       ),
//       darkTheme: ThemeData(
//         brightness: Brightness.dark, // ✅ Dark mode styling
//       ),
//       themeMode: ThemeMode.light, // ✅ **Forced light mode globally**
//       home: const MainPage(),
//     );
//   }
// }


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'notification_service.dart';
// import 'main_page.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   tz.initializeTimeZones(); // ✅ Initialize timezone data
//   await Firebase.initializeApp(); // ✅ Ensure Firebase is initialized
//   await NotificationService.initialize(); // ✅ Initialize notifications

//   runApp(const MyApp());
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

//   /// ✅ **Schedule Notifications Dynamically When User Logs In**
//   void _scheduleUserNotifications() async {
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user != null) {
//         NotificationService.scheduleNotificationsFromFirebase(user.uid, context); // ✅ Pass `context`
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
//       theme: ThemeData(
//         primarySwatch: Colors.deepOrange,
//         brightness: Brightness.light,
//       ),
//       darkTheme: ThemeData(
//         brightness: Brightness.dark, // ✅ Dark mode styling
//       ),
//       themeMode: ThemeMode.light, // ✅ **Forced light mode globally**
//       home: const MainPage(),
//     );
//   }
// }


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'notification_service.dart';
// import 'main_page.dart';

// final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>(); // ✅ Define global key

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   tz.initializeTimeZones(); // ✅ Initialize timezone data
//   await Firebase.initializeApp(); // ✅ Ensure Firebase is initialized
//   await NotificationService.initialize(); // ✅ Initialize notifications

//   runApp(const MyApp());
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

//   /// ✅ **Schedule Notifications Dynamically When User Logs In**
//   void _scheduleUserNotifications() async {
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user != null) {
//         NotificationService.scheduleNotificationsFromFirebase(user.uid);
//         print("✅ Notifications scheduled for ${user.uid}");

//         // ✅ Show Snackbar Using Global Key
//         scaffoldMessengerKey.currentState?.showSnackBar(
//           SnackBar(
//             content: Text("Reminder set successfully!"),
//             duration: Duration(seconds: 2),
//           ),
//         );
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
//       scaffoldMessengerKey: scaffoldMessengerKey, // ✅ Assign global key here
//       theme: ThemeData(
//         primarySwatch: Colors.deepOrange,
//         brightness: Brightness.light,
//       ),
//       darkTheme: ThemeData(
//         brightness: Brightness.dark, // ✅ Dark mode styling
//       ),
//       themeMode: ThemeMode.light, // ✅ **Forced light mode globally**
//       home: const MainPage(),
//     );
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'notification_service.dart';
import 'main_page.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>(); // ✅ Global key for Snackbar

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // ✅ Initialize time zones for notifications
  await Firebase.initializeApp(); // ✅ Ensure Firebase is initialized
  await NotificationService.initialize(); // ✅ Initialize notifications

  runApp(const MyApp());
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
        NotificationService.scheduleNotificationsFromFirebase(user.uid, context); // ✅ Fixed missing argument
        print("✅ Notifications scheduled for ${user.uid}");

        // ✅ Show success message using Snackbar
        // scaffoldMessengerKey.currentState?.showSnackBar(
        //   SnackBar(
        //     content: Text("Reminder set successfully!"),
        //     duration: Duration(seconds: 2),
        //   ),
        // );
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

