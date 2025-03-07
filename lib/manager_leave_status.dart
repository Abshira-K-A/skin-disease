// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ManagerLeaveStatus extends StatelessWidget {
//   const ManagerLeaveStatus({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Get the current user's ID
//     String currentUserId = FirebaseAuth.instance.currentUser!.uid;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Manager Leave Status"),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('managerLeaveApplications')
//             .where('userid', isEqualTo: currentUserId) // Filter by the current user's ID
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return const Center(child: Text("Error loading data"));
//           }
//           if (snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No leave requests available."));
//           }

//           final leaveRequests = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: leaveRequests.length,
//             itemBuilder: (context, index) {
//               var request = leaveRequests[index];
//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                 child: ListTile(
//                   title: Text("Leave Type: ${request['leaveType'] ?? 'Unknown'}"),
//                   subtitle: Text(
//                     "Application Date: ${request['applicationDate'] ?? 'Unknown'}\n"
//                     "Duration: ${request['startDate']} to ${request['endDate']}\n"
//                     "HR Status: ${request['hrStatus'] ?? 'Not Available'}",
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
