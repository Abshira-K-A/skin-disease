// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class LeaveApplicationDetailsPage extends StatelessWidget {
//   final DocumentSnapshot leaveApplication;

//   LeaveApplicationDetailsPage({super.key, required this.leaveApplication});

//   final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

//   // Function to update the leave request status (only for managerStatus)
//   Future<void> updateLeaveStatus(String leaveId, String status) async {
//     try {
//       // Only update the managerStatus
//       await FirebaseFirestore.instance
//           .collection('leaveApplications')
//           .doc(leaveId)
//           .update({'managerStatus': status});
//     } catch (e) {
//       print("Error updating leave status: $e");
//     }
//   }

//   // Function to get manager's department
//   Future<String> _getManagerDepartment() async {
//     final User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       throw Exception('User not authenticated');
//     }
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();
//       return userDoc['department'] ?? ''; // Return manager's department
//     } catch (e) {
//       throw Exception('Error fetching manager department: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String leaveType = leaveApplication['leaveType'] ?? 'N/A';
//     String startDate = leaveApplication['startDate'] ?? 'N/A';
//     String endDate = leaveApplication['endDate'] ?? 'N/A';
//     String applicationDate = leaveApplication['applicationDate'] ?? 'N/A';
//     String employeeEmail = leaveApplication['email'] ?? 'N/A';
//     String managerStatus = leaveApplication['managerStatus'] ?? 'N/A'; // Changed to managerStatus
//     String leaveId = leaveApplication.id;

//     // Convert the start and end date to DateTime to calculate the duration
//     DateTime startDateTime = dateFormat.parse(startDate);
//     DateTime endDateTime = dateFormat.parse(endDate);
//     Duration leaveDuration = endDateTime.difference(startDateTime);

//     // Fetch user details (e.g., firstName) based on email
//     return FutureBuilder<QuerySnapshot>( 
//       future: FirebaseFirestore.instance
//           .collection('users')
//           .where('email', isEqualTo: employeeEmail)
//           // Query based on the 'email' field
//           .get(),
//       builder: (context, userSnapshot) {
//         if (userSnapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (userSnapshot.hasError) {
//           return Center(child: Text('Error: ${userSnapshot.error}'));
//         }

//         if (userSnapshot.data == null || userSnapshot.data!.docs.isEmpty) {
//           return const Center(child: Text('User not found'));
//         }

//         // Get the firstName from the user data
//         String firstName = userSnapshot.data!.docs[0]['firstName'] ?? 'N/A';
//         String employeeDepartment = userSnapshot.data!.docs[0]['department'] ?? '';

//         return FutureBuilder<String>(
//           future: _getManagerDepartment(),
//           builder: (context, managerSnapshot) {
//             if (managerSnapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (managerSnapshot.hasError) {
//               return Center(child: Text('Error: ${managerSnapshot.error}'));
//             }

//             String managerDepartment = managerSnapshot.data ?? '';

//             // Check if employee's department matches manager's department
//             if (employeeDepartment != managerDepartment) {
//               return const Center(child: Text('Sorry, you do not have permission to view this request.'));
//             }

//             return Scaffold(
//               appBar: AppBar(
//                 title: const Text('Leave Application Details'),
//               ),
//               body: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Employee Name: $firstName', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     Text('Leave Type: $leaveType', style: const TextStyle(fontSize: 18)),
//                     const SizedBox(height: 8),
//                     Text('Email: $employeeEmail'),
//                     Text('Leave Duration: ${leaveDuration.inDays} days'),
//                     Text('Start Date: $startDate'),
//                     Text('End Date: $endDate'),
//                     Text('Application Date: $applicationDate'),
//                     Text('Manager Status: $managerStatus'), // Display the managerStatus
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () => _approveLeave(context, leaveId, managerStatus),
//                           child: const Text('Approve'),
//                           style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                         ),
//                         ElevatedButton(
//                           onPressed: () => _rejectLeave(context, leaveId, managerStatus),
//                           child: const Text('Reject'),
//                           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // Approve leave request
//   void _approveLeave(BuildContext context, String leaveId, String managerStatus) {
//     String message = managerStatus == 'approved'
//         ? 'This leave request is already approved. Do you want to change the status?'
//         : 'Are you sure you want to approve this leave request?';
    
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Approve Leave Request'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 updateLeaveStatus(leaveId, 'approved');
//                 Navigator.of(context).pop();
//                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Leave request approved')));
//               },
//               child: const Text('Yes'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('No'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Reject leave request
//   void _rejectLeave(BuildContext context, String leaveId, String managerStatus) {
//     String message = managerStatus == 'rejected'
//         ? 'This leave request is already rejected. Do you want to change the status?'
//         : 'Are you sure you want to reject this leave request?';

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Reject Leave Request'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 updateLeaveStatus(leaveId, 'rejected');
//                 Navigator.of(context).pop();
//                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Leave request rejected')));
//               },
//               child: const Text('Yes'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('No'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
