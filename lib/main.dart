// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// import 'main_page.dart';


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
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


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:convert';  // For JSON decoding
import 'package:flutter/services.dart' show rootBundle;
import 'main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await loadSkinData(); // Load JSON data before running the app
  runApp(const MyApp());
}

// Function to load JSON file
Future<void> loadSkinData() async {
  try {
    String jsonString = await rootBundle.loadString('assets/skin_analysis.json');
    Map<String, dynamic> skinData = jsonDecode(jsonString);
    print("Loaded JSON Data: $skinData"); // Prints JSON data in the console
  } catch (e) {
    print("Error loading JSON file: $e");
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      home: const MainPage(),
    );
  }
}
