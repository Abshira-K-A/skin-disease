



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
