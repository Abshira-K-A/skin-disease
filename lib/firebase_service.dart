



import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Save Skincare Routine in Firestore
  Future<void> saveSkincareRoutine(String userId, String name, String time, List<String> steps, String repeat) async {
    await _firestore.collection("users").doc(userId).collection("skincare_routines").add({
      "name": name,
      "time": time,
      "steps": steps,
      "repeat": repeat,
      "notificationEnabled": true,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// ✅ Fetch Skincare Routines (Real-time)
  Stream<QuerySnapshot> getUserRoutines(String userId) {
    return _firestore.collection("users").doc(userId).collection("skincare_routines").orderBy("time").snapshots();
  }
}
