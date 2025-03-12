// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class UserProfilePage extends StatefulWidget {
//   const UserProfilePage({super.key});

//   @override
//   _UserProfilePageState createState() => _UserProfilePageState();
// }

// class _UserProfilePageState extends State<UserProfilePage> {
//   final User? user = FirebaseAuth.instance.currentUser;
//   Map<String, dynamic>? userData;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }

//   Future<void> _fetchUserData() async {
//     if (user != null) {
//       try {
//         DocumentSnapshot userDoc =
//             await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

//         if (userDoc.exists) {
//           setState(() {
//             userData = userDoc.data() as Map<String, dynamic>?;
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//         }
//       } catch (e) {
//         print("Error fetching user data: $e");
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("User Profile"),
//         backgroundColor: Colors.deepOrangeAccent,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : userData == null
//               ? const Center(
//                   child: Text("User data not available", style: TextStyle(fontSize: 16)),
//                 )
//               : Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.deepOrangeAccent,
//                         child: Icon(Icons.person, size: 60, color: Colors.white),
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         userData!['name'] ?? "Unknown",
//                         style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         userData!['email'] ?? "No Email",
//                         style: const TextStyle(fontSize: 16, color: Colors.black54),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         "Skin Type: ${userData!['skinType'] ?? 'Not Tested'}",
//                         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                       ),
//                       const SizedBox(height: 30),
//                       ElevatedButton.icon(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: const Icon(Icons.arrow_back),
//                         label: const Text("Back to Home"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepOrangeAccent,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//     );
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>?;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(
                  child: Text("User data not available", style: TextStyle(fontSize: 16)),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.deepOrangeAccent,
                          child: Icon(Icons.person, size: 60, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          userData!['name'] ?? "Unknown",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userData!['email'] ?? "No Email",
                          style: const TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Skin Type: ${userData!['skinType'] ?? 'Not Tested'}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 30),

                        // Skin History Section
                        const Text(
                          "Your Skin Progress",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 300, // Limit the height of the list
                          child: SkinHistory(user!.uid),
                        ),

                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text("Back to Home"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

// Skin Tracking History Widget
class SkinHistory extends StatelessWidget {
  final String userId;
  const SkinHistory(this.userId, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('skinTracking')
          .doc(userId)
          .collection('uploads')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No skin tracking data available."));
        }

        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs.map((doc) {
            return ListTile(
              leading: Image.network(doc['imageUrl'], width: 50, height: 50),
              title: Text("Uploaded on ${doc['timestamp'].toDate()}"),
            );
          }).toList(),
        );
      },
    );
  }
}
