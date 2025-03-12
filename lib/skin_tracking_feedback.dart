import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class SkinTrackingFeedback {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> getFeedback(String userId) async {
    var snapshots = await firestore.collection('skinTracking').doc(userId).collection('uploads').orderBy('timestamp', descending: true).limit(2).get();

    if (snapshots.docs.length < 2) return "Not enough images to track progress.";

    var oldImage = snapshots.docs[1]['imageUrl'];
    var newImage = snapshots.docs[0]['imageUrl'];

    double difference = Random().nextDouble(); // Placeholder for pixel difference analysis

    if (difference < 0.2) {
      return "Your skin is improving! Keep using your current routine.";
    } else {
      return "Your skin condition has worsened. Consider changing your skincare routine.";
    }
  }
}
