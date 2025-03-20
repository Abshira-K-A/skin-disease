



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
