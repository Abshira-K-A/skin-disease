// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:skinCure/skin_tracking.dart';
// import 'package:skinCure/userProfile.dart';
// import 'login.dart';
// import 'skinType_test.dart';
// import 'schedule_routine.dart';
// import 'chatbot_page.dart';
// import 'skin_clinic_page.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   void _logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     if (!context.mounted) return;
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginPage()),
//       (route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("SkinCure Home"),
//         backgroundColor: Colors.deepOrangeAccent,
//         centerTitle: true,
//       ),
//       drawer: _buildDrawer(context),
//       body: SingleChildScrollView(
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFFFFE0B2), Color(0xFFFFCCBC)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildCard(
//                   title: "🌿 Start Skin Test",
//                   description: "Discover your skin type and get personalized skincare routines.",
//                   buttonText: "Start Skin Test",
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const SkinTypeTestPage()),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 _buildCard(
//                   title: "📸 Track Your Skin",
//                   description: "Monitor your skin changes over time by uploading images.",
//                   buttonText: "Start Tracking",
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const SkinTrackingPage()),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 _buildCard(
//                   title: "📅 Schedule Routines",
//                   description: "Plan your skincare routine with our AI chatbot.",
//                   buttonText: "Schedule Now",
//                   onPressed: () {
//                     final user = FirebaseAuth.instance.currentUser;
//                     if (user != null) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ScheduleRoutinePage(userId: user.uid),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 _buildCard(
//                   title: "🏥 Find Skin Clinics",
//                   description: "Locate nearby skin clinics for expert skincare advice.",
//                   buttonText: "Find Clinics",
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const SkinClinicPage()),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),

//       // ✅ Floating Chatbot Button
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const ChatbotPage()),
//           );
//         },
//         backgroundColor: Colors.deepOrangeAccent,
//         child: const Icon(Icons.chat, size: 30, color: Colors.white),
//       ),
//     );
//   }

//   /// ✅ Left-side Drawer
//   Widget _buildDrawer(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
//           UserAccountsDrawerHeader(
//             accountName: Text(FirebaseAuth.instance.currentUser?.displayName ?? "User"),
//             accountEmail: Text(FirebaseAuth.instance.currentUser?.email ?? "No email"),
//             currentAccountPicture: const CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Icon(Icons.person, size: 40, color: Colors.deepOrangeAccent),
//             ),
//             decoration: const BoxDecoration(
//               color: Colors.deepOrangeAccent,
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.person, color: Colors.deepOrangeAccent),
//             title: const Text("Profile"),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const UserProfilePage()),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.settings, color: Colors.deepOrangeAccent),
//             title: const Text("Settings"),
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Settings feature coming soon!")),
//               );
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.redAccent),
//             title: const Text("Logout"),
//             onTap: () => _logout(context),
//           ),
//         ],
//       ),
//     );
//   }

//   /// ✅ Reusable Card Widget
//   Widget _buildCard({
//     required String title,
//     required String description,
//     required String buttonText,
//     required VoidCallback onPressed,
//   }) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       elevation: 10,
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.brown,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               description,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 16, color: Colors.black87),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: onPressed,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepOrangeAccent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//               ),
//               child: Text(
//                 buttonText,
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skinCure/skin_tracking.dart';
import 'package:skinCure/userProfile.dart';
import 'login.dart';
import 'skinType_test.dart';
import 'schedule_routine.dart';
import 'chatbot_page.dart';
import 'skin_clinic_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _xPosition = 280; // ✅ Initial chatbot position (Right Bottom)
  double _yPosition = 500;

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SkinCure Home"),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
      ),
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          // ✅ Scrollable Content
          SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFE0B2), Color(0xFFFFCCBC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCard(
                      title: "🌿 Start Skin Test",
                      description: "Discover your skin type and get personalized skincare routines.",
                      buttonText: "Start Skin Test",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SkinTypeTestPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      title: "📸 Track Your Skin",
                      description: "Monitor your skin changes over time by uploading images.",
                      buttonText: "Start Tracking",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SkinTrackingPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      title: "📅 Schedule Routines",
                      description: "Plan your skincare routine with our AI chatbot.",
                      buttonText: "Schedule Now",
                      onPressed: () {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScheduleRoutinePage(userId: user.uid),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      title: "🏥 Find Skin Clinics",
                      description: "Locate nearby skin clinics for expert skincare advice.",
                      buttonText: "Find Clinics",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SkinClinicPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ✅ Draggable Floating Chatbot Button
          Positioned(
            left: _xPosition,
            top: _yPosition,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _xPosition += details.delta.dx;
                  _yPosition += details.delta.dy;
                });
              },
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatbotPage()),
                  );
                },
                backgroundColor: Colors.deepOrangeAccent,
                child: const Icon(Icons.chat, size: 30, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Left-side Drawer
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(FirebaseAuth.instance.currentUser?.displayName ?? "User"),
            accountEmail: Text(FirebaseAuth.instance.currentUser?.email ?? "No email"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.deepOrangeAccent),
            ),
            decoration: const BoxDecoration(
              color: Colors.deepOrangeAccent,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.deepOrangeAccent),
            title: const Text("Profile"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.deepOrangeAccent),
            title: const Text("Settings"),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Settings feature coming soon!")),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Logout"),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  /// ✅ Reusable Card Widget
  Widget _buildCard({
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
