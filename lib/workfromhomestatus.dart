// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class WorkHomeRequestStatusPage extends StatelessWidget {
//   const WorkHomeRequestStatusPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Work from Home Request Status"),
//       ),
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, userSnapshot) {
//           if (userSnapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!userSnapshot.hasData) {
//             return const Center(child: Text("No user logged in"));
//           }

//           // Get the current user's email
//           String userEmail = userSnapshot.data!.email!;

//           return StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('workFromHomeRequests')
//                 .where('email', isEqualTo: userEmail)
//                 .snapshots(),
//             builder: (context, requestSnapshot) {
//               if (requestSnapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (!requestSnapshot.hasData || requestSnapshot.data!.docs.isEmpty) {
//                 return const Center(child: Text("No work from home requests found"));
//               }

//               var requests = requestSnapshot.data!.docs;

//               return ListView.builder(
//                 itemCount: requests.length,
//                 itemBuilder: (context, index) {
//                   var request = requests[index];
//                   var status = request['status'] ?? 'N/A';
//                   var startDate = request['startDate'] ?? 'N/A';
//                   var endDate = request['endDate'] ?? 'N/A';
//                   var reason = request['reason'] ?? 'No reason provided';

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     child: ListTile(
//                       title: Text('Request Status: $status'),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Start Date: $startDate'),
//                           Text('End Date: $endDate'),
//                           Text('Reason: $reason'),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
