

// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirebaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// ✅ Save Skincare Routine with Error Handling
//   Future<void> saveSkincareRoutine(String userId, String products, String timing) async {
//     try {
//       await _firestore.collection("skincare_routines").add({
//         "userId": userId,
//         "products": products,
//         "timing": timing,
//         "createdAt": FieldValue.serverTimestamp(),
//       });
//       print("✅ Skincare routine saved successfully!");
//     } catch (e) {
//       print("❌ Error saving skincare routine: $e");
//     }
//   }

//   /// ✅ Fetch User Routines with Error Handling
//   Stream<QuerySnapshot> getUserRoutines(String userId) {
//     try {
//       return _firestore
//           .collection("skincare_routines")
//           .where("userId", isEqualTo: userId)
//           .snapshots();
//     } catch (e) {
//       print("❌ Error fetching user routines: $e");
//       return const Stream.empty(); // Return empty stream if error
//     }
//   }
// }


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
