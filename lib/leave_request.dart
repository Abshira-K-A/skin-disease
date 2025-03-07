
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:real_project/leave_applicationdetails.dart';

// class LeaveApplicationsPage extends StatelessWidget {
//   final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

//   // Function to fetch the department of the currently logged-in user
//   Future<String> _getUserDepartment() async {
//     final User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       throw Exception('User not authenticated');
//     }
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();
//       return userDoc['department'] ?? ''; // Return the user's department
//     } catch (e) {
//       throw Exception('Error fetching user department: $e');
//     }
//   }

//   // Function to fetch and display leave applications for the logged-in user's department
//   Future<List<DocumentSnapshot>> fetchLeaveApplications(String department) async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('leaveApplications')
//         .where('department', isEqualTo: department) // Filter by department
//         .orderBy('applicationDate', descending: true) // Order by application date (descending)
//         .get();

//     return querySnapshot.docs;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String>(
//       future: _getUserDepartment(), // Fetch the user's department
//       builder: (context, departmentSnapshot) {
//         if (departmentSnapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (departmentSnapshot.hasError) {
//           return Center(child: Text('Error: ${departmentSnapshot.error}'));
//         }

//         String department = departmentSnapshot.data ?? '';

//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Leave Applications'),
//           ),
//           body: FutureBuilder<List<DocumentSnapshot>>(
//             future: fetchLeaveApplications(department), // Fetch leave applications for the department
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               }

//               if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const Center(child: Text("No leave applications found"));
//               }

//               // Display the list of leave applications
//               return ListView.builder(
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   var leaveApplication = snapshot.data![index];

//                   String leaveType = leaveApplication['leaveType'] ?? 'N/A';
//                   String employeeEmail = leaveApplication['email'] ?? 'N/A';
//                   String leaveId = leaveApplication.id;

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     child: ListTile(
//                       title: Text('Leave Type: $leaveType'),
//                       subtitle: Text('Email: $employeeEmail'),
//                       onTap: () {
//                         // Navigate to the details page when the tile is tapped
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => LeaveApplicationDetailsPage(leaveApplication: leaveApplication),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
