
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, required String userName, required String userEmail, String? profileImageUrl});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  // Color scheme matching home page
  final Color _accentColor = const Color(0xFFCD853F); // Peru (warm orange-brown)
  final Color _backgroundColor = const Color(0xFFFAF9F6); // Off-white
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF5D4037); // Dark brown
  final Color _secondaryTextColor = const Color(0xFF8D6E63); // Lighter brown

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>? ?? {};
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Stream<QuerySnapshot> _fetchUserRoutines() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('skincare_routines')
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> _fetchReminderSchedules() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('skincare_routines')
        .where("question", isEqualTo: "Pick a time for your skincare routine reminder.")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text("My Profile", style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
        backgroundColor: _backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: _accentColor),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: _accentColor))
          : userData == null
              ? Center(
                  child: Text("User data not available", 
                    style: TextStyle(fontSize: 16, color: _textColor)),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Header with Avatar
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _accentColor, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: _accentColor.withOpacity(0.2),
                            child: Icon(Icons.person, size: 50, color: _accentColor),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          userData!['name'] ?? "Unknown",
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            color: _textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          userData!['email'] ?? "No Email",
                          style: TextStyle(
                            fontSize: 16, 
                            color: _secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _accentColor.withOpacity(0.3)),
                          ),
                          child: Text(
                            "Skin Type: ${userData!['skinType']?.toString().toUpperCase() ?? 'NOT TESTED'}",
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w600,
                              color: _textColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Skincare Routines Section
                        _buildSectionHeader("Your Skincare Routines"),
                        const SizedBox(height: 16),
                        _buildSkincareRoutines(),

                        const SizedBox(height: 30),

                        // Reminder Schedules
                        _buildSectionHeader("Reminder Schedules"),
                        const SizedBox(height: 16),
                        _buildReminderSchedules(),

                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _accentColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: const Text("BACK TO HOME", 
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          height: 24,
          width: 4,
          decoration: BoxDecoration(
            color: _accentColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSkincareRoutines() {
    return StreamBuilder<QuerySnapshot>(
      stream: _fetchUserRoutines(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: _accentColor));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text("No skincare routines scheduled.", 
              style: TextStyle(fontSize: 16, color: _secondaryTextColor)),
          );
        }

        Map<String, List<Map<String, dynamic>>> routinesByDate = {};

        for (var doc in snapshot.data!.docs) {
          var routine = doc.data() as Map<String, dynamic>;
          String date = routine['date'] ?? 'Unknown Date';

          if (!routinesByDate.containsKey(date)) {
            routinesByDate[date] = [];
          }
          routinesByDate[date]!.add(routine);
        }

        return Column(
          children: routinesByDate.entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(
                  "Routines - ${entry.key}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: _accentColor,
                ),
                children: entry.value.map((routine) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                      title: Text(
                        routine['question'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _textColor,
                        ),
                      ),
                      subtitle: Text(
                        "Answer: ${routine['answer']}",
                        style: TextStyle(color: _secondaryTextColor),
                      ),
                      leading: Icon(
                        Icons.check_circle,
                        color: _accentColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildReminderSchedules() {
    return StreamBuilder<QuerySnapshot>(
      stream: _fetchReminderSchedules(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: _accentColor));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text("No reminders set.", 
              style: TextStyle(fontSize: 16, color: _secondaryTextColor)),
          );
        }

        Map<String, List<Map<String, dynamic>>> remindersByDate = {};

        for (var doc in snapshot.data!.docs) {
          var reminder = doc.data() as Map<String, dynamic>;
          String date = reminder['date'] ?? 'Unknown Date';

          if (!remindersByDate.containsKey(date)) {
            remindersByDate[date] = [];
          }
          remindersByDate[date]!.add(reminder);
        }

        return Column(
          children: remindersByDate.entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(
                  "Reminders - ${entry.key}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: _accentColor,
                ),
                children: entry.value.map((reminder) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                      title: Text(
                        "Skincare Routine Reminder",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _textColor,
                        ),
                      ),
                      subtitle: Text(
                        "Time: ${reminder['answer']}",
                        style: TextStyle(color: _secondaryTextColor),
                      ),
                      leading: Icon(
                        Icons.alarm,
                        color: _accentColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
