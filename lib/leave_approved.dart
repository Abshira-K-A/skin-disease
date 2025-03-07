// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ApprovedLeavePage extends StatelessWidget {
//   const ApprovedLeavePage({super.key});

//   Future<String> getManagerDepartment() async {
//     // Replace 'users' with your actual users collection name
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid) // Ensure the user ID matches your document ID structure
//           .get();
//       return snapshot['department'] ?? 'N/A';
//     }
//     return 'N/A';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Approved Leave Requests"),
//       ),
//       body: FutureBuilder<String>(
//         future: getManagerDepartment(),
//         builder: (context, departmentSnapshot) {
//           if (departmentSnapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!departmentSnapshot.hasData || departmentSnapshot.data == 'N/A') {
//             return const Center(child: Text("Unable to fetch department data"));
//           }

//           String managerDepartment = departmentSnapshot.data!;

//           return StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection('leaveApplications')
//                 .where('managerStatus', isEqualTo: 'approved')
//                 .where('department', isEqualTo: managerDepartment)
//                 .snapshots(),
//             builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 return const Center(child: Text("No approved leave requests"));
//               }

//               return ListView(
//                 children: snapshot.data!.docs.map((doc) {
//                   final String email = doc['email'] ?? 'N/A';
//                   final String leaveType = doc['leaveType'] ?? 'N/A';

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     child: ListTile(
//                       title: Text("Leave Type: $leaveType"),
//                       subtitle: Text("Email: $email"),
//                       trailing: const Icon(Icons.check_circle, color: Colors.green),
//                     ),
//                   );
//                 }).toList(),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


  