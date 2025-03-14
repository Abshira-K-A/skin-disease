// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class  SkinTrackingPage extends StatefulWidget {
//   const SkinTrackingPage({super.key});

//   @override
//   _SkinTrackingPageState createState() => _SkinTrackingPageState();
// }

// class _SkinTrackingPageState extends State<SkinTrackingPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final ImagePicker _picker = ImagePicker();
//   bool _isUploading = false;




//                      //   Future<void> _uploadImage(ImageSource source) async {
// //   final User? user = _auth.currentUser;
// //   if (user == null) return;

// //   final XFile? image = await _picker.pickImage(source: source);
// //   if (image == null) return;

// //   setState(() {
// //     _isUploading = true;
// //   });

// //   try {
// //     File file = File(image.path);
// //     String fileName = "${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg";
// //     Reference ref = _storage.ref().child("skin_tracking/$fileName");
// //     UploadTask uploadTask = ref.putFile(file);

// //     TaskSnapshot snapshot = await uploadTask;
// //     String imageUrl = await snapshot.ref.getDownloadURL();

// //     // Store image URL in Firestore
// //     await _firestore.collection("skinTracking").add({
// //       "userId": user.uid,
// //       "imageUrl": imageUrl,
// //       "timestamp": Timestamp.now(),
// //     });

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text("Image uploaded successfully!")),
// //     );
// //   } catch (e) {
// //     print("Upload Error: $e");
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text("Failed to upload image")),
// //     );
// //   } finally {
// //     setState(() {
// //       _isUploading = false;
// //     });
// //   }
//                                                                 // }


// Future<void> _uploadImage(ImageSource source) async {
//   final User? user = _auth.currentUser;
//   if (user == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("User not logged in!")),
//     );
//     return;
//   }

//   final XFile? image = await _picker.pickImage(source: source);
//   if (image == null) return;

//   setState(() {
//     _isUploading = true;
//   });

//   try {
//     File file = File(image.path);
//     String fileName = "${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg";
//     Reference ref = _storage.ref().child("skin_tracking/$fileName");

//     // Upload file and handle errors properly
//     UploadTask uploadTask = ref.putFile(file);
//     TaskSnapshot snapshot = await uploadTask.catchError((error) {
//       throw Exception("Upload failed: $error");
//     });

//     String imageUrl = await snapshot.ref.getDownloadURL();

//     // Store image URL in Firestore
//     await _firestore.collection("skinTracking").add({
//       "userId": user.uid,
//       "imageUrl": imageUrl,
//       "timestamp": Timestamp.now(),
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Image uploaded successfully!")),
//     );
//   } catch (e) {
//     print("Upload Error: $e");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Failed to upload image: $e")),
//     );
//   } finally {
//     setState(() {
//       _isUploading = false;
//     });
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     final User? user = _auth.currentUser;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Skin Tracking"),
//         backgroundColor: Colors.deepOrangeAccent,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 10),

//           // Upload Image Buttons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () => _uploadImage(ImageSource.camera),
//                 icon: const Icon(Icons.camera),
//                 label: const Text("Capture"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepOrangeAccent,
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               ElevatedButton.icon(
//                 onPressed: () => _uploadImage(ImageSource.gallery),
//                 icon: const Icon(Icons.image),
//                 label: const Text("Gallery"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepOrangeAccent,
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 20),

//           // Show Loading Indicator
//           if (_isUploading)
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: CircularProgressIndicator(),
//             ),

//           // Display Uploaded Images
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection("skinTracking")
//                   .where("userId", isEqualTo: user?.uid)
//                   .orderBy("timestamp", descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text("No images uploaded yet."));
//                 }

//                 return ListView(
//                   children: snapshot.data!.docs.map((doc) {
//                     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//                     return Card(
//                       margin: const EdgeInsets.all(10),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       elevation: 5,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           ClipRRect(
//                             borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
//                             child: Image.network(
//                               data["imageUrl"],
//                               height: 250,
//                               fit: BoxFit.cover,
//                               loadingBuilder: (context, child, loadingProgress) {
//                                 if (loadingProgress == null) return child;
//                                 return const Center(child: CircularProgressIndicator());
//                               },
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Text(
//                               "Uploaded on: ${DateTime.fromMillisecondsSinceEpoch(data["timestamp"].millisecondsSinceEpoch).toLocal()}",
//                               style: const TextStyle(fontSize: 14, color: Colors.black54),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class SkinTrackingPage extends StatefulWidget {
  const SkinTrackingPage({super.key});

  @override
  _SkinTrackingPageState createState() => _SkinTrackingPageState();
}

class _SkinTrackingPageState extends State<SkinTrackingPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker picker = ImagePicker();

  bool isUploading = false;

  Future<void> uploadImage(String userId) async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      isUploading = true;
    });

    try {
      File file = File(pickedFile.path);
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
      Reference ref = storage.ref().child('skin_images/$userId/$fileName');

      await ref.putFile(file);
      String downloadUrl = await ref.getDownloadURL();

      await firestore.collection('skinTracking').doc(userId).collection('uploads').add({
        'imageUrl': downloadUrl,
        'timestamp': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image uploaded successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading image: $e")),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Skin Tracking"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Replace 'userId' with the actual user ID
                uploadImage("userId");
              },
              icon: const Icon(Icons.upload),
              label: const Text("Upload Skin Image"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            if (isUploading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
