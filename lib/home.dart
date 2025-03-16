import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skinCure/skin_tracking.dart';
import 'package:skinCure/userProfile.dart';
import 'login.dart';
import 'skinType_test.dart';
import 'schedule_routine.dart'; // Import the new chatbot page

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false, // Removes all previous routes to prevent going back
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents going back using the back button
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) _logout(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("SkinCure Home"),
          backgroundColor: Colors.deepOrangeAccent,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfilePage()),
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFE0B2), Color(0xFFFFCCBC)], // Soft skin-tone colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCard(
                    title: "🌿 Start Skin Test",
                    description: "Discover your skin type and get personalized skin-care routines.",
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
                    // onPressed: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => const ScheduleRoutinePage()),
                    //   );
                    // },
                    onPressed: () {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleRoutinePage(userId: user.uid), // ✅ Pass userId
      ),
    );
  }
},

                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
