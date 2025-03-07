// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class WorkFromHomePage extends StatefulWidget {
//   const WorkFromHomePage({super.key});

//   @override
//   _WorkFromHomePageState createState() => _WorkFromHomePageState();
// }

// class _WorkFromHomePageState extends State<WorkFromHomePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _reasonController = TextEditingController();
//   final _startDateController = TextEditingController();
//   final _endDateController = TextEditingController();

//   Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         controller.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
//       });
//     }
//   }

//   Future<void> _submitRequest() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         User? user = FirebaseAuth.instance.currentUser;
//         String? email = user?.email;

//         if (email != null) {
//           // Query the 'users' collection to fetch the username and department of the logged-in user
//           QuerySnapshot userSnapshot = await FirebaseFirestore.instance
//               .collection('users')
//               .where('email', isEqualTo: email)
//               .get();

//           if (userSnapshot.docs.isNotEmpty) {
//             DocumentSnapshot userDoc = userSnapshot.docs.first;
//             String username = userDoc['username'] ?? 'Unknown User';
//             String department = userDoc['department'] ?? 'Unknown Department'; // Fetch department

//             // Add the work from home request along with the department to Firestore
//             await FirebaseFirestore.instance.collection('workFromHomeRequests').add({
//               'email': email,
//               'username': username,
//               'department': department,  // Add department field
//               'reason': _reasonController.text,
//               'startDate': _startDateController.text,
//               'endDate': _endDateController.text,
//               'status': 'pending',
//               'timestamp': FieldValue.serverTimestamp(),
//             });

//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Work from Home request submitted successfully')),
//             );

//             // Clear the input fields after submission
//             _reasonController.clear();
//             _startDateController.clear();
//             _endDateController.clear();
//           } else {
//             throw 'User document not found';
//           }
//         } else {
//           throw 'User not logged in';
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error submitting request: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Work from Home Request"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   controller: _reasonController,
//                   decoration: const InputDecoration(
//                     labelText: 'Reason for Work from Home',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the reason';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _startDateController,
//                   decoration: const InputDecoration(
//                     labelText: 'Start Date',
//                     border: OutlineInputBorder(),
//                   ),
//                   readOnly: true,
//                   onTap: () {
//                     _selectDate(context, _startDateController);
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the start date';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _endDateController,
//                   decoration: const InputDecoration(
//                     labelText: 'End Date',
//                     border: OutlineInputBorder(),
//                   ),
//                   readOnly: true,
//                   onTap: () {
//                     _selectDate(context, _endDateController);
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the end date';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: _submitRequest,
//                   child: const Text('Submit Request'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

