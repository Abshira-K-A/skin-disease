

// // // // import 'package:flutter/material.dart';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // // // import 'package:timezone/timezone.dart' as tz;
// // // // import 'package:timezone/data/latest_all.dart' as tz;
// // // // import 'package:google_fonts/google_fonts.dart';

// // // // class ScheduleRoutinePage extends StatefulWidget {
// // // //   const ScheduleRoutinePage({super.key});

// // // //   @override
// // // //   _ScheduleRoutinePageState createState() => _ScheduleRoutinePageState();
// // // // }

// // // // class _ScheduleRoutinePageState extends State<ScheduleRoutinePage> {
// // // //   final TextEditingController _routineController = TextEditingController();
// // // //   TimeOfDay? _selectedTime;
// // // //   List<String> routines = [];
// // // //   final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _loadRoutines();
// // // //     _initializeNotifications();
// // // //     tz.initializeTimeZones(); // ✅ Initialize timezone data
// // // //   }

// // // //   Future<void> _initializeNotifications() async {
// // // //     const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
// // // //     final InitializationSettings settings = InitializationSettings(android: androidSettings);
// // // //     await _notificationsPlugin.initialize(settings);
// // // //   }

// // // //   Future<void> _loadRoutines() async {
// // // //     SharedPreferences prefs = await SharedPreferences.getInstance();
// // // //     setState(() {
// // // //       routines = prefs.getStringList('routines') ?? [];
// // // //     });
// // // //   }

// // // //   Future<void> _saveRoutines() async {
// // // //     SharedPreferences prefs = await SharedPreferences.getInstance();
// // // //     prefs.setStringList('routines', routines);
// // // //   }

// // // //   Future<void> _scheduleNotification(String routine, TimeOfDay time) async {
// // // //     final now = DateTime.now();
// // // //     final scheduleDateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
// // // //     final tz.TZDateTime scheduleTime = tz.TZDateTime.from(scheduleDateTime, tz.local);

// // // //     AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
// // // //       'routine_channel',
// // // //       'Routine Reminders',
// // // //       importance: Importance.high,
// // // //       priority: Priority.high,
// // // //     );

// // // //     NotificationDetails details = NotificationDetails(android: androidDetails);

// // // //     await _notificationsPlugin.zonedSchedule(
// // // //       routines.length, // Unique ID
// // // //       'Skincare Reminder',
// // // //       'Time for your $routine!',
// // // //       scheduleTime,
// // // //       details,
// // // //       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
// // // //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
// // // //     );
// // // //   }

// // // //   Future<void> _pickTime(BuildContext context) async {
// // // //     final TimeOfDay? pickedTime = await showTimePicker(
// // // //       context: context,
// // // //       initialTime: TimeOfDay.now(),
// // // //     );
// // // //     if (pickedTime != null) {
// // // //       setState(() {
// // // //         _selectedTime = pickedTime;
// // // //       });
// // // //     }
// // // //   }

// // // //   void _addRoutine() {
// // // //     if (_routineController.text.isNotEmpty && _selectedTime != null) {
// // // //       final newRoutine = '${_routineController.text} at ${_selectedTime!.format(context)}';
// // // //       setState(() {
// // // //         routines.add(newRoutine);
// // // //       });
// // // //       _saveRoutines();
// // // //       _scheduleNotification(_routineController.text, _selectedTime!);
// // // //       _routineController.clear();
// // // //     }
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: const Text("Schedule Routine"),
// // // //         backgroundColor: Colors.deepOrangeAccent,
// // // //       ),
// // // //       body: Padding(
// // // //         padding: const EdgeInsets.all(16.0),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.center,
// // // //           children: [
// // // //             // Stylish heading
// // // //             Text(
// // // //               "Let's set up your skincare routine! 🧴✨",
// // // //               style: GoogleFonts.pacifico(
// // // //                 fontSize: 24,
// // // //                 fontWeight: FontWeight.bold,
// // // //                 color: Colors.brown,
// // // //                 shadows: [
// // // //                   Shadow(color: Colors.orangeAccent, blurRadius: 4),
// // // //                 ],
// // // //               ),
// // // //               textAlign: TextAlign.center,
// // // //             ),
// // // //             const SizedBox(height: 8),

// // // //             // Subheading with a lively effect
// // // //             Text(
// // // //               "I’ll ask you a few questions, and together, we’ll build the perfect skincare schedule just for you! 🌟",
// // // //               textAlign: TextAlign.center,
// // // //               style: GoogleFonts.robotoSlab(
// // // //                 fontSize: 16,
// // // //                 fontWeight: FontWeight.w600,
// // // //                 color: Colors.black87,
// // // //                 fontStyle: FontStyle.italic,
// // // //                 letterSpacing: 1.2,
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 20),

// // // //             // Routine Input
// // // //             TextField(
// // // //               controller: _routineController,
// // // //               decoration: const InputDecoration(
// // // //                 labelText: "Enter Skincare Routine",
// // // //                 border: OutlineInputBorder(),
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 10),

// // // //             // Pick Time Button
// // // //             Row(
// // // //               children: [
// // // //                 Expanded(
// // // //                   child: ElevatedButton(
// // // //                     onPressed: () => _pickTime(context),
// // // //                     style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent),
// // // //                     child: Text(_selectedTime == null ? "Pick Reminder Time" : "Time: ${_selectedTime!.format(context)}"),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //             const SizedBox(height: 10),

// // // //             // Add Routine Button
// // // //             ElevatedButton(
// // // //               onPressed: _addRoutine,
// // // //               style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
// // // //               child: const Text("Add Routine", style: TextStyle(color: Colors.white)),
// // // //             ),
// // // //             const SizedBox(height: 20),

// // // //             // Display List of Routines
// // // //             const Text(
// // // //               "Your Scheduled Routines:",
// // // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange),
// // // //             ),
// // // //             Expanded(
// // // //               child: ListView.builder(
// // // //                 itemCount: routines.length,
// // // //                 itemBuilder: (context, index) {
// // // //                   return ListTile(
// // // //                     title: Text(routines[index], style: const TextStyle(fontSize: 16)),
// // // //                     trailing: IconButton(
// // // //                       icon: const Icon(Icons.delete, color: Colors.red),
// // // //                       onPressed: () {
// // // //                         setState(() {
// // // //                           routines.removeAt(index);
// // // //                         });
// // // //                         _saveRoutines();
// // // //                       },
// // // //                     ),
// // // //                   );
// // // //                 },
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }





// // // import 'package:flutter/material.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // // import 'package:timezone/timezone.dart' as tz;
// // // import 'package:timezone/data/latest_all.dart' as tz;
// // // import 'package:google_fonts/google_fonts.dart';

// // // class ScheduleRoutinePage extends StatefulWidget {
// // //   const ScheduleRoutinePage({super.key});

// // //   @override
// // //   _ScheduleRoutinePageState createState() => _ScheduleRoutinePageState();
// // // }

// // // class _ScheduleRoutinePageState extends State<ScheduleRoutinePage> {
// // //   TimeOfDay? _selectedTime;
// // //   List<String> routines = [];
// // //   final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
// // //   int currentQuestionIndex = 0;
// // //   List<String> userResponses = [];
  
// // //   final List<String> questions = [
// // //     "What time do you usually wake up? ⏰",
// // //     "Do you use a cleanser in the morning? 🧼",
// // //     "What type of moisturizer do you apply? 💧",
// // //     "Do you apply sunscreen during the day? 🌞",
// // //     "Do you have a night routine? 🌙",
// // //     "What is the last step in your nighttime skincare? 🛏️"
// // //   ];

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadRoutines();
// // //     _initializeNotifications();
// // //     tz.initializeTimeZones(); // ✅ Initialize timezone data
// // //   }

// // //   Future<void> _initializeNotifications() async {
// // //     const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
// // //     final InitializationSettings settings = InitializationSettings(android: androidSettings);
// // //     await _notificationsPlugin.initialize(settings);
// // //   }

// // //   Future<void> _loadRoutines() async {
// // //     SharedPreferences prefs = await SharedPreferences.getInstance();
// // //     setState(() {
// // //       routines = prefs.getStringList('routines') ?? [];
// // //     });
// // //   }

// // //   Future<void> _saveRoutines() async {
// // //     SharedPreferences prefs = await SharedPreferences.getInstance();
// // //     prefs.setStringList('routines', routines);
// // //   }

// // //   Future<void> _scheduleNotification(String routine, TimeOfDay time) async {
// // //     final now = DateTime.now();
// // //     final scheduleDateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
// // //     final tz.TZDateTime scheduleTime = tz.TZDateTime.from(scheduleDateTime, tz.local);

// // //     AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
// // //       'routine_channel',
// // //       'Routine Reminders',
// // //       importance: Importance.high,
// // //       priority: Priority.high,
// // //     );

// // //     NotificationDetails details = NotificationDetails(android: androidDetails);

// // //     await _notificationsPlugin.zonedSchedule(
// // //       routines.length, // Unique ID
// // //       'Skincare Reminder',
// // //       'Time for your skincare routine!',
// // //       scheduleTime,
// // //       details,
// // //       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
// // //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
// // //     );
// // //   }

// // //   Future<void> _pickTime(BuildContext context) async {
// // //     final TimeOfDay? pickedTime = await showTimePicker(
// // //       context: context,
// // //       initialTime: TimeOfDay.now(),
// // //     );
// // //     if (pickedTime != null) {
// // //       setState(() {
// // //         _selectedTime = pickedTime;
// // //       });
// // //     }
// // //   }

// // //   void _nextQuestion(String response) {
// // //     userResponses.add(response);
// // //     if (currentQuestionIndex < questions.length - 1) {
// // //       setState(() {
// // //         currentQuestionIndex++;
// // //       });
// // //     } else {
// // //       _addRoutine();
// // //     }
// // //   }

// // //   void _addRoutine() {
// // //     if (_selectedTime != null) {
// // //       final routineDetails = userResponses.join(", ");
// // //       final newRoutine = "Routine at ${_selectedTime!.format(context)}: $routineDetails";
// // //       setState(() {
// // //         routines.add(newRoutine);
// // //         currentQuestionIndex = 0;
// // //         userResponses.clear();
// // //       });
// // //       _saveRoutines();
// // //       _scheduleNotification("Skincare Routine", _selectedTime!);
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text("Schedule Routine"),
// // //         backgroundColor: Colors.deepOrangeAccent,
// // //       ),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.center,
// // //           children: [
// // //             Text(
// // //               "Let's set up your skincare routine! 🧴✨",
// // //               style: GoogleFonts.pacifico(
// // //                 fontSize: 24,
// // //                 fontWeight: FontWeight.bold,
// // //                 color: Colors.brown,
// // //                 shadows: [
// // //                   Shadow(color: Colors.orangeAccent, blurRadius: 4),
// // //                 ],
// // //               ),
// // //               textAlign: TextAlign.center,
// // //             ),
// // //             const SizedBox(height: 8),

// // //             Text(
// // //               "I'll ask you a few questions, and together, we'll build the perfect skincare schedule just for you! 🌟",
// // //               textAlign: TextAlign.center,
// // //               style: GoogleFonts.robotoSlab(
// // //                 fontSize: 16,
// // //                 fontWeight: FontWeight.w600,
// // //                 color: Colors.black87,
// // //                 fontStyle: FontStyle.italic,
// // //                 letterSpacing: 1.2,
// // //               ),
// // //             ),
// // //             const SizedBox(height: 20),

// // //             if (_selectedTime == null)
// // //               ElevatedButton(
// // //                 onPressed: () => _pickTime(context),
// // //                 style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent),
// // //                 child: const Text("Pick Reminder Time"),
// // //               ),

// // //             if (_selectedTime != null)
// // //               Column(
// // //                 children: [
// // //                   Text(
// // //                     questions[currentQuestionIndex],
// // //                     textAlign: TextAlign.center,
// // //                     style: GoogleFonts.lato(
// // //                       fontSize: 18,
// // //                       fontWeight: FontWeight.bold,
// // //                       color: Colors.deepOrange,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 15),

// // //                   // Answer options
// // //                   Wrap(
// // //                     spacing: 10,
// // //                     children: [
// // //                       ElevatedButton(
// // //                         onPressed: () => _nextQuestion("Yes"),
// // //                         style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
// // //                         child: const Text("Yes"),
// // //                       ),
// // //                       ElevatedButton(
// // //                         onPressed: () => _nextQuestion("No"),
// // //                         style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// // //                         child: const Text("No"),
// // //                       ),
// // //                       ElevatedButton(
// // //                         onPressed: () => _nextQuestion("Sometimes"),
// // //                         style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
// // //                         child: const Text("Sometimes"),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                   const SizedBox(height: 20),
// // //                 ],
// // //               ),

// // //             if (routines.isNotEmpty)
// // //               Column(
// // //                 children: [
// // //                   const Text(
// // //                     "Your Scheduled Routines:",
// // //                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange),
// // //                   ),
// // //                   Expanded(
// // //                     child: ListView.builder(
// // //                       itemCount: routines.length,
// // //                       itemBuilder: (context, index) {
// // //                         return ListTile(
// // //                           title: Text(routines[index], style: const TextStyle(fontSize: 16)),
// // //                           trailing: IconButton(
// // //                             icon: const Icon(Icons.delete, color: Colors.red),
// // //                             onPressed: () {
// // //                               setState(() {
// // //                                 routines.removeAt(index);
// // //                               });
// // //                               _saveRoutines();
// // //                             },
// // //                           ),
// // //                         );
// // //                       },
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }




// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:timezone/timezone.dart' as tz;
// // import 'package:timezone/data/latest_all.dart' as tz;
// // import 'package:google_fonts/google_fonts.dart';

// // class ScheduleRoutinePage extends StatefulWidget {
// //   const ScheduleRoutinePage({super.key});

// //   @override
// //   _ScheduleRoutinePageState createState() => _ScheduleRoutinePageState();
// // }

// // class _ScheduleRoutinePageState extends State<ScheduleRoutinePage> {
// //   final FlutterLocalNotificationsPlugin _notificationsPlugin =
// //       FlutterLocalNotificationsPlugin();
// //   final TextEditingController _answerController = TextEditingController();
// //   TimeOfDay? _selectedTime;
// //   List<String> routines = [];
// //   int _currentQuestionIndex = 0;

// //   final List<String> _questions = [
// //     "What is your skin type? (Oily, Dry, Combination, Sensitive)",
// //     "How often do you use a cleanser?",
// //     "Do you use a moisturizer? (Yes/No)",
// //     "How often do you apply sunscreen?",
// //     "Do you have any specific skin concerns? (Acne, Pigmentation, Wrinkles)",
// //     "Pick a time for your skincare routine reminder."
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadRoutines();
// //     _initializeNotifications();
// //     tz.initializeTimeZones(); // ✅ Initialize timezone data
// //   }

// //   Future<void> _initializeNotifications() async {
// //     const AndroidInitializationSettings androidSettings =
// //         AndroidInitializationSettings('@mipmap/ic_launcher');
// //     final InitializationSettings settings =
// //         InitializationSettings(android: androidSettings);
// //     await _notificationsPlugin.initialize(settings);
// //   }

// //   Future<void> _loadRoutines() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       routines = prefs.getStringList('routines') ?? [];
// //     });
// //   }

// //   Future<void> _saveRoutines() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     prefs.setStringList('routines', routines);
// //   }

// //   Future<void> _scheduleNotification(String routine, TimeOfDay time) async {
// //     final now = DateTime.now();
// //     final scheduleDateTime =
// //         DateTime(now.year, now.month, now.day, time.hour, time.minute);
// //     final tz.TZDateTime scheduleTime =
// //         tz.TZDateTime.from(scheduleDateTime, tz.local);

// //     AndroidNotificationDetails androidDetails =
// //         const AndroidNotificationDetails(
// //       'routine_channel',
// //       'Routine Reminders',
// //       importance: Importance.high,
// //       priority: Priority.high,
// //     );

// //     NotificationDetails details = NotificationDetails(android: androidDetails);

// //     await _notificationsPlugin.zonedSchedule(
// //       routines.length, // Unique ID
// //       'Skincare Reminder',
// //       'Time for your skincare routine!',
// //       scheduleTime,
// //       details,
// //       uiLocalNotificationDateInterpretation:
// //           UILocalNotificationDateInterpretation.absoluteTime,
// //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
// //     );
// //   }

// //   Future<void> _pickTime(BuildContext context) async {
// //     final TimeOfDay? pickedTime = await showTimePicker(
// //       context: context,
// //       initialTime: TimeOfDay.now(),
// //     );
// //     if (pickedTime != null) {
// //       setState(() {
// //         _selectedTime = pickedTime;
// //         _nextQuestion();
// //       });
// //     }
// //   }

// //   void _nextQuestion() {
// //     if (_currentQuestionIndex < _questions.length - 1) {
// //       setState(() {
// //         _currentQuestionIndex++;
// //       });
// //     } else {
// //       _saveRoutine();
// //     }
// //   }

// //   void _saveRoutine() {
// //     if (_selectedTime != null) {
// //       final newRoutine =
// //           "Routine at ${_selectedTime!.format(context)} - ${_answerController.text}";
// //       setState(() {
// //         routines.add(newRoutine);
// //       });
// //       _saveRoutines();
// //       _scheduleNotification("Skincare Routine", _selectedTime!);
// //       _answerController.clear();
// //       _currentQuestionIndex = 0; // Restart for new routine
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Schedule Skincare Routine"),
// //         backgroundColor: Colors.deepOrangeAccent,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           children: [
// //             // Stylish heading
// //             Text(
// //               "Let's build your skincare routine! 🧴✨",
// //               style: GoogleFonts.pacifico(
// //                 fontSize: 24,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.brown,
// //                 shadows: [
// //                   Shadow(color: Colors.orangeAccent, blurRadius: 4),
// //                 ],
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //             const SizedBox(height: 20),

// //             // Question display
// //             Text(
// //               _questions[_currentQuestionIndex],
// //               textAlign: TextAlign.center,
// //               style: GoogleFonts.robotoSlab(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w600,
// //                 color: Colors.black87,
// //                 letterSpacing: 1.2,
// //               ),
// //             ),
// //             const SizedBox(height: 10),

// //             if (_currentQuestionIndex == _questions.length - 1) ...[
// //               // Time Picker Button
// //               ElevatedButton(
// //                 onPressed: () => _pickTime(context),
// //                 style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.deepOrangeAccent),
// //                 child: Text(_selectedTime == null
// //                     ? "Pick Reminder Time"
// //                     : "Time: ${_selectedTime!.format(context)}"),
// //               ),
// //             ] else ...[
// //               // Answer Input Field
// //               TextField(
// //                 controller: _answerController,
// //                 decoration: const InputDecoration(
// //                   labelText: "Your Answer",
// //                   border: OutlineInputBorder(),
// //                 ),
// //               ),
// //               const SizedBox(height: 10),

// //               // Next Button
// //               ElevatedButton(
// //                 onPressed: () {
// //                   if (_answerController.text.isNotEmpty) {
// //                     _nextQuestion();
// //                   }
// //                 },
// //                 style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
// //                 child: const Text("Next", style: TextStyle(color: Colors.white)),
// //               ),
// //             ],

// //             const SizedBox(height: 20),

// //             // Display List of Routines
// //             const Text(
// //               "Your Scheduled Routines:",
// //               style: TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.deepOrange),
// //             ),
// //             Expanded(
// //               child: ListView.builder(
// //                 itemCount: routines.length,
// //                 itemBuilder: (context, index) {
// //                   return ListTile(
// //                     title: Text(routines[index], style: const TextStyle(fontSize: 16)),
// //                     trailing: IconButton(
// //                       icon: const Icon(Icons.delete, color: Colors.red),
// //                       onPressed: () {
// //                         setState(() {
// //                           routines.removeAt(index);
// //                         });
// //                         _saveRoutines();
// //                       },
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:google_fonts/google_fonts.dart';

// class ScheduleRoutinePage extends StatefulWidget {
//   final String userId; // Pass the logged-in user's ID

//   const ScheduleRoutinePage({super.key, required this.userId});

//   @override
//   _ScheduleRoutinePageState createState() => _ScheduleRoutinePageState();
// }

// class _ScheduleRoutinePageState extends State<ScheduleRoutinePage> {
//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   final TextEditingController _answerController = TextEditingController();
//   TimeOfDay? _selectedTime;
//   List<String> routines = [];
//   int _currentQuestionIndex = 0;
//   String? username;
//   String? skinType;
//   bool _isLoading = true;

//   final List<String> _questions = [
//     "How often do you use a cleanser?",
//     "Do you use a moisturizer? (Yes/No)",
//     "How often do you apply sunscreen?",
//     "Do you have any specific skin concerns? (Acne, Pigmentation, Wrinkles)",
//     "Pick a time for your skincare routine reminder."
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     _loadRoutines();
//     _initializeNotifications();
//     tz.initializeTimeZones();
//   }

//   Future<void> _loadUserData() async {
//     DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(widget.userId)
//         .get();

//     if (userSnapshot.exists) {
//       setState(() {
//         username = userSnapshot['name'];
//         skinType = userSnapshot['skinType'];
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _initializeNotifications() async {
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings settings =
//         InitializationSettings(android: androidSettings);
//     await _notificationsPlugin.initialize(settings);
//   }

//   Future<void> _loadRoutines() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       routines = prefs.getStringList('routines') ?? [];
//     });
//   }

//   Future<void> _saveRoutines() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setStringList('routines', routines);
//   }

//   Future<void> _scheduleNotification(String routine, TimeOfDay time) async {
//     final now = DateTime.now();
//     final scheduleDateTime =
//         DateTime(now.year, now.month, now.day, time.hour, time.minute);
//     final tz.TZDateTime scheduleTime =
//         tz.TZDateTime.from(scheduleDateTime, tz.local);

//     AndroidNotificationDetails androidDetails =
//         const AndroidNotificationDetails(
//       'routine_channel',
//       'Routine Reminders',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     NotificationDetails details = NotificationDetails(android: androidDetails);

//     await _notificationsPlugin.zonedSchedule(
//       routines.length,
//       'Skincare Reminder',
//       'Time for your skincare routine!',
//       scheduleTime,
//       details,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }

//   Future<void> _pickTime(BuildContext context) async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         _selectedTime = pickedTime;
//         _nextQuestion();
//       });
//     }
//   }

//   void _nextQuestion() {
//     if (_currentQuestionIndex < _questions.length - 1) {
//       setState(() {
//         _currentQuestionIndex++;
//       });
//     } else {
//       _saveRoutine();
//     }
//   }

//   void _saveRoutine() {
//     if (_selectedTime != null) {
//       final newRoutine =
//           "Routine at ${_selectedTime!.format(context)} - ${_answerController.text}";
//       setState(() {
//         routines.add(newRoutine);
//       });
//       _saveRoutines();
//       _scheduleNotification("Skincare Routine", _selectedTime!);
//       _answerController.clear();
//       _currentQuestionIndex = 0;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Schedule Skincare Routine"),
//         backgroundColor: Colors.deepOrangeAccent,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Animated Welcome Text
//                   AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 600),
//                     child: Text(
//                       "Hey $username! You have $skinType skin, so let's schedule your routine! 🌟",
//                       key: ValueKey<String>("Hey $username! You have $skinType skin."),
//                       style: GoogleFonts.lobster(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.deepOrange,
//                         shadows: [
//                           Shadow(color: Colors.orangeAccent, blurRadius: 5),
//                         ],
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Animated Question Display
//                   AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 600),
//                     child: Text(
//                       _questions[_currentQuestionIndex],
//                       key: ValueKey<int>(_currentQuestionIndex),
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.robotoSlab(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                         letterSpacing: 1.2,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   if (_currentQuestionIndex == _questions.length - 1) ...[
//                     // Time Picker Button
//                     ElevatedButton(
//                       onPressed: () => _pickTime(context),
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepOrangeAccent),
//                       child: Text(_selectedTime == null
//                           ? "Pick Reminder Time"
//                           : "Time: ${_selectedTime!.format(context)}"),
//                     ),
//                   ] else ...[
//                     // Answer Input Field
//                     TextField(
//                       controller: _answerController,
//                       decoration: const InputDecoration(
//                         labelText: "Your Answer",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 10),

//                     // Next Button
//                     ElevatedButton(
//                       onPressed: () {
//                         if (_answerController.text.isNotEmpty) {
//                           _nextQuestion();
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.brown),
//                       child: const Text("Next", style: TextStyle(color: Colors.white)),
//                     ),
//                   ],

//                   const SizedBox(height: 20),

//                   // Display List of Routines
//                   const Text(
//                     "Your Scheduled Routines:",
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.deepOrange),
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: routines.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(routines[index], style: const TextStyle(fontSize: 16)),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () {
//                               setState(() {
//                                 routines.removeAt(index);
//                               });
//                               _saveRoutines();
//                             },
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:google_fonts/google_fonts.dart';

class ScheduleRoutinePage extends StatefulWidget {
  final String userId; // Pass the logged-in user's ID

  const ScheduleRoutinePage({super.key, required this.userId});

  @override
  _ScheduleRoutinePageState createState() => _ScheduleRoutinePageState();
}

class _ScheduleRoutinePageState extends State<ScheduleRoutinePage> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final TextEditingController _answerController = TextEditingController();
  TimeOfDay? _selectedTime;
  String? username;
  String? skinType;
  bool _isLoading = true;

  final List<String> _questions = [
    "How often do you use a cleanser?",
    "Do you use a moisturizer? (Yes/No)",
    "How often do you apply sunscreen?",
    "Do you have any specific skin concerns? (Acne, Pigmentation, Wrinkles)",
    "Pick a time for your skincare routine reminder."
  ];
  List<Map<String, String>> _answeredQuestions = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initializeNotifications();
    tz.initializeTimeZones();
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();

    if (userSnapshot.exists) {
      setState(() {
        username = userSnapshot['name'];
        skinType = userSnapshot['skinType'];
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings settings =
        InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(settings);
  }

  Future<void> _scheduleNotification(String routine, TimeOfDay time) async {
    final now = DateTime.now();
    final scheduleDateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final tz.TZDateTime scheduleTime =
        tz.TZDateTime.from(scheduleDateTime, tz.local);

    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      'routine_channel',
      'Routine Reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      _answeredQuestions.length,
      'Skincare Reminder',
      'Time for your skincare routine!',
      scheduleTime,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> _storeAnswerInFirebase(String question, String answer) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('skincare_routines')
        .add({
      'question': question,
      'answer': answer,
      'timestamp': Timestamp.now(),
    });
  }

  void _nextQuestion(String answer) {
    setState(() {
      _answeredQuestions.add({
        'question': _questions[_answeredQuestions.length],
        'answer': answer
      });
    });

    _storeAnswerInFirebase(
        _questions[_answeredQuestions.length - 1], answer); // Store in Firestore

    if (_answeredQuestions.length < _questions.length) {
      _answerController.clear();
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });

      _nextQuestion("Reminder set at ${_selectedTime!.format(context)}");
      _scheduleNotification("Skincare Routine", _selectedTime!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule Skincare Routine"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated Welcome Text
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      "Hey $username! You have $skinType skin, so let's schedule your routine! 🌟",
                      key: ValueKey<String>("Hey $username! You have $skinType skin."),
                      style: GoogleFonts.lobster(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                        shadows: [
                          Shadow(color: Colors.orangeAccent, blurRadius: 5),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Display Answered Questions
                  Column(
                    children: _answeredQuestions.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry['question']!,
                              style: GoogleFonts.robotoSlab(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "➡ ${entry['answer']!}",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  // Display Next Question
                  if (_answeredQuestions.length < _questions.length)
                    Column(
                      children: [
                        Text(
                          _questions[_answeredQuestions.length],
                          style: GoogleFonts.robotoSlab(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_answeredQuestions.length == _questions.length - 1)
                          ElevatedButton(
                            onPressed: () => _pickTime(context),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrangeAccent),
                            child: Text(_selectedTime == null
                                ? "Pick Reminder Time"
                                : "Time: ${_selectedTime!.format(context)}"),
                          )
                        else
                          TextField(
                            controller: _answerController,
                            decoration: const InputDecoration(
                              labelText: "Your Answer",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        const SizedBox(height: 10),
                        if (_answeredQuestions.length < _questions.length - 1)
                          ElevatedButton(
                            onPressed: () {
                              if (_answerController.text.isNotEmpty) {
                                _nextQuestion(_answerController.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown),
                            child: const Text("Next",
                                style: TextStyle(color: Colors.white)),
                          ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
