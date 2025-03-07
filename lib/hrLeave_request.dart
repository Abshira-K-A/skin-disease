// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class HrLeaveRequestPage extends StatefulWidget {
//   const HrLeaveRequestPage({super.key});

//   @override
//   State<HrLeaveRequestPage> createState() => _HrLeaveRequestPageState();
// }

// class _HrLeaveRequestPageState extends State<HrLeaveRequestPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Leave Requests for HR Approval"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('leaveApplications')
//             .where('managerStatus', isEqualTo: 'approved') // Filter to only show approved by manager
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return const Center(child: Text("Error loading leave requests"));
//           }
//           if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No leave requests available for approval"));
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
//                     "Employee Email: ${request['email'] ?? 'N/A'}\n"
//                     "Username: ${request['username'] ?? 'N/A'}\n"
//                     "Duration: ${request['startDate']} to ${request['endDate']}\n"
//                     "Manager Status: ${request['managerStatus'] ?? 'Unknown'}\n"
//                     "HR Status: ${request['hrStatus'] ?? 'Pending'}",
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.check, color: Colors.green),
//                         onPressed: () async {
//                           // Approve request for HR
//                           await FirebaseFirestore.instance
//                               .collection('leaveApplications')
//                               .doc(request.id)
//                               .update({'hrStatus': 'approved'});
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.close, color: Colors.red),
//                         onPressed: () async {
//                           // Reject request for HR
//                           await FirebaseFirestore.instance
//                               .collection('leaveApplications')
//                               .doc(request.id)
//                               .update({'hrStatus': 'rejected'});
//                         },
//                       ),
//                     ],
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
