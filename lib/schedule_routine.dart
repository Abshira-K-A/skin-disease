
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import '../notification_service.dart';


Future<void> requestExactAlarmPermission(BuildContext context) async {
  if (Platform.isAndroid) {
    int sdkInt = int.parse(Platform.version.split(" ")[0]);
    
    if (sdkInt >= 31) { // Android 12 and above
      final intent = AndroidIntent(
        action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
    }
  }
}

class ScheduleRoutinePage extends StatefulWidget {
  final String userId;

  const ScheduleRoutinePage({super.key, required this.userId});

  @override
  _ScheduleRoutinePageState createState() => _ScheduleRoutinePageState();
}

class _ScheduleRoutinePageState extends State<ScheduleRoutinePage> {
  TimeOfDay _morningTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _eveningTime = TimeOfDay(hour: 20, minute: 0);
  List<String> _selectedProducts = [];
  String? _routineFrequency;
  String? username;
  String? skinType;
  bool _isLoading = true;
  bool _hasExistingSchedule = false;

  final List<String> _productOptions = [
    'Cleanser',
    'Toner',
    'Moisturizer',
    'Sunscreen',
    'Serum',
    'Eye Cream',
    'Face Mask',
    'Exfoliator'
  ];

  final List<String> _frequencyOptions = [
    'Morning only',
    'Evening only',
    'Both'
  ];

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _checkNotificationPermissions();
    _loadUserData();
    _loadExistingSchedule();
  }

Future<void> _checkNotificationPermissions() async {
  if (Theme.of(context).platform == TargetPlatform.android) {
    // For Android 13+ (API level 33+)
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        
    if (androidPlugin != null) {
      // Check if we're on Android 13+
      final bool? granted = await androidPlugin.areNotificationsEnabled();
      if (granted == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please enable notifications for reminder functionality"),
              duration: Duration(seconds: 3),
            ),
          );
        });
      }
    }
  } else if (Theme.of(context).platform == TargetPlatform.iOS) {
    // For iOS
    final bool? result = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        
    if (result == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enable notifications in Settings"),
            duration: Duration(seconds: 3),
          ),
        );
      });
    }
  }
}

  Future<void> _loadUserData() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();

    if (userSnapshot.exists) {
      setState(() {
        username = userSnapshot['name'];
        skinType = userSnapshot['skinType'];
      });
    }
  }

  Future<void> _loadExistingSchedule() async {
    try {
      QuerySnapshot scheduleSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('skincare_schedules')
          .orderBy('created_at', descending: true)
          .limit(1)
          .get();

      if (scheduleSnapshot.docs.isNotEmpty) {
        var scheduleData = scheduleSnapshot.docs.first.data() as Map<String, dynamic>;
        
        setState(() {
          _hasExistingSchedule = true;
          _routineFrequency = scheduleData['frequency'] ?? 'Both';
          _selectedProducts = List<String>.from(scheduleData['products'] ?? []);
          
          if (scheduleData['morning_time'] != null) {
            List<String> morningParts = (scheduleData['morning_time'] as String).split(':');
            _morningTime = TimeOfDay(
              hour: int.parse(morningParts[0]),
              minute: int.parse(morningParts[1]),
            );
          }
          
          if (scheduleData['evening_time'] != null) {
            List<String> eveningParts = (scheduleData['evening_time'] as String).split(':');
            _eveningTime = TimeOfDay(
              hour: int.parse(eveningParts[0]),
              minute: int.parse(eveningParts[1]),
            );
          }
          
          _isLoading = false;
        });
      } else {
        setState(() {
          _routineFrequency = 'Both';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _routineFrequency = 'Both';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveRoutine() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Mark existing schedules as inactive
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('skincare_schedules')
          .where('status', isEqualTo: 'active')
          .get()
          .then((snapshot) {
            for (DocumentSnapshot doc in snapshot.docs) {
              doc.reference.update({'status': 'inactive'});
            }
          });

      // Add new schedule
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('skincare_schedules')
          .add({
        'morning_time': '${_morningTime.hour}:${_morningTime.minute}',
        'evening_time': '${_eveningTime.hour}:${_eveningTime.minute}',
        'products': _selectedProducts,
        'frequency': _routineFrequency,
        'created_at': Timestamp.now(),
        'status': 'active',
      });

      // Cancel all previous notifications
      await NotificationService.cancelAllNotifications();

      // Schedule new notifications
      if (_routineFrequency == 'Morning only' || _routineFrequency == 'Both') {
        await NotificationService.scheduleDailyNotification(
          id: 1,
          title: "🌞 Morning Skincare Reminder",
          body: "Time for your morning routine! Products: ${_selectedProducts.join(', ')}",
          time: _morningTime,
        );
      }

    if (_routineFrequency == 'Evening only' || _routineFrequency == 'Both') {
        await NotificationService.scheduleDailyNotification(
          id: 2,
          title: "🌞 Evening Skincare Reminder",
          body: "Time for your Evening routine! Products: ${_selectedProducts.join(', ')}",
          time: _eveningTime,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Routine and reminders updated successfully!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      setState(() {
        _hasExistingSchedule = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      debugPrint("Error saving routine: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isMorning) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isMorning ? _morningTime : _eveningTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepOrangeAccent,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isMorning) {
          _morningTime = picked;
        } else {
          _eveningTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(_hasExistingSchedule ? "Update Your Routine" : "Schedule Your Routine"),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal greeting
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.deepOrangeAccent.withOpacity(0.3)),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(fontSize: 16),
                        children: [
                          TextSpan(
                            text: "Hello $username! ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrangeAccent.shade700),
                          ),
                          TextSpan(
                            text: _hasExistingSchedule 
                                ? "Update your skincare routine "
                                : "Let's schedule your skincare routine ",
                          ),
                          TextSpan(
                            text: "for your $skinType skin.",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Routine Frequency
                  Text(
                    "When do you do your skincare routine?",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  ..._frequencyOptions.map((option) {
                    return RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: _routineFrequency,
                      onChanged: (value) {
                        setState(() {
                          _routineFrequency = value;
                        });
                      },
                      activeColor: Colors.deepOrangeAccent,
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                  const SizedBox(height: 30),

                  // Time Selection Cards
                  if (_routineFrequency == 'Morning only' || _routineFrequency == 'Both')
                    _buildTimeCard(
                      context,
                      isMorning: true,
                      time: _morningTime,
                    ),
                  
                  if (_routineFrequency == 'Evening only' || _routineFrequency == 'Both')
                    _buildTimeCard(
                      context,
                      isMorning: false,
                      time: _eveningTime,
                    ),
                  
                  const SizedBox(height: 30),

                  // Product Selection
                  Text(
                    "Select products you use:",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _productOptions.map((product) {
                      return FilterChip(
                        label: Text(product),
                        selected: _selectedProducts.contains(product),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedProducts.add(product);
                            } else {
                              _selectedProducts.remove(product);
                            }
                          });
                        },
                        selectedColor: Colors.deepOrangeAccent.withOpacity(0.2),
                        checkmarkColor: Colors.deepOrangeAccent,
                        labelStyle: TextStyle(
                          color: _selectedProducts.contains(product)
                              ? Colors.deepOrangeAccent
                              : Colors.grey.shade700,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: _selectedProducts.contains(product)
                                ? Colors.deepOrangeAccent
                                : Colors.grey.shade300,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveRoutine,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        _hasExistingSchedule ? "UPDATE ROUTINE" : "SAVE ROUTINE",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTimeCard(BuildContext context, {required bool isMorning, required TimeOfDay time}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isMorning ? "🌞 Morning Routine" : "🌙 Evening Routine",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time, color: Colors.deepOrangeAccent),
              title: Text(
                time.format(context),
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              trailing: TextButton(
                onPressed: () => _selectTime(context, isMorning),
                child: Text(
                  "Change",
                  style: GoogleFonts.poppins(
                    color: Colors.deepOrangeAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}