// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class EmployeeProfilePage  extends StatefulWidget {
//   const EmployeeProfilePage({super.key});

//   @override
//   _EmployeeProfilePageState createState() => _EmployeeProfilePageState();
// }

// class _EmployeeProfilePageState extends State<EmployeeProfilePage> {
//   late Map<String, dynamic> userProfileData;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchProfileDetails();
//   }

//   Future<void> _fetchProfileDetails() async {
//     try {
//       User? currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser != null) {
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(currentUser.uid)
//             .get();

//         setState(() {
//           userProfileData = userDoc.data() as Map<String, dynamic>;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching profile: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Employee Profile"),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Name: ${userProfileData['firstName'] ?? 'Not specified'}',
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Email: ${userProfileData['email']}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Phone: ${userProfileData['phone'] ?? 'Not specified'}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Age: ${userProfileData['age'] ?? 'Not specified'}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Role: ${userProfileData['role'] ?? 'Not specified'}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Gender: ${userProfileData['gender'] ?? 'Not specified'}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Department: ${userProfileData['department'] ?? 'Not specified'}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () async {
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => UpdateProfilePage(userProfileData: userProfileData),
//                         ),
//                       );
//                       // Re-fetch profile details after the update
//                       _fetchProfileDetails();
//                     },
//                     child: const Text("Update Profile"),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

// class UpdateProfilePage extends StatefulWidget {
//   final Map<String, dynamic> userProfileData;

//   const UpdateProfilePage({super.key, required this.userProfileData});

//   @override
//   _UpdateProfilePageState createState() => _UpdateProfilePageState();
// }

// class _UpdateProfilePageState extends State<UpdateProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _positionController;
//   late TextEditingController _phoneController;
//   late TextEditingController _ageController;
//   late TextEditingController _roleController;
//   late TextEditingController _genderController;
//   late TextEditingController _departmentController;

//   @override
//   void initState() {
//     super.initState();
//     _positionController = TextEditingController(text: widget.userProfileData['position'] ?? '');
//     _phoneController = TextEditingController(text: widget.userProfileData['phone'] ?? '');
//     _ageController = TextEditingController(text: widget.userProfileData['age']?.toString() ?? '');
//     _roleController = TextEditingController(text: widget.userProfileData['role'] ?? '');
//     _genderController = TextEditingController(text: widget.userProfileData['gender'] ?? '');
//     _departmentController = TextEditingController(text: widget.userProfileData['department'] ?? '');
//   }

//   Future<void> _updateProfile() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         User? currentUser = FirebaseAuth.instance.currentUser;
//         if (currentUser != null) {
//           await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
//             'position': _positionController.text,
//             'phone': _phoneController.text,
//             'age': int.tryParse(_ageController.text) ?? widget.userProfileData['age'],
//             'role': _roleController.text,
//             'gender': _genderController.text,
//             'department': _departmentController.text,
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Profile updated successfully!')),
//           );
//           Navigator.pop(context);
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error updating profile: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Update Profile"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _positionController,
//                 decoration: const InputDecoration(labelText: 'Position'),
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(labelText: 'Phone'),
//                 keyboardType: TextInputType.phone,
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: _ageController,
//                 decoration: const InputDecoration(labelText: 'Age'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
//                     return 'Please enter a valid number for age';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: _roleController,
//                 decoration: const InputDecoration(labelText: 'Role'),
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: _genderController,
//                 decoration: const InputDecoration(labelText: 'Gender'),
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: _departmentController,
//                 decoration: const InputDecoration(labelText: 'Department'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your department';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _updateProfile,
//                 child: const Text('Update'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
