



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  /// ✅ **Fetch User Profile from Firestore**
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

  /// 🔹 **Fetch Skincare Routine Schedules from Firebase**
  Stream<QuerySnapshot> _fetchUserRoutines() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('skincare_routines')
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  /// 🔹 **Fetch Reminder Schedules from Firebase**
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

                        /// 🔹 **Skincare Routines Section**
                        const Text(
                          "Your Skincare Routines",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        _buildSkincareRoutines(),

                        const SizedBox(height: 30),

                        /// 🔹 **Reminder Schedules**
                        const Text(
                          "Reminder Schedules",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        _buildReminderSchedules(),

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

  /// 🔹 **Display Skincare Routines by Category**
Widget _buildSkincareRoutines() {
  return StreamBuilder<QuerySnapshot>(
    stream: _fetchUserRoutines(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(
            child: Text("No skincare routines scheduled.", style: TextStyle(fontSize: 16)));
      }

      // 🔹 **Categorizing routines by Date**
      Map<String, List<Map<String, dynamic>>> routinesByDate = {};

      for (var doc in snapshot.data!.docs) {
        var routine = doc.data() as Map<String, dynamic>;
        String date = routine['date'] ?? 'Unknown Date'; // Store date of routine

        if (!routinesByDate.containsKey(date)) {
          routinesByDate[date] = [];
        }
        routinesByDate[date]!.add(routine);
      }

      return Column(
        children: routinesByDate.entries.map((entry) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ExpansionTile(
              title: Text(
                "Skincare Routines - ${entry.key}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),
              ),
              children: entry.value.map((routine) {
                return ListTile(
                  title: Text(routine['question'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Answer: ${routine['answer']}"),
                  trailing: const Icon(Icons.check_circle, color: Colors.deepOrangeAccent),
                );
              }).toList(),
            ),
          );
        }).toList(),
      );
    },
  );
}

  // Widget _buildSkincareRoutines() {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: _fetchUserRoutines(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //         return const Center(
  //             child: Text("No skincare routines scheduled.", style: TextStyle(fontSize: 16)));
  //       }

  //       // 🔹 **Categorizing routines by type**
  //       Map<String, List<Map<String, dynamic>>> categorizedRoutines = {};

  //       for (var doc in snapshot.data!.docs) {
  //         var routine = doc.data() as Map<String, dynamic>;
  //         String category = routine['category'] ?? 'Other'; // Default category if none exists

  //         if (!categorizedRoutines.containsKey(category)) {
  //           categorizedRoutines[category] = [];
  //         }
  //         categorizedRoutines[category]!.add(routine);
  //       }

  //       return Column(
  //         children: categorizedRoutines.entries.map((entry) {
  //           return Card(
  //             elevation: 5,
  //             margin: const EdgeInsets.symmetric(vertical: 10),
  //             child: Padding(
  //               padding: const EdgeInsets.all(15.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   /// 🔹 **Category Title**
  //                   Text(
  //                     entry.key,
  //                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),
  //                   ),
  //                   const Divider(),

  //                   /// 🔹 **Displaying Routines under Each Category**
  //                   Column(
  //                     children: entry.value.map((routine) {
  //                       return ListTile(
  //                         title: Text(routine['question'], style: const TextStyle(fontWeight: FontWeight.bold)),
  //                         subtitle: Text("Answer: ${routine['answer']}"),
  //                         trailing: const Icon(Icons.check_circle, color: Colors.deepOrangeAccent),
  //                       );
  //                     }).toList(),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //       );
  //     },
  //   );
  // }

  /// 🔹 **Display Reminder Schedules**
Widget _buildReminderSchedules() {
  return StreamBuilder<QuerySnapshot>(
    stream: _fetchReminderSchedules(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(
            child: Text("No reminders set.", style: TextStyle(fontSize: 16)));
      }

      // 🔹 **Categorizing reminders by Date**
      Map<String, List<Map<String, dynamic>>> remindersByDate = {};

      for (var doc in snapshot.data!.docs) {
        var reminder = doc.data() as Map<String, dynamic>;
        String date = reminder['date'] ?? 'Unknown Date'; // Store date of reminder

        if (!remindersByDate.containsKey(date)) {
          remindersByDate[date] = [];
        }
        remindersByDate[date]!.add(reminder);
      }

      return Column(
        children: remindersByDate.entries.map((entry) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ExpansionTile(
              title: Text(
                "Reminders - ${entry.key}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),
              ),
              children: entry.value.map((reminder) {
                return ListTile(
                  title: Text(
                    "Skincare Routine Reminder",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Time: ${reminder['answer']}"),
                  trailing: const Icon(Icons.alarm, color: Colors.deepOrangeAccent),
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
//   Widget _buildReminderSchedules() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _fetchReminderSchedules(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(
//               child: Text("No reminders set.", style: TextStyle(fontSize: 16)));
//         }

//         return ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: snapshot.data!.docs.length,
//           itemBuilder: (context, index) {
//             var reminder = snapshot.data!.docs[index];

//             return Card(
//               elevation: 5,
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               child: ListTile(
//                 title: Text(
//                   "Skincare Routine Reminder",
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Text("Reminder Time: ${reminder['answer']}"),
//                 trailing: const Icon(Icons.alarm, color: Colors.deepOrangeAccent),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
