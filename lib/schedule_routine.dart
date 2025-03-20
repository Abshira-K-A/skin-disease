// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../notification_service.dart';

// class ScheduleRoutinePage extends StatefulWidget {
//   final String userId;

//   const ScheduleRoutinePage({super.key, required this.userId});

//   @override
//   _ScheduleRoutinePageState createState() => _ScheduleRoutinePageState();
// }

// class _ScheduleRoutinePageState extends State<ScheduleRoutinePage> {
//   final TextEditingController _answerController = TextEditingController();
//   TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 30); // Default time
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
//   List<Map<String, String>> _answeredQuestions = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
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

//   Future<void> _storeAnswerInFirebase(String question, String answer) async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(widget.userId)
//         .collection('skincare_routines')
//         .add({
//       'question': question,
//       'answer': answer,
//       'timestamp': Timestamp.now(),
//     });
//   }

//   void _nextQuestion(String answer) {
//     setState(() {
//       _answeredQuestions.add({
//         'question': _questions[_answeredQuestions.length],
//         'answer': answer
//       });
//     });

//     _storeAnswerInFirebase(
//         _questions[_answeredQuestions.length - 1], answer);

//     if (_answeredQuestions.length < _questions.length) {
//       _answerController.clear();
//     }
//   }

//   Future<void> _pickTime(BuildContext context) async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         _selectedTime = pickedTime;
//       });

//       final now = DateTime.now();
//       final scheduledDateTime = DateTime(
//         now.year,
//         now.month,
//         now.day,
//         _selectedTime.hour,
//         _selectedTime.minute,
//       );

//       _nextQuestion("Reminder set at ${_selectedTime.format(context)}");

//       // Schedule Notification
//       NotificationService.scheduleNotification(
//         0, // Unique notification ID
//         "Skincare Routine",
//         "It's time for your skincare routine!", // Notification body
//         scheduledDateTime,
//       );

//       // Show Snackbar after setting reminder
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Reminder set successfully for ${_selectedTime.format(context)}!"),
//           duration: Duration(seconds: 2),
//         ),
//       );
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
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 600),
//                     child: Text(
//                       "Hey $username! You have $skinType skin, so let's schedule your routine! 🌟",
//                       key: ValueKey<String>("Hey $username! You have $skinType skin."),
//                       style: GoogleFonts.lobster(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.deepOrange,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Column(
//                     children: _answeredQuestions.map((entry) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               entry['question']!,
//                               style: GoogleFonts.robotoSlab(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               "➡ ${entry['answer']!}",
//                               style: const TextStyle(fontSize: 16, color: Colors.black54),
//                             ),
//                             const Divider(),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   if (_answeredQuestions.length < _questions.length)
//                     Column(
//                       children: [
//                         Text(
//                           _questions[_answeredQuestions.length],
//                           style: GoogleFonts.robotoSlab(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         if (_answeredQuestions.length == _questions.length - 1)
//                           ElevatedButton(
//                             onPressed: () => _pickTime(context),
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.deepOrangeAccent),
//                             child: Text("Pick Reminder Time"),
//                           )
//                         else
//                           TextField(
//                             controller: _answerController,
//                             decoration: const InputDecoration(
//                               labelText: "Your Answer",
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                         const SizedBox(height: 10),
//                         if (_answeredQuestions.length < _questions.length - 1)
//                           ElevatedButton(
//                             onPressed: () {
//                               if (_answerController.text.isNotEmpty) {
//                                 _nextQuestion(_answerController.text);
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.brown),
//                             child: const Text("Next",
//                                 style: TextStyle(color: Colors.white)),
//                           ),
//                       ],
//                     ),
//                 ],
//               ),
//             ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../notification_service.dart';

class ScheduleRoutinePage extends StatefulWidget {
  final String userId;

  const ScheduleRoutinePage({super.key, required this.userId});

  @override
  _ScheduleRoutinePageState createState() => _ScheduleRoutinePageState();
}

class _ScheduleRoutinePageState extends State<ScheduleRoutinePage> {
  final TextEditingController _answerController = TextEditingController();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 30); // Default time
  String? username;
  String? skinType;
  bool _isLoading = true;
  bool _reminderSet = false; // ✅ Track if reminder is set

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
        _questions[_answeredQuestions.length - 1], answer);

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
        _reminderSet = true; // ✅ Mark reminder as set
      });

      final now = DateTime.now();
      final scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      _nextQuestion("Reminder set at ${_selectedTime.format(context)}");

      // ✅ Schedule Notification
      NotificationService.scheduleNotification(
        0, // Unique notification ID
        "Skincare Routine", 
        "It's time for your skincare routine!", // Notification body
        scheduledDateTime, // Scheduled DateTime
      );

      // ✅ Show Snackbar After Setting Reminder
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Reminder set successfully at ${_selectedTime.format(context)}"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ Prevents keyboard overflow issues
      appBar: AppBar(
        title: const Text("Schedule Skincare Routine"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView( // ✅ Fixes overflow issue
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      "Hey $username! You have $skinType skin, so let's schedule your routine! 🌟",
                      key: ValueKey<String>("Hey $username! You have $skinType skin."),
                      style: GoogleFonts.lobster(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                              ),
                            ),
                            Text(
                              "➡ ${entry['answer']!}",
                              style: const TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  if (_answeredQuestions.length < _questions.length)
                    Column(
                      children: [
                        Text(
                          _questions[_answeredQuestions.length],
                          style: GoogleFonts.robotoSlab(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_answeredQuestions.length == _questions.length - 1)
                          ElevatedButton(
                            onPressed: () => _pickTime(context),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrangeAccent),
                            child: Text("Pick Reminder Time"),
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
