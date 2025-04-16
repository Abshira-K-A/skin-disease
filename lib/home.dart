import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:skinCure/schedule_routines.test.dart';
// import 'package:skinCure/skin_tracking.dart';
import 'package:skinCure/userProfile.dart';
import 'skin_tracking_page.dart';
import 'login.dart';
import 'skinType_test.dart';
import 'schedule_routines.test.dart';
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

  // New color palette
  final Color _primaryColor = const Color(0xFF8B4513); // Warm saddle brown
  final Color _secondaryColor = const Color(0xFFD2B48C); // Tan
  final Color _accentColor = const Color(0xFFCD853F); // Peru (warm orange-brown)
  final Color _backgroundColor = const Color(0xFFFAF9F6); // Off-white
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF5D4037); // Dark brown

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
      backgroundColor: _backgroundColor,
      appBar: AppBar(
       // title: Text("SkinCure Home", style: TextStyle(color: Colors.white)),
        backgroundColor: _primaryColor,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
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
                  ? Icon(Icons.person, color: _primaryColor)
                  : null,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
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
                  padding: const EdgeInsets.all(16.0),
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildSkincareCard(
          season: "Winter",             
          title: "❄️ Winter Care",
          description: "Combat dryness and maintain your glow during harsh winter months",
          imagePath: "assets/winter_care.jpg",
          tips: [
            "Use cream-based cleansers instead of gels",
            "Apply hyaluronic acid before moisturizer",
            "Don't forget your SPF - winter sun still damages",
            "Try overnight hydrating masks twice weekly"
          ],
              color: Color(0xFF6D4C41), // Deep warm brown
        ),
                      // _buildSkincareCard(
                      //   title: "🌨️ Winter Care",
                      //   description: "Keep your skin hydrated with moisturizers and drink plenty of water.",
                      //   imagePath: "assets/winter_care.jpg",
                      // ),
                      _buildSkincareCard(
           season: "Summer",              
          title: "☀️ Summer Defense",
          description: "Protect and refresh your skin in the heat",
          imagePath: "assets/summer_care.jpg",
          tips: [
            "Reapply SPF 50+ every 2 hours",
            "Use vitamin C serum in the morning",
            "Switch to gel-based moisturizers",
            "Carry facial mist for quick hydration"
          ],
          color: Color(0xFF8D6E63), // Warm medium brown
        ),
                      // _buildSkincareCard(
                      //   title: "☀️ Summer Care",
                      //   description: "Apply SPF sunscreen and use lightweight skincare products.",
                      //   imagePath: "assets/summer_care.jpg",
                      // ),
                        _buildSkincareCard(
          season: "Autumn",                
          title: "🍂 Fall Routine",
          description: "Repair summer damage and prep for winter",
          imagePath: "assets/fall_care.jpg",
          tips: [
            "Introduce retinol gradually",
            "Exfoliate 1-2 times weekly",
            "Boost ceramide intake",
            "Transition to richer night creams"
          ],
          color: Color(0xFFA1887F), // Warm light brown
        ),
                      // _buildSkincareCard(
                      //   title: "🍂 Fall Routine",
                      //   description: "Use rich moisturizers and mild exfoliation to prevent dryness.",
                      //   imagePath: "assets/fall_care.jpg",
                      // ),
 _buildSkincareCard(
          season: "Spring",
          title: "🌸 Spring Refresh",
          description: "Lighten up your routine for the new season",
          imagePath: "assets/spring_care.jpg",
          tips: [
            "Do a gentle detox regimen",
            "Switch to lighter serums",
            "Try brightening treatments",
            "Start prepping for stronger sun"
          ],
          color: Color(0xFFBCAAA4), // Warm pale brown
        ),
                      // _buildSkincareCard(
                      //   title: "🌸 Spring Glow",
                      //   description: "Switch to gentle cleansers and hydrating toners for fresh skin.",
                      //   imagePath: "assets/spring_care.jpg",
                      // ),
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
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildFeatureCard(
                        title: "🌿 Start Skin Test",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SkinTypeTestPage())),
                      ),
                      Divider(color: _backgroundColor, height: 1),
                      _buildFeatureCard(
                        title: "📸 Track Your Skin",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SkinAnalysisPage())),
                      ),
                      Divider(color: _backgroundColor, height: 1),
                      _buildFeatureCard(
                        title: "📅 Schedule Routines",
                        onTap: () {
                        
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ScheduleRoutinePage(userId: '',)));
                    
                          }
                        },
                      ),
                      Divider(color: _backgroundColor, height: 1),
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
              child: Container(
                decoration: BoxDecoration(
                  color: _accentColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatbotPage()));
                  },
                  // icon: const Icon(Icons.chat, size: 30, color: Colors.white),
                    icon: const Icon(Icons.face_retouching_natural, size: 30, color: Colors.white),
                  padding: const EdgeInsets.all(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkincareCard({
    required String title,
    required String season,
     required List<String> tips,
     required Color color,
    required String description,
    required String imagePath
    }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  color.withOpacity(0.8),
                color.withOpacity(0.4),
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
              //borderRadius: BorderRadius.circular(15),
            ),
             child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Season tag
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
                    child: Text(
                  season.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

               SizedBox(height: 8),
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // Description
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
               SizedBox(height: 12),
              // Tips List
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.white),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tip,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildFeatureCard({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: _accentColor),
          ],
        ),
      ),
    );
  }
}