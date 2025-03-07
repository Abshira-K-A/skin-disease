//  import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'employee.dart';
// import 'hr.dart';
// import 'manager.dart';
// import 'register.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _auth = FirebaseAuth.instance;
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool _isPasswordVisible = true;
//   bool isLoading = false;
//   String? emailError;
//   String? passwordError;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             _buildLoginForm(context),
//             _buildFooter(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoginForm(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//       color: Colors.blue[900],
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height * 0.7,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Login",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               fontSize: 36,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 _buildEmailField(),
//                 if (emailError != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       emailError!,
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   ),
//                 const SizedBox(height: 20),
//                 _buildPasswordField(),
//                 if (passwordError != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       passwordError!,
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   ),
//                 const SizedBox(height: 20),
//                 _buildLoginButton(),
//                 if (isLoading)
//                   const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 8.0),
//                     child: CircularProgressIndicator(color: Colors.white),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmailField() {
//     return TextFormField(
//       controller: emailController,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.white,
//         hintText: 'Email',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: Colors.blue.shade900),
//         ),
//       ),
//       validator: (value) {
//         if (value!.isEmpty) {
//           return "Email cannot be empty";
//         }
//         if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]+$").hasMatch(value)) {
//           return "Invalid email";
//         }
//         return null;
//       },
//       keyboardType: TextInputType.emailAddress,
//     );
//   }

//   Widget _buildPasswordField() {
//     return TextFormField(
//       controller: passwordController,
//       obscureText: _isPasswordVisible,
//       decoration: InputDecoration(
//         suffixIcon: IconButton(
//           icon: Icon(
//             _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//             color: Colors.blue[900],
//           ),
//           onPressed: () {
//             setState(() {
//               _isPasswordVisible = !_isPasswordVisible;
//             });
//           },
//         ),
//         filled: true,
//         fillColor: Colors.white,
//         hintText: 'Password',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: Colors.blue.shade900),
//         ),
//       ),
//       validator: (value) {
//         if (value!.isEmpty) {
//           return "Password cannot be empty";
//         }
//         if (value.length < 6) {
//           return "Invalid password";
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildLoginButton() {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.blue[900],
//         minimumSize: const Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         elevation: 5,
//       ),
//       onPressed: () {
//         setState(() {
//           isLoading = true;
//           emailError = null;
//           passwordError = null;
//         });
//         signIn(emailController.text, passwordController.text);
//       },
//       child: const Text(
//         "Login",
//         style: TextStyle(fontSize: 20, color: Colors.white),
//       ),
//     );
//   }

//   Widget _buildFooter(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       width: MediaQuery.of(context).size.width,
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         children: [
//           TextButton(
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const Register()),
//               );
//             },
//             child: const Text(
//               "Register Now",
//               style: TextStyle(color: Colors.blue, fontSize: 18),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> signIn(String email, String password) async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         await _auth.signInWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//         routeUser();
//       } on FirebaseAuthException catch (e) {
//         setState(() {
//           isLoading = false;
//           if (e.code == 'user-not-found') {
//             emailError = 'No user found for that email.';
//           } else if (e.code == 'wrong-password') {
//             passwordError = 'Invalid password';
//           } else {
//             passwordError = 'An error occurred. Please try again.';
//           }
//         });
//       }
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void routeUser() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       var documentSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();

//       if (documentSnapshot.exists) {
//         String role = documentSnapshot.get('role');
//         Widget destination;
//         if (role == "Employee") {
//           destination = const Employee();
//         } else if (role == "HR") {
//           destination = const HR();
//         } else if (role == "Manager") {
//           destination = const Manager();
//         } else {
//           return;
//         }
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => destination));
//       }
//     }
//   }
// }









//-----------------------------------

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'main_page.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = false;
//   String? _errorMessage;

//   Future<void> _login() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       await _auth.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       // Navigate to MainPage after successful login
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const MainPage()),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         _errorMessage = e.message;
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: const InputDecoration(
//                 labelText: "Email",
//                 prefixIcon: Icon(Icons.email),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(
//                 labelText: "Password",
//                 prefixIcon: Icon(Icons.lock),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             if (_errorMessage != null)
//               Text(
//                 _errorMessage!,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             const SizedBox(height: 12),
//             _isLoading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: _login,
//                     child: const Text("Login"),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main_page.dart';
import 'register.dart'; // Import RegisterPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to MainPage after successful login
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
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 12),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text("Login"),
                  ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("New user? "),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text("Create an account"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


