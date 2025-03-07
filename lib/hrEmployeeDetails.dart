// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class HREmployeeDetailsPage extends StatelessWidget {
//   const HREmployeeDetailsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("HR Employee Details"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('users').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return const Center(child: Text("Error loading data"));
//           }

//           final employees = snapshot.data?.docs ?? [];
//           final filteredEmployees = employees.where((doc) => doc.id != currentUserId).toList();

//           if (filteredEmployees.isEmpty) {
//             return const Center(child: Text("No employees found."));
//           }

//           return ListView.builder(
//             itemCount: filteredEmployees.length,
//             itemBuilder: (context, index) {
//               final employee = filteredEmployees[index].data() as Map<String, dynamic>;
//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: ListTile(
//                   title: Text(employee['firstName'] ?? 'No Name'),
//                   subtitle: Text('Email: ${employee['email'] ?? 'No Email'}'),
//                   onTap: () {
//                     // Optionally, navigate to a detailed view of the employee
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => EmployeeProfileDetail(employee: employee),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class EmployeeProfileDetail extends StatelessWidget {
//   final Map<String, dynamic> employee;

//   const EmployeeProfileDetail({super.key, required this.employee});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(employee['firstName'] ?? 'Employee Profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Name: ${employee['firstName'] ?? 'N/A'}',
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Email: ${employee['email'] ?? 'N/A'}',
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Phone: ${employee['phone'] ?? 'N/A'}', // Assuming 'phone' is a field in Firestore
//               style: const TextStyle(fontSize: 18),
//             ),
//             // Add more fields as necessary
//           ],
//         ),
//       ),
//     );
//   }
// }
