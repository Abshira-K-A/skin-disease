// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'hrLeave_request.dart';
// import 'hrManagerLeaveRequests.dart';
// import 'login.dart';
// import 'profile_.dart';
// import 'hrEmployeeDetails.dart';

// class HR extends StatefulWidget {
//   const HR({super.key});

//   @override
//   State<HR> createState() => _HRState();
// }

// class _HRState extends State<HR> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("HR Dashboard"),
//         actions: [
//           // Profile Icon Button on the right side of the AppBar
//           IconButton(
//             icon: const Icon(Icons.account_circle),
//             onPressed: () {
//               // Navigate to the HR profile page
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const EmployeeProfilePage()),
//               );
//             },
//           ),
//           IconButton(
//             onPressed: () {
//               logout(context);
//             },
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.count(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           crossAxisCount: 2,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           children: [
//             StreamBuilder(
//               stream: FirebaseFirestore.instance.collection('users').snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return const Center(child: Text("Error loading data"));
//                 }

//                 int employeeCount = snapshot.data?.docs.length ?? 0;
//                 return DashboardCard(
//                   icon: Icons.group,
//                   title: "Employees",
//                   count: employeeCount,
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const HREmployeeDetailsPage()),
//                     );
//                   },
//                 );
//               },
//             ),
//             StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('leaveApplications')
//                   .where('managerStatus', isEqualTo: 'approved')  // Filter by approved manager status
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return const Center(child: Text("Error loading data"));
//                 }

//                 int leaveRequestCount = snapshot.data?.docs.length ?? 0;
//                 return DashboardCard(
//                   icon: Icons.pending_actions,
//                   title: "Employee Leave",
//                   count: leaveRequestCount,
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const HrLeaveRequestPage()),
//                     );
//                   },
//                 );
//               },
//             ),
//             StreamBuilder(
//   stream: FirebaseFirestore.instance
//       .collection('managerLeaveApplications')
//       .where('hrStatus', isEqualTo: 'Pending')  // Filter by pending status
//       .snapshots(),
//   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (snapshot.hasError) {
//       return const Center(child: Text("Error loading data"));
//     }

//     // Get the number of pending leave requests
//     int managerLeaveRequestCount = snapshot.data?.docs.length ?? 0;

//     return DashboardCard(
//       icon: Icons.assignment,
//       title: "Manager Leave",
//       count: managerLeaveRequestCount,
//       onTap: () {
//         // Navigate to HRManagerLeaveRequests page when tapped
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const HRManagerLeaveRequests()),
//         );
//       },
//     );
//   },
// ),

//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
//   }
// }

// class DashboardCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final int count;
//   final VoidCallback onTap;

//   const DashboardCard({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.count,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 30, color: Colors.blue),
//               const SizedBox(height: 10),
//               Text(
//                 title,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 '$count',
//                 style: const TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ManagerLeaveRequestPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Manager Leave Requests"),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('managerLeaveApplications').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return const Center(child: Text("Error loading leave requests"));
//           }
//           if (snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No manager leave requests available."));
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
//                     "Employee: ${request['email']}\n"
//                     "Duration: ${request['startDate']} to ${request['endDate']}\n"
//                     "Status: ${request['status']}",
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.check, color: Colors.green),
//                         onPressed: () async {
//                           await FirebaseFirestore.instance
//                               .collection('managerLeaveApplications')
//                               .doc(request.id)
//                               .update({'status': 'approved'});
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.close, color: Colors.red),
//                         onPressed: () async {
//                           await FirebaseFirestore.instance
//                               .collection('managerLeaveApplications')
//                               .doc(request.id)
//                               .update({'status': 'rejected'});
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

// // Placeholder pages for navigation items
// class PayComponentsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Pay Components")),
//       body: const Center(child: Text("Pay Components Content")),
//     );
//   }
// }

// class MyProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("My Profile")),
//       body: const Center(child: Text("My Profile Content")),
//     );
//   }
// }

// class ReportsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Reports")),
//       body: const Center(child: Text("Reports Content")),
//     );
//   }
// }

