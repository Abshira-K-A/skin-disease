// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:real_project/profile_.dart';
// import 'WFH_application.dart';
// import 'login.dart';
// import 'leave_application.dart';
// import 'workfromhomestatus.dart';
// import 'leave_Status.dart';  // Import the leave status page

// class Employee extends StatefulWidget {
//   const Employee({super.key});

//   @override
//   State<Employee> createState() => _EmployeeState();
// }

// class _EmployeeState extends State<Employee> {
//   final User? currentUser = FirebaseAuth.instance.currentUser;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Employee Dashboard"),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const EmployeeProfilePage()),
//               );
//             },
//             icon: const Icon(Icons.person),
//           ),
//           IconButton(
//             onPressed: () {
//               logout(context);
//             },
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView( // Allow scrolling if content overflows
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: GridView.count(
//             shrinkWrap: true, // Prevent overflow and allows scrolling
//             physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling of GridView
//             crossAxisCount: 2,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             children: [
//               DashboardCard(
//                 icon: Icons.file_copy,
//                 title: "Apply Leave",
//                 description: "Request leave easily",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => LeaveApplicationPage()),
//                   );
//                 },
//               ),
//               DashboardCard(
//                 icon: Icons.check_circle,
//                 title: "Leave Status",
//                 description: "View leave approvals",
//                 onTap: () {
//                   if (currentUser != null) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => LeaveStatusPage(employeeEmail: currentUser!.email!),
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('User not authenticated')),
//                     );
//                   }
//                 },
//               ),
//               DashboardCard(
//                 icon: Icons.work,
//                 title: "Apply Work from Home",
//                 description: "Request WFH",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const WorkFromHomePage()),
//                   );
//                 },
//               ),
//               DashboardCard(
//                 icon: Icons.home_work,
//                 title: "Work Home Request Status",
//                 description: "View WFH requests",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const WorkHomeRequestStatusPage()),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginPage()),
//     );
//   }
// }

// class DashboardCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String description;
//   final VoidCallback onTap;

//   const DashboardCard({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.description,
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
//               Icon(icon, size: 40, color: Colors.blue),
//               const SizedBox(height: 10),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 description,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
