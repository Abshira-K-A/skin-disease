import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HRManagerLeaveRequests extends StatelessWidget {
  const HRManagerLeaveRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manager Leave Requests"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('managerLeaveApplications').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No manager leave requests available."));
          }

          final leaveRequests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: leaveRequests.length,
            itemBuilder: (context, index) {
              var request = leaveRequests[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text("Leave Type: ${request['leaveType'] ?? 'Unknown'}"),
                  subtitle: Text(
                    "Employee: ${request['email']}\n"
                    "Duration: ${request['startDate']} to ${request['endDate']}\n"
                    "Status: ${request['hrStatus']}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('managerLeaveApplications')
                              .doc(request.id)
                              .update({'hrStatus': 'approved'});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('managerLeaveApplications')
                              .doc(request.id)
                              .update({'hrStatus': 'rejected'});
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
