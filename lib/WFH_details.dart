// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class WorkFromHomeDetailsPage extends StatefulWidget {
//   const WorkFromHomeDetailsPage({super.key});

//   @override
//   _WorkFromHomeDetailsPageState createState() => _WorkFromHomeDetailsPageState();
// }

// class _WorkFromHomeDetailsPageState extends State<WorkFromHomeDetailsPage> {
//   String? managerDepartment;

//   @override
//   void initState() {
//     super.initState();
//     _fetchManagerDepartment();
//   }

//   Future<void> _fetchManagerDepartment() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         String? email = user.email;

//         if (email != null) {
//           // Fetch the department of the manager from the 'users' collection
//           QuerySnapshot userSnapshot = await FirebaseFirestore.instance
//               .collection('users')
//               .where('email', isEqualTo: email)
//               .get();

//           if (userSnapshot.docs.isNotEmpty) {
//             setState(() {
//               managerDepartment = userSnapshot.docs.first['department'] ?? 'Unknown';
//             });
//           } else {
//             throw 'Manager document not found';
//           }
//         }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching department: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Work From Home Requests"),
//       ),
//       body: managerDepartment == null
//           ? const Center(child: CircularProgressIndicator())
//           : StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('workFromHomeRequests')
//                   .where('status', isEqualTo: 'pending')
//                   .where('department', isEqualTo: managerDepartment) // Filter by department
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text("No work from home requests available"));
//                 }

//                 return ListView(
//                   children: snapshot.data!.docs.map((doc) {
//                     String requestId = doc.id;
//                     String employeeName = doc['username'] ?? 'N/A';
//                     String email = doc['email'] ?? 'N/A';
//                     DateTime requestDate = (doc['timestamp'] as Timestamp).toDate();
//                     String reason = doc['reason'] ?? 'No reason provided';
//                     String department = doc['department'] ?? 'N/A';

//                     return Card(
//                       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                       child: ListTile(
//                         title: Text("Employee: $employeeName"),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Email: $email"),
//                             Text("Department: $department"),
//                             Text("Request Date: ${requestDate.day}-${requestDate.month}-${requestDate.year}"),
//                             Text("Reason: $reason"),
//                           ],
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.check, color: Colors.green),
//                               onPressed: () {
//                                 _updateRequestStatus(requestId, 'approved');
//                               },
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.close, color: Colors.red),
//                               onPressed: () {
//                                 _updateRequestStatus(requestId, 'rejected');
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//     );
//   }

//   Future<void> _updateRequestStatus(String requestId, String status) async {
//     await FirebaseFirestore.instance
//         .collection('workFromHomeRequests')
//         .doc(requestId)
//         .update({'status': status});
//   }
// }
