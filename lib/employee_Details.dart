// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class EmployeeDetailsPage extends StatefulWidget {
//   const EmployeeDetailsPage({super.key});

//   @override
//   _EmployeeDetailsPageState createState() => _EmployeeDetailsPageState();
// }

// class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
//   String? currentUserDepartment;
//   String? currentUserId;

//   @override
//   void initState() {
//     super.initState();
//     _fetchCurrentUserDetails();
//   }

//   Future<void> _fetchCurrentUserDetails() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       currentUserId = user.uid;
//       // Get the current user's document from the Firestore collection
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();

//       setState(() {
//         currentUserDepartment = userDoc['department'] ?? 'Unknown';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Employee Details")),
//       body: currentUserDepartment == null
//           ? const Center(child: CircularProgressIndicator())
//           : StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('users')
//                   .where('department', isEqualTo: currentUserDepartment)
//                   .where(FieldPath.documentId, isNotEqualTo: currentUserId)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 // Show a loading spinner while waiting for data
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 // Handle errors in the snapshot
//                 if (snapshot.hasError) {
//                   return const Center(child: Text("Error loading data"));
//                 }

//                 // Extract the employee documents
//                 final employees = snapshot.data?.docs ?? [];
//                 if (employees.isEmpty) {
//                   return const Center(child: Text("No employees found."));
//                 }

//                 // Display the list of employees
//                 return ListView.builder(
//                   itemCount: employees.length,
//                   itemBuilder: (context, index) {
//                     // Get employee data
//                     final employee = employees[index].data() as Map<String, dynamic>;
//                     return Card(
//                       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                       child: ListTile(
//                         title: Text(employee['firstName'] ?? 'No Name'),
//                         subtitle: Text('Email: ${employee['email'] ?? 'No Email'}'),
//                         onTap: () {
//                           // Optionally, navigate to a detailed view of the employee
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => EmployeeProfileDetail(employee: employee),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }

// // Detailed view for an individual employee
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
//               'Phone: ${employee['phone'] ?? 'N/A'}',
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             // Add more fields as necessary
//           ],
//         ),
//       ),
//     );
//   }
// }
