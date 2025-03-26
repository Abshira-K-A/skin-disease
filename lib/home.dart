


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:skinCure/skin_tracking.dart';
// import 'package:skinCure/userProfile.dart';
// import 'login.dart';
// import 'skinType_test.dart';
// import 'schedule_routine.dart';
// import 'chatbot_page.dart';
// import 'skin_clinic_page.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   double _xPosition = 280; // ✅ Initial chatbot position (Right Bottom)
//   double _yPosition = 500;

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
//       body: Stack(
//         children: [
//           // ✅ Scrollable Content
//           SingleChildScrollView(
//             child: Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFFFFE0B2), Color(0xFFFFCCBC)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     _buildCard(
//                       title: "🌿 Start Skin Test",
//                       description: "Discover your skin type and get personalized skincare routines.",
//                       buttonText: "Start Skin Test",
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => const SkinTypeTestPage()),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     _buildCard(
//                       title: "📸 Track Your Skin",
//                       description: "Monitor your skin changes over time by uploading images.",
//                       buttonText: "Start Tracking",
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => const SkinTrackingPage()),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     _buildCard(
//                       title: "📅 Schedule Routines",
//                       description: "Plan your skincare routine with our AI chatbot.",
//                       buttonText: "Schedule Now",
//                       onPressed: () {
//                         final user = FirebaseAuth.instance.currentUser;
//                         if (user != null) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ScheduleRoutinePage(userId: user.uid),
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     _buildCard(
//                       title: "🏥 Find Skin Clinics",
//                       description: "Locate nearby skin clinics for expert skincare advice.",
//                       buttonText: "Find Clinics",
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => const SkinClinicPage()),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // ✅ Draggable Floating Chatbot Button
//           Positioned(
//             left: _xPosition,
//             top: _yPosition,
//             child: GestureDetector(
//               onPanUpdate: (details) {
//                 setState(() {
//                   _xPosition += details.delta.dx;
//                   _yPosition += details.delta.dy;
//                 });
//               },
//               child: FloatingActionButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const ChatbotPage()),
//                   );
//                 },
//                 backgroundColor: Colors.deepOrangeAccent,
//                 child: const Icon(Icons.chat, size: 30, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
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
//                 MaterialPageRoute(builder: (context) =>  UserProfilePage()),
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

//==================================================================================================================

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:skinCure/skin_tracking.dart';
// import 'package:skinCure/userProfile.dart';
// import 'login.dart';
// import 'skinType_test.dart';
// import 'schedule_routine.dart';
// import 'chatbot_page.dart';
// import 'skin_clinic_page.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
//   late AnimationController _chatbotController;
//   double _xPosition = 280; // Chatbot position
//   double _yPosition = 500;

//   @override
//   void initState() {
//     super.initState();
//     _chatbotController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     )..repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _chatbotController.dispose();
//     super.dispose();
//   }

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
//       // 🔹 Modern AppBar with Gradient
//       appBar: AppBar(
//         title: const Text("SkinCure Home"),
//         backgroundColor: Colors.deepOrangeAccent,
//         centerTitle: true,
//         elevation: 8,
//         shadowColor: Colors.black38,
//       ),

//       // 🔹 Side Drawer
//       drawer: _buildDrawer(context),

//       // 🔹 Main Content with Scrollable UI
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFFFFE0B2), Color(0xFFFFCCBC)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     _buildCard(
//                       title: "🌿 Skin Test",
//                       description: "Discover your skin type & get personalized care.",
//                       buttonText: "Start Test",
//                       onPressed: () => _navigateTo(context, const SkinTypeTestPage()),
//                     ),
//                     _buildCard(
//                       title: "📸 Track Skin",
//                       description: "Monitor your skin changes over time.",
//                       buttonText: "Start Tracking",
//                       onPressed: () => _navigateTo(context, const SkinTrackingPage()),
//                     ),
//                     _buildCard(
//                       title: "📅 Routine Planner",
//                       description: "Plan & schedule skincare routines easily.",
//                       buttonText: "Schedule Now",
//                       onPressed: () => _navigateTo(context, ScheduleRoutinePage(userId: FirebaseAuth.instance.currentUser!.uid)),
//                     ),
//                     _buildCard(
//                       title: "🏥 Find Clinics",
//                       description: "Locate the best nearby skin clinics.",
//                       buttonText: "Find Clinics",
//                       onPressed: () => _navigateTo(context, const SkinClinicPage()),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // 🔹 Draggable Chatbot Button with Animation
//           Positioned(
//             left: _xPosition,
//             top: _yPosition,
//             child: GestureDetector(
//               onPanUpdate: (details) {
//                 setState(() {
//                   _xPosition += details.delta.dx;
//                   _yPosition += details.delta.dy;
//                 });
//               },
//               child: AnimatedBuilder(
//                 animation: _chatbotController,
//                 builder: (context, child) {
//                   return Transform.scale(
//                     scale: 1 + (_chatbotController.value * 0.1),
//                     child: child,
//                   );
//                 },
//                 child: FloatingActionButton(
//                   onPressed: () => _navigateTo(context, const ChatbotPage()),
//                   backgroundColor: Colors.deepOrangeAccent,
//                   child: const Icon(Icons.chat, size: 30, color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// ✅ **Navigation Helper**
//   void _navigateTo(BuildContext context, Widget page) {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => page));
//   }

//   /// ✅ **Modern Drawer UI**
//   Widget _buildDrawer(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
//           UserAccountsDrawerHeader(
//             accountName: Text(FirebaseAuth.instance.currentUser?.displayName ?? "User", style: const TextStyle(fontSize: 18)),
//             accountEmail: Text(FirebaseAuth.instance.currentUser?.email ?? "No email"),
//             currentAccountPicture: const CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Icon(Icons.person, size: 40, color: Colors.deepOrangeAccent),
//             ),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
//             ),
//           ),
//           _buildDrawerItem(Icons.person, "Profile", () => _navigateTo(context, const UserProfilePage())),
//           _buildDrawerItem(Icons.settings, "Settings", () => _showComingSoon(context)),
//           const Divider(),
//           _buildDrawerItem(Icons.logout, "Logout", () => _logout(context)),
//         ],
//       ),
//     );
//   }

//   /// ✅ **Drawer Items**
//   Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.deepOrangeAccent),
//       title: Text(title, style: const TextStyle(fontSize: 16)),
//       onTap: onTap,
//     );
//   }

//   /// ✅ **Reusable Card Widget (Improved UI)**
//   Widget _buildCard({
//     required String title,
//     required String description,
//     required String buttonText,
//     required VoidCallback onPressed,
//   }) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       elevation: 8,
//       shadowColor: Colors.black38,
//       child: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: Column(
//           children: [
//             Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown)),
//             const SizedBox(height: 10),
//             Text(description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.black87)),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: onPressed,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepOrangeAccent,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//               ),
//               child: Text(buttonText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ✅ **Show "Coming Soon" Message**
//   void _showComingSoon(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Settings feature coming soon!"), duration: Duration(seconds: 2)),
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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  double _xPosition = 280; // Initial chatbot position
  double _yPosition = 500;
  bool _isDrawerExpanded = false; // Controls drawer animation
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("SkinCure Home"),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // 📌 Top 75% - Skincare Tips
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildSkincareCard(
                        title: "🌨️ Winter Care",
                        description: "Keep your skin hydrated with moisturizers and drink plenty of water.",
                        imagePath: "assets/winter_care.jpg",
                      ),
                      _buildSkincareCard(
                        title: "☀️ Summer Care",
                        description: "Apply SPF sunscreen and use lightweight skincare products.",
                        imagePath: "assets/summer_care.jpg",
                      ),
                      _buildSkincareCard(
                        title: "🍂 Fall Routine",
                        description: "Use rich moisturizers and mild exfoliation to prevent dryness.",
                        imagePath: "assets/fall_care.jpg",
                      ),
                      _buildSkincareCard(
                        title: "🌸 Spring Glow",
                        description: "Switch to gentle cleansers and hydrating toners for fresh skin.",
                        imagePath: "assets/spring_care.jpg",
                      ),
                    ],
                  ),
                ),
              ),

              // 📌 Bottom 25% - Expandable Feature Drawer
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isDrawerExpanded = !_isDrawerExpanded;
                    if (_isDrawerExpanded) {
                      _animationController.forward();
                    } else {
                      _animationController.reverse();
                    }
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      _isDrawerExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),

              // Animated Feature Drawer
              SizeTransition(
                sizeFactor: _animation,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: Column(
                    children: [
                      _buildFeatureCard(
                        title: "🌿 Start Skin Test",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SkinTypeTestPage())),
                      ),
                      _buildFeatureCard(
                        title: "📸 Track Your Skin",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SkinTrackingPage())),
                      ),
                      _buildFeatureCard(
                        title: "📅 Schedule Routines",
                        onTap: () {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ScheduleRoutinePage(userId: user.uid)),
                            );
                          }
                        },
                      ),
                      _buildFeatureCard(
                        title: "🏥 Find Skin Clinics",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SkinClinicPage())),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 📌 Draggable Floating Chatbot Button
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatbotPage()));
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

  /// ✅ **Reusable Skincare Card**
  Widget _buildSkincareCard({required String title, required String description, required String imagePath}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(description, style: const TextStyle(fontSize: 16, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ **Reusable Feature Card**
  Widget _buildFeatureCard({required String title, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.deepOrangeAccent),
    );
  }
}
