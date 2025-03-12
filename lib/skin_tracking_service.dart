// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;

// void main() {
//   runApp(SkinCureApp());
// }

// class SkinCureApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'SkinCure AI',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: SkinDetectionPage(),
//     );
//   }
// }

// class SkinDetectionPage extends StatefulWidget {
//   @override
//   _SkinDetectionPageState createState() => _SkinDetectionPageState();
// }

// class _SkinDetectionPageState extends State<SkinDetectionPage> {
//   Interpreter? _interpreter;
//   File? _image1;
//   File? _image2;
//   double? similarityScore;
  
//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//   }

//   Future<void> loadModel() async {
//     _interpreter = await Interpreter.fromAsset('assets/skin_model.tflite');
//   }

//   Future<void> pickImage(bool isFirst) async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         if (isFirst) {
//           _image1 = File(pickedFile.path);
//         } else {
//           _image2 = File(pickedFile.path);
//         }
//       });
//     }
//   }

//   Future<void> analyzeImages() async {
//     if (_image1 == null || _image2 == null) return;
    
//     var input1 = preprocessImage(_image1!);
//     var input2 = preprocessImage(_image2!);
    
//     var output1 = List.filled(1280, 0.0).reshape([1, 1280]);
//     var output2 = List.filled(1280, 0.0).reshape([1, 1280]);
    
//     _interpreter!.run(input1, output1);
//     _interpreter!.run(input2, output2);
    
//     double similarity = cosineSimilarity(output1[0], output2[0]);
    
//     setState(() {
//       similarityScore = similarity;
//     });
//   }

//   List<List<double>> preprocessImage(File imageFile) {
//     img.Image image = img.decodeImage(imageFile.readAsBytesSync())!;
//     image = img.copyResize(image, width: 224, height: 224);
    
//     List<double> imageData = image.getBytes().map((e) => e / 255.0).toList();
//     return [imageData];
//   }

//   double cosineSimilarity(List<double> a, List<double> b) {
//     double dotProduct = 0.0;
//     double normA = 0.0;
//     double normB = 0.0;
    
//     for (int i = 0; i < a.length; i++) {
//       dotProduct += a[i] * b[i];
//       normA += a[i] * a[i];
//       normB += b[i] * b[i];
//     }
//     return dotProduct / (normA.sqrt() * normB.sqrt());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('SkinCure AI')),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _image1 != null ? Image.file(_image1!, height: 100) : Container(),
//           ElevatedButton(
//             onPressed: () => pickImage(true),
//             child: Text('Pick First Image'),
//           ),
//           _image2 != null ? Image.file(_image2!, height: 100) : Container(),
//           ElevatedButton(
//             onPressed: () => pickImage(false),
//             child: Text('Pick Second Image'),
//           ),
//           ElevatedButton(
//             onPressed: analyzeImages,
//             child: Text('Analyze Skin Changes'),
//           ),
//           if (similarityScore != null)
//             Text('Similarity Score: ${similarityScore!.toStringAsFixed(2)}'),
//         ],
//       ),
//     );
//   }
// }

// extension on double {
//   sqrt() {}
// }



import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class SkinTrackingService {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker picker = ImagePicker();

  Future<String?> uploadImage(String userId) async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    File file = File(pickedFile.path);
    String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
    Reference ref = storage.ref().child('skin_images/$userId/$fileName');

    await ref.putFile(file);
    String downloadUrl = await ref.getDownloadURL();

    await firestore.collection('skinTracking').doc(userId).collection('uploads').add({
      'imageUrl': downloadUrl,
      'timestamp': DateTime.now(),
    });

    return downloadUrl;
  }
}
