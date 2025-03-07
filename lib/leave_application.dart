// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Auth
// import 'package:intl/intl.dart';

// class LeaveApplicationPage extends StatefulWidget {
//   @override
//   _LeaveApplicationPageState createState() => _LeaveApplicationPageState();
// }

// class _LeaveApplicationPageState extends State<LeaveApplicationPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController daysController = TextEditingController();
//   final TextEditingController employeeIdController = TextEditingController();
//   String? employeeEmail;
//   String? selectedLeaveType;
//   final List<String> leaveTypes = ['Sick Leave', 'LOP', 'Casual Leave'];
//   DateTime? startDate;
//   DateTime? endDate;
//   DateTime? applicationDate;
//   final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

//   String? managerDepartment; // To store manager's department
//   String? username; // To store username
//   String? employeeId; // To store employee id

//   @override
//   void initState() {
//     super.initState();
//     fetchUserEmail(); // Fetch email on page load
//     fetchManagerDepartment(); // Fetch manager department on page load
//   }

//   Future<void> fetchUserEmail() async {
//     try {
//       final User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .get();
        
//         setState(() {
//           employeeEmail = userDoc['email'];
//           username = userDoc['firstName']; // Assuming it's firstName
//           employeeId = user.uid; // Assuming employee id is the Firebase user ID
//         });
//       }
//     } catch (e) {
//       print("Error fetching user email: $e");
//     }
//   }

//   Future<void> fetchManagerDepartment() async {
//     try {
//       final User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         // Fetch the user's document to get the department
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .get();

//         setState(() {
//           managerDepartment = userDoc['department']; // Assuming the field is named 'department'
//         });
//       }
//     } catch (e) {
//       print("Error fetching manager department: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Leave Application")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 // Leave Type Dropdown
//                 DropdownButtonFormField<String>(
//                   decoration: const InputDecoration(labelText: 'Leave Type'),
//                   value: selectedLeaveType,
//                   items: leaveTypes.map((String type) {
//                     return DropdownMenuItem<String>(
//                       value: type,
//                       child: Text(type),
//                     );
//                   }).toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       selectedLeaveType = newValue;
//                     });
//                   },
//                   validator: (value) => value == null ? 'Please select a leave type' : null,
//                 ),
//                 const SizedBox(height: 10),
//                 // Start Date Picker
//                 TextFormField(
//                   readOnly: true,
//                   decoration: const InputDecoration(labelText: 'Start Date'),
//                   controller: TextEditingController(
//                     text: startDate != null ? dateFormat.format(startDate!) : '',
//                   ),
//                   onTap: () async {
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime(2101),
//                     );
//                     if (pickedDate != null) {
//                       setState(() {
//                         startDate = pickedDate;
//                       });
//                     }
//                   },
//                   validator: (value) => value == null || value.isEmpty ? 'Please select Start Date' : null,
//                 ),
//                 const SizedBox(height: 10),
//                 // End Date Picker
//                 TextFormField(
//                   readOnly: true,
//                   decoration: const InputDecoration(labelText: 'End Date'),
//                   controller: TextEditingController(
//                     text: endDate != null ? dateFormat.format(endDate!) : '',
//                   ),
//                   onTap: () async {
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime(2101),
//                     );
//                     if (pickedDate != null) {
//                       setState(() {
//                         endDate = pickedDate;
//                       });
//                     }
//                   },
//                   validator: (value) => value == null || value.isEmpty ? 'Please select End Date' : null,
//                 ),
//                 const SizedBox(height: 10),
//                 // Number of Days
//                 TextFormField(
//                   controller: daysController,
//                   decoration: const InputDecoration(labelText: 'Number of Days'),
//                   keyboardType: TextInputType.number,
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter number of days' : null,
//                 ),
//                 const SizedBox(height: 10),
//                 // Application Date Picker
//                 TextFormField(
//                   readOnly: true,
//                   decoration: const InputDecoration(labelText: 'Application Date'),
//                   controller: TextEditingController(
//                     text: applicationDate != null ? dateFormat.format(applicationDate!) : '',
//                   ),
//                   onTap: () async {
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime(2101),
//                     );
//                     if (pickedDate != null) {
//                       setState(() {
//                         applicationDate = pickedDate;
//                       });
//                     }
//                   },
//                   validator: (value) => value == null || value.isEmpty ? 'Please select Application Date' : null,
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       submitLeaveApplication();
//                     }
//                   },
//                   child: const Text("Submit Leave Request"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> submitLeaveApplication() async {
//     try {
//       final User? user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         throw Exception('User is not authenticated');
//       }

//       String employeeId = user.uid;

//       // Add the leave application to Firestore with the manager's department, employee info, and initial status fields
//       await FirebaseFirestore.instance.collection('leaveApplications').add({
//         'leaveType': selectedLeaveType,
//         'startDate': startDate != null ? dateFormat.format(startDate!) : null,
//         'endDate': endDate != null ? dateFormat.format(endDate!) : null,
//         'numberOfDays': int.tryParse(daysController.text),
//         'applicationDate': applicationDate != null ? dateFormat.format(applicationDate!) : null,
//         'email': employeeEmail,
//         // 'status': 'pending',
//         'userid': user.uid,
//         'department': managerDepartment, // Assuming the field is named 'department'
//         'username': username, // Assuming the employee's first name is used as username
//         'managerStatus': 'Pending', // Initialize manager approval status
//         'hrStatus': 'Pending', // Initialize HR approval status
//       });

//       // Show a confirmation dialog
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Leave Request Submitted'),
//             content: const Text('Your leave request has been successfully submitted.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     } catch (e) {
//       print("Error submitting leave application: $e");
//       // Show error message to user
//     }
//   }
// }
