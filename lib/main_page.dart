// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'home.dart';
// import 'login.dart';

// class MainPage extends StatelessWidget {
//   const MainPage({super.key});

//   Future<String?> getUserRole(String uid) async {
//     try {
//       // Assuming the user data is stored in a Firestore collection called 'users'
//       DocumentSnapshot userDoc =
//           await FirebaseFirestore.instance.collection('users').doc(uid).get();

//       // Assuming userRole is a field in the user's document
//       return userDoc['role'];
//     } catch (e) {
//       print("Error fetching user role: $e");
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final user = snapshot.data;
//             return FutureBuilder<String?>(
//               future: getUserRole(user!.uid),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError ||
//                     !snapshot.hasData ||
//                     snapshot.data == null) {
//                   return const Center(child: Text("Error loading user role"));
//                 }

//                 String userRole = snapshot.data!;
//                 return HomePage(
//                     userRole: userRole); // Pass the role to HomePage
//               },
//             );
//           } else {
//             return const LoginPage();
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            // User is logged in, navigate to HomePage
            return const HomePage();
          } else {
            // User is not logged in, navigate to LoginPage
            return const LoginPage();
          }
        },
      ),
    );
  }
}
