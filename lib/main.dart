import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'main_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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



// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'skin_tracking_service.dart';
// import 'skin_tracking_feedback.dart';

// class SkinTrackingPage extends StatefulWidget {
//   @override
//   _SkinTrackingPageState createState() => _SkinTrackingPageState();
// }

// class _SkinTrackingPageState extends State<SkinTrackingPage> {
//   final SkinTrackingService service = SkinTrackingService();
//   final SkinTrackingFeedback feedbackService = SkinTrackingFeedback();
//   File? _image;
//   String feedback = "Upload an image to get insights";

//   Future<void> pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() => _image = File(pickedFile.path));
//       await service.uploadImage("user123");
//       String result = await feedbackService.getFeedback("user123");
//       setState(() => feedback = result);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Skin Tracking")),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _image != null ? Image.file(_image!) : Text("No Image Selected"),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: pickImage,
//             child: Text("Upload & Analyze"),
//           ),
//           SizedBox(height: 20),
//           Text(feedback, textAlign: TextAlign.center),
//         ],
//       ),
//     );
//   }
// }
