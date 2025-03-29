

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
  double _xPosition = 280;
  double _yPosition = 500;
  bool _isDrawerExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  String? _userName;
  String? _userEmail;
  String? _profileImageUrl;

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
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email;
        _userName = user.displayName ?? 'User';
        _profileImageUrl = user.photoURL;
      });
    }
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(
                    userName: _userName ?? 'User',
                    userEmail: _userEmail ?? '',
                    profileImageUrl: _profileImageUrl,
                  ),
                ),
              );
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: _profileImageUrl != null 
                  ? NetworkImage(_profileImageUrl!) 
                  : const AssetImage('assets/default_profile.png') as ImageProvider,
              child: _profileImageUrl == null
                  ? const Icon(Icons.person, color: Colors.deepOrangeAccent)
                  : null,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Top 75% - Skincare Tips
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

              // Bottom 25% - Expandable Feature Drawer
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

          // Draggable Floating Chatbot Button
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

  Widget _buildFeatureCard({required String title, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.deepOrangeAccent),
    );
  }
}