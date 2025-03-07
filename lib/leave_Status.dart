// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class LeaveStatusPage extends StatelessWidget {
//   final String employeeEmail;

//   const LeaveStatusPage({super.key, required this.employeeEmail});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Leave Status"),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('leaveApplications')
//             .where('email', isEqualTo: employeeEmail) // Filter by employee's email
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No leave requests found"));
//           }

//           return ListView(
//             children: snapshot.data!.docs.map((doc) {
//               final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
//               final String applicationDate = doc['applicationDate'] ?? 'N/A';
//               final String startDate = doc['startDate'] ?? 'N/A';
//               final String endDate = doc['endDate'] ?? 'N/A';
//               final String leaveType = doc['leaveType'] ?? 'N/A';
//               final String managerStatus = doc['managerStatus'] ?? 'Pending';
//               final String hrStatus = doc['hrStatus'] ?? 'Pending';

//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Leave Type: $leaveType',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text('Application Date: $applicationDate'),
//                       Text('Start Date: $startDate'),
//                       Text('End Date: $endDate'),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Manager Status: $managerStatus',
//                         style: TextStyle(
//                           color: managerStatus == 'Approved'
//                               ? Colors.green
//                               : managerStatus == 'Rejected'
//                                   ? Colors.red
//                                   : Colors.orange,
//                         ),
//                       ),
//                       Text(
//                         'HR Status: $hrStatus',
//                         style: TextStyle(
//                           color: hrStatus == 'Approved'
//                               ? Colors.green
//                               : hrStatus == 'Rejected'
//                                   ? Colors.red
//                                   : Colors.orange,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

