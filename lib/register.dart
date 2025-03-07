// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'login.dart';

// // class Register extends StatefulWidget {
// //   const Register({super.key});

// //   @override
// //   _RegisterState createState() => _RegisterState();
// // }

// // class _RegisterState extends State<Register> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _auth = FirebaseAuth.instance;

// //   bool _showProgress = false;
// //   bool _isPasswordObscure = true;
// //   bool _isConfirmPasswordObscure = true;

// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //   final TextEditingController confirmPasswordController = TextEditingController();
// //   final TextEditingController nameController = TextEditingController();
// //   final TextEditingController lastNameController = TextEditingController();
// //   final TextEditingController usernameController = TextEditingController();
// //   final TextEditingController ageController = TextEditingController();
// //   final TextEditingController phoneController = TextEditingController();

// //   List<String> roles = ['Employee', 'HR', 'Manager'];
// //   String selectedRole = 'Employee';
// //   String selectedGender = 'Male';

// //   @override
// //   void dispose() {
// //     emailController.dispose();
// //     passwordController.dispose();
// //     confirmPasswordController.dispose();
// //     nameController.dispose();
// //     lastNameController.dispose();
// //     usernameController.dispose();
// //     ageController.dispose();
// //     phoneController.dispose(); 
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.blueAccent[700],
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           child: Column(
// //             children: [
// //               Container(
// //                 color: Colors.blueAccent[700],
// //                 width: MediaQuery.of(context).size.width,
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(12),
// //                   child: Form(
// //                     key: _formKey,
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       crossAxisAlignment: CrossAxisAlignment.center,
// //                       children: [
// //                         const SizedBox(height: 80),
// //                         const Text(
// //                           "Register Now",
// //                           style: TextStyle(
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.white,
// //                             fontSize: 40,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 50),
// //                         _buildTextField(
// //                           controller: nameController,
// //                           hintText: 'First Name',
// //                           validator: _validateName,
// //                         ),
// //                         const SizedBox(height: 20),
// //                         _buildTextField(
// //                           controller: lastNameController,
// //                           hintText: 'Last Name (optional)',
// //                           validator: _validateLastName,  // Updated validator
// //                         ),
// //                         const SizedBox(height: 20),
// //                         _buildTextField(
// //                           controller: usernameController,
// //                           hintText: 'Username',
// //                           validator: _validateUsername,
// //                         ),
// //                         const SizedBox(height: 20),
// //                         _buildTextField(
// //                           controller: emailController,
// //                           hintText: 'Email',
// //                           keyboardType: TextInputType.emailAddress,
// //                           validator: _validateEmail,
// //                         ),
// //                         const SizedBox(height: 20),
// //                         _buildTextField(
// //                           controller: passwordController,
// //                           hintText: 'Password',
// //                           obscureText: _isPasswordObscure,
// //                           suffixIcon: _togglePasswordVisibility(isConfirmPassword: false),
// //                           validator: _validatePassword,
// //                         ),
// //                         const SizedBox(height: 20),
// //                         _buildTextField(
// //                           controller: confirmPasswordController,
// //                           hintText: 'Confirm Password',
// //                           obscureText: _isConfirmPasswordObscure,
// //                           suffixIcon: _togglePasswordVisibility(isConfirmPassword: true),
// //                           validator: _validateConfirmPassword,
// //                         ),
// //                         const SizedBox(height: 20),
// //                         _buildTextField(
// //                           controller: phoneController,
// //                           hintText: 'Phone',
// //                           validator: _validatePhoneNumber,
// //                         ),
// //                         const SizedBox(height: 20),
// //                         _buildTextField(
// //                           controller: ageController,
// //                           hintText: 'Age',
// //                           keyboardType: TextInputType.number,
// //                           validator: _validateAge,
// //                         ),
// //                         const SizedBox(height: 20),
// //                         _buildRoleDropdown(),
// //                         const SizedBox(height: 20),
// //                         _buildGenderDropdown(),
// //                         const SizedBox(height: 20),
// //                         _buildActionButtons(),
// //                         const SizedBox(height: 20),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildTextField({
// //     required TextEditingController controller,
// //     required String hintText,
// //     TextInputType keyboardType = TextInputType.text,
// //     bool obscureText = false,
// //     Widget? suffixIcon,
// //     required String? Function(String?) validator,
// //   }) {
// //     return TextFormField(
// //       controller: controller,
// //       keyboardType: keyboardType,
// //       obscureText: obscureText,
// //       decoration: InputDecoration(
// //         filled: true,
// //         fillColor: Colors.white,
// //         hintText: hintText,
// //         suffixIcon: suffixIcon,
// //         contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
// //         focusedBorder: OutlineInputBorder(
// //           borderSide: const BorderSide(color: Colors.white),
// //           borderRadius: BorderRadius.circular(20),
// //         ),
// //         enabledBorder: UnderlineInputBorder(
// //           borderSide: const BorderSide(color: Colors.white),
// //           borderRadius: BorderRadius.circular(20),
// //         ),
// //       ),
// //       validator: validator,
// //     );
// //   }

// //   Widget _togglePasswordVisibility({required bool isConfirmPassword}) {
// //     return IconButton(
// //       icon: Icon(isConfirmPassword
// //           ? _isConfirmPasswordObscure
// //               ? Icons.visibility_off
// //               : Icons.visibility
// //           : _isPasswordObscure
// //               ? Icons.visibility_off
// //               : Icons.visibility),
// //       onPressed: () {
// //         setState(() {
// //           if (isConfirmPassword) {
// //             _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
// //           } else {
// //             _isPasswordObscure = !_isPasswordObscure;
// //           }
// //         });
// //       },
// //     );
// //   }

// //   Widget _buildRoleDropdown() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         const Text(
// //           "Role: ",
// //           style: TextStyle(
// //             fontSize: 20,
// //             fontWeight: FontWeight.bold,
// //             color: Colors.white,
// //           ),
// //         ),
// //         DropdownButton<String>(
// //           dropdownColor: Colors.blue[900],
// //           value: selectedRole,
// //           items: roles.map((String role) {
// //             return DropdownMenuItem(
// //               value: role,
// //               child: Text(
// //                 role,
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontWeight: FontWeight.bold,
// //                   fontSize: 20,
// //                 ),
// //               ),
// //             );
// //           }).toList(),
// //           onChanged: (newValue) {
// //             setState(() {
// //               selectedRole = newValue!;
// //             });
// //           },
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildGenderDropdown() {
// //     List<String> genders = ['Male', 'Female', 'Other'];
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         const Text(
// //           "Gender: ",
// //           style: TextStyle(
// //             fontSize: 20,
// //             fontWeight: FontWeight.bold,
// //             color: Colors.white,
// //           ),
// //         ),
// //         DropdownButton<String>(
// //           dropdownColor: Colors.blue[900],
// //           value: selectedGender,
// //           items: genders.map((String gender) {
// //             return DropdownMenuItem(
// //               value: gender,
// //               child: Text(
// //                 gender,
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontWeight: FontWeight.bold,
// //                   fontSize: 20,
// //                 ),
// //               ),
// //             );
// //           }).toList(),
// //           onChanged: (newValue) {
// //             setState(() {
// //               selectedGender = newValue!;
// //             });
// //           },
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildActionButtons() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //       children: [
// //         ElevatedButton(
// //           onPressed: () {
// //             Navigator.pushReplacement(
// //               context,
// //               MaterialPageRoute(builder: (context) => const LoginPage()),
// //             );
// //           },
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: Colors.white,
// //             foregroundColor: Colors.blueAccent,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(20),
// //             ),
// //           ),
// //           child: const Text("Login", style: TextStyle(fontSize: 20)),
// //         ),
// //         ElevatedButton(
// //           onPressed: _register,
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: Colors.white,
// //             foregroundColor: Colors.blueAccent,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(20),
// //             ),
// //           ),
// //           child: const Text("Register", style: TextStyle(fontSize: 20)),
// //         ),
// //       ],
// //     );
// //   }

// //   String? _validateName(String? value) {
// //     if (value!.isEmpty) {
// //       return "First Name cannot be empty";
// //     }
// //     return null;
// //   }

// //   String? _validateLastName(String? value) {
// //     return null; // Last Name is optional
// //   }

// //   String? _validateUsername(String? value) {
// //     if (value!.isEmpty) {
// //       return "Username cannot be empty";
// //     }
// //     return null;
// //   }

// //   String? _validateEmail(String? value) {
// //     if (value!.isEmpty) {
// //       return "Email cannot be empty";
// //     }
// //     return null;
// //   }

// //   String? _validatePassword(String? value) {
// //     if (value!.isEmpty) {
// //       return "Password cannot be empty";
// //     }
// //     return null;
// //   }

// //   String? _validateConfirmPassword(String? value) {
// //     if (value != passwordController.text) {
// //       return "Passwords do not match";
// //     }
// //     return null;
// //   }

// //   String? _validatePhoneNumber(String? value) {
// //     if (value!.isEmpty) {
// //       return "Phone cannot be empty";
// //     }
// //     return null;
// //   }

// //   String? _validateAge(String? value) {
// //     if (value!.isEmpty) {
// //       return "Age cannot be empty";
// //     }
// //     return null;
// //   }

// //   Future<void> _register() async {
// //     if (_formKey.currentState!.validate()) {
// //       setState(() => _showProgress = true);
// //       try {
// //         UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
// //           email: emailController.text.trim(),
// //           password: passwordController.text.trim(),
// //         );

// //         await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
// //           'firstName': nameController.text.trim(),
// //           'lastName': lastNameController.text.trim(),
// //           'username': usernameController.text.trim(),
// //           'email': emailController.text.trim(),
// //           'role': selectedRole,
// //           'age': ageController.text.trim(),
// //           'phone': phoneController.text.trim(),
// //           'gender': selectedGender,
// //         });

// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (context) => const LoginPage()),
// //         );
// //       } catch (error) {
// //         print("Registration error: $error");
// //       } finally {
// //         setState(() => _showProgress = false);
// //       }
// //     }
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'login.dart';

// class Register extends StatefulWidget {
//   const Register({super.key});

//   @override
//   _RegisterState createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   final _formKey = GlobalKey<FormState>();
//   final _auth = FirebaseAuth.instance;

//   bool _showProgress = false;
//   bool _isPasswordObscure = true;
//   bool _isConfirmPasswordObscure = true;

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();

//   List<String> roles = ['Employee', 'HR', 'Manager'];
//   String selectedRole = 'Employee';
//   String selectedGender = 'Male';

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     nameController.dispose();
//     lastNameController.dispose();
//     usernameController.dispose();
//     ageController.dispose();
//     phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueAccent[700],
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 color: Colors.blueAccent[700],
//                 width: MediaQuery.of(context).size.width,
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const SizedBox(height: 80),
//                         const Text(
//                           "Register Now",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             fontSize: 40,
//                           ),
//                         ),
//                         const SizedBox(height: 50),
//                         _buildTextField(
//                           controller: nameController,
//                           hintText: 'First Name',
//                           validator: _validateName,
//                         ),
//                         const SizedBox(height: 20),
//                         _buildTextField(
//                           controller: lastNameController,
//                           hintText: 'Last Name (optional)',
//                           validator: _validateLastName,  // Updated validator
//                         ),
//                         const SizedBox(height: 20),
//                         _buildTextField(
//                           controller: usernameController,
//                           hintText: 'Username',
//                           validator: _validateUsername,
//                         ),
//                         const SizedBox(height: 20),
//                         _buildTextField(
//                           controller: emailController,
//                           hintText: 'Email',
//                           keyboardType: TextInputType.emailAddress,
//                           validator: _validateEmail,
//                         ),
//                         const SizedBox(height: 20),
//                         _buildTextField(
//                           controller: passwordController,
//                           hintText: 'Password',
//                           obscureText: _isPasswordObscure,
//                           suffixIcon: _togglePasswordVisibility(isConfirmPassword: false),
//                           validator: _validatePassword,
//                         ),
//                         const SizedBox(height: 20),
//                         _buildTextField(
//                           controller: confirmPasswordController,
//                           hintText: 'Confirm Password',
//                           obscureText: _isConfirmPasswordObscure,
//                           suffixIcon: _togglePasswordVisibility(isConfirmPassword: true),
//                           validator: _validateConfirmPassword,
//                         ),
//                         const SizedBox(height: 20),
//                         _buildTextField(
//                           controller: phoneController,
//                           hintText: 'Phone',
//                           validator: _validatePhoneNumber,
//                         ),
//                         const SizedBox(height: 20),
//                         _buildTextField(
//                           controller: ageController,
//                           hintText: 'Age',
//                           keyboardType: TextInputType.number,
//                           validator: _validateAge,
//                         ),
//                         const SizedBox(height: 20),
//                         _buildRoleDropdown(),
//                         const SizedBox(height: 20),
//                         _buildGenderDropdown(),
//                         const SizedBox(height: 20),
//                         _buildActionButtons(),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     TextInputType keyboardType = TextInputType.text,
//     bool obscureText = false,
//     Widget? suffixIcon,
//     required String? Function(String?) validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.white,
//         hintText: hintText,
//         suffixIcon: suffixIcon,
//         contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: Colors.white),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         enabledBorder: UnderlineInputBorder(
//           borderSide: const BorderSide(color: Colors.white),
//           borderRadius: BorderRadius.circular(20),
//         ),
//       ),
//       validator: validator,
//     );
//   }

//   Widget _togglePasswordVisibility({required bool isConfirmPassword}) {
//     return IconButton(
//       icon: Icon(isConfirmPassword
//           ? _isConfirmPasswordObscure
//               ? Icons.visibility_off
//               : Icons.visibility
//           : _isPasswordObscure
//               ? Icons.visibility_off
//               : Icons.visibility),
//       onPressed: () {
//         setState(() {
//           if (isConfirmPassword) {
//             _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
//           } else {
//             _isPasswordObscure = !_isPasswordObscure;
//           }
//         });
//       },
//     );
//   }

//   Widget _buildRoleDropdown() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text(
//           "Role: ",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         DropdownButton<String>(
//           dropdownColor: Colors.blue[900],
//           value: selectedRole,
//           items: roles.map((String role) {
//             return DropdownMenuItem(
//               value: role,
//               child: Text(
//                 role,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//             );
//           }).toList(),
//           onChanged: (newValue) {
//             setState(() {
//               selectedRole = newValue!;
//             });
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildGenderDropdown() {
//     List<String> genders = ['Male', 'Female', 'Other'];
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text(
//           "Gender: ",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         DropdownButton<String>(
//           dropdownColor: Colors.blue[900],
//           value: selectedGender,
//           items: genders.map((String gender) {
//             return DropdownMenuItem(
//               value: gender,
//               child: Text(
//                 gender,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//             );
//           }).toList(),
//           onChanged: (newValue) {
//             setState(() {
//               selectedGender = newValue!;
//             });
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton(
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const LoginPage()),
//             );
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.white,
//             foregroundColor: Colors.blueAccent,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//           child: const Text("Login", style: TextStyle(fontSize: 20)),
//         ),
//         ElevatedButton(
//           onPressed: _register,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.white,
//             foregroundColor: Colors.blueAccent,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//           child: const Text("Register", style: TextStyle(fontSize: 20)),
//         ),
//       ],
//     );
//   }

//   String? _validateName(String? value) {
//     if (value!.isEmpty) {
//       return "First Name cannot be empty";
//     }
//     return null;
//   }

//   String? _validateLastName(String? value) {
//     return null; // Last Name is optional
//   }

//   String? _validateUsername(String? value) {
//     if (value!.isEmpty) {
//       return "Username cannot be empty";
//     }
//     return null;
//   }

//   String? _validateEmail(String? value) {
//     if (value!.isEmpty) {
//       return "Email cannot be empty";
//     }
//     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//       return "Enter a valid email address";
//     }
//     return null;
//   }

//   String? _validatePassword(String? value) {
//     if (value!.isEmpty) {
//       return "Password cannot be empty";
//     }
//     if (value.length < 6) {
//       return "Password should be at least 6 characters long";
//     }
//     return null;
//   }

//   String? _validateConfirmPassword(String? value) {
//     if (value!.isEmpty) {
//       return "Confirm Password cannot be empty";
//     }
//     if (value != passwordController.text) {
//       return "Passwords do not match";
//     }
//     return null;
//   }

//   String? _validatePhoneNumber(String? value) {
//     if (value!.isEmpty) {
//       return "Phone number cannot be empty";
//     }
//     return null;
//   }

//   String? _validateAge(String? value) {
//     if (value!.isEmpty) {
//       return "Age cannot be empty";
//     }
//     if (int.tryParse(value) == null) {
//       return "Age should be a valid number";
//     }
//     return null;
//   }

//   Future<void> _register() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _showProgress = true);
//       try {
//         // Create user with email and password
//         UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//           email: emailController.text.trim(),
//           password: passwordController.text.trim(),
//         );

//         // Fetch the user ID after successful registration
//         String userId = userCredential.user!.uid;

//         // Save user details in Firestore
//         await FirebaseFirestore.instance.collection('users').doc(userId).set({
//           'userId': userId,  // Add userId field
//           'firstName': nameController.text.trim(),
//           'lastName': lastNameController.text.trim(),
//           'username': usernameController.text.trim(),
//           'email': emailController.text.trim(),
//           'role': selectedRole,
//           'age': ageController.text.trim(),
//           'phone': phoneController.text.trim(),
//           'gender': selectedGender,
//         });

//         // Navigate to the login page after successful registration
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginPage()),
//         );
//       } catch (error) {
//         print("Registration error: $error");
//         // Handle any errors here (e.g., show a message to the user)
//       } finally {
//         setState(() => _showProgress = false);
//       }
//     }
//   }
// }



//---------------------------------------------------



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match";
        _isLoading = false;
      });
      return;
    }

    try {
      // Register user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get user ID
      String uid = userCredential.user!.uid;

      // Store user details in Firestore under "users" collection
      await _firestore.collection("users").doc(uid).set({
        "uid": uid,
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "createdAt": Timestamp.now(),
      });

      // Navigate to MainPage after successful registration
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 12),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: const Text("Register"),
                  ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
