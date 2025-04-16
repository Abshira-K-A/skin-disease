import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'notification_service.dart';

class ScheduleRoutinePage extends StatefulWidget {
  final String userId;

  const ScheduleRoutinePage({super.key, required this.userId});

  @override
  _ScheduleRoutinePageState createState() => _ScheduleRoutinePageState();
}

class _ScheduleRoutinePageState extends State<ScheduleRoutinePage> {
  final Color _primaryColor = const Color(0xFF8B4513);
  final Color _secondaryColor = const Color(0xFFD2B48C);
  final Color _accentColor = const Color(0xFFCD853F);
  final Color _backgroundColor = const Color(0xFFFAF9F6);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF5D4037);

  TimeOfDay _morningTime = TimeOfDay(hour: 8, minute: 0)
  ;
  TimeOfDay _eveningTime = TimeOfDay(hour: 20, minute: 0);
  List<String> _selectedProducts = [];
  String? _routineFrequency;
  String? username;
  String? skinType;
  bool _isLoading = true;
  bool _hasExistingSchedule = false;

  // Calendar related variables
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Set<DateTime> _selectedDays = {};
  bool _enableSpecificDays = false;

  final List<String> _productOptions = [
    'Cleanser', 'Toner', 'Moisturizer', 'Sunscreen',
    'Serum', 'Eye Cream', 'Face Mask', 'Exfoliator'
  ];

  final List<String> _frequencyOptions = [
    'Morning only', 'Evening only', 'Both', 'Specific days'
  ];

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _checkNotificationPermissions();
    _loadUserData();
    _loadExistingSchedule();
  }

  Future<void> _checkNotificationPermissions() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final bool? granted = await androidPlugin.areNotificationsEnabled();
        if (granted == false) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please enable notifications for reminder functionality"),
                duration: Duration(seconds: 3),
            ));
          });
        }
      }
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      final bool? result = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      if (result == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please enable notifications in Settings"),
              duration: Duration(seconds: 3),
          ));
        });
      }
    }
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          username = userSnapshot['name'] ?? 'User';
          skinType = userSnapshot['skinType'] ?? 'Not specified';
        });
      } else {
        setState(() {
          username = 'User';
          skinType = 'Not specified';
        });
      }
    } catch (e) {
      setState(() {
        username = 'User';
        skinType = 'Not specified';
      });
      debugPrint("Error loading user data: $e");
    }
  }

  Future<void> _loadExistingSchedule() async {
    try {
      QuerySnapshot scheduleSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('skincare_routines')
          .where('status', isEqualTo: 'active')
          .orderBy('created_at', descending: true)
          .limit(1)
          .get();

      if (scheduleSnapshot.docs.isNotEmpty) {
        var scheduleData = scheduleSnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _hasExistingSchedule = true;
          _routineFrequency = scheduleData['frequency'] ?? 'Both';
          _selectedProducts = List<String>.from(scheduleData['products'] ?? []);
          
          // Load morning time
          if (scheduleData['morning_time'] != null) {
            List<String> morningParts = (scheduleData['morning_time'] as String).split(':');
            _morningTime = TimeOfDay(
              hour: int.parse(morningParts[0]),
              minute: int.parse(morningParts[1]),
            );
          }
          
          // Load evening time
          if (scheduleData['evening_time'] != null) {
            List<String> eveningParts = (scheduleData['evening_time'] as String).split(':');
            _eveningTime = TimeOfDay(
              hour: int.parse(eveningParts[0]),
              minute: int.parse(eveningParts[1]),
            );
          }
          
          // Load specific days if they exist
          if (scheduleData['specific_days'] != null) {
            _selectedDays = (scheduleData['specific_days'] as List<dynamic>)
                .map((timestamp) => (timestamp as Timestamp).toDate())
                .toSet();
            _enableSpecificDays = _selectedDays.isNotEmpty;
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
      debugPrint("Error loading existing schedule: $e");
    }
  }

Future<void> _saveReminderTime(TimeOfDay selectedTime, bool isMorning) async {
  // Save to Firestore or any other storage if needed
  await FirebaseFirestore.instance
      .collection('users')
      .doc('userID') // Replace with actual user ID
      .set({
    isMorning ? 'morning_reminder_time' : 'evening_reminder_time': {
      'hour': selectedTime.hour,
      'minute': selectedTime.minute,
    },
  }, SetOptions(merge: true));

  // Call the function to schedule the notification
  await NotificationService.scheduleNotificationFromTimeOfDay(
    0, // Notification ID
    isMorning ? 'Morning Reminder' : 'Evening Reminder', // Title
    'Its time for skin care', // Body
    selectedTime, // Selected time for reminder
  );

  // Provide feedback to user (optional)
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("${isMorning ? 'Morning' : 'Evening'} reminder set for ${selectedTime.format(context)}")),
  );
}


Future<void> _saveRoutine() async {
  setState(() => _isLoading = true);

  try {
    // Cancel existing notifications
    await NotificationService.cancelAllNotifications();

    // Save morning routine if needed
    if (_routineFrequency == 'Morning only' || _routineFrequency == 'Both') {
      await NotificationService.storeAndScheduleRoutine(
        userId: widget.userId,
        routineName: 'Morning Skincare Routine',
        products: _selectedProducts,
        time: _morningTime,
        isMorning: true,
        frequency: _routineFrequency!,
        specificDays: _enableSpecificDays ? _selectedDays.toList() : null,
      );
    }

    // Save evening routine if needed
    if (_routineFrequency == 'Evening only' || _routineFrequency == 'Both') {
      await NotificationService.storeAndScheduleRoutine(
        userId: widget.userId,
        routineName: 'Evening Skincare Routine',
        products: _selectedProducts,
        time: _eveningTime,
        isMorning: false,
        frequency: _routineFrequency!,
        specificDays: _enableSpecificDays ? _selectedDays.toList() : null,
      );
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _hasExistingSchedule 
              ? "Routine updated successfully!" 
              : "Routine created successfully!"),
        backgroundColor: _accentColor,
      ),
    );

    setState(() => _hasExistingSchedule = true);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: ${e.toString()}"),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}

Future<void> _selectTime(BuildContext context, bool isMorning) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: isMorning ? _morningTime : _eveningTime,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: _accentColor,
            onPrimary: Colors.white,
            onSurface: _textColor,
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

    // Call the save reminder function to schedule the notification
    await _saveReminderTime(picked, isMorning);
  }
}


  int _generateNotificationId(String type) {
    final userIdHash = widget.userId.hashCode;
    if (type.startsWith('morning')) {
      return userIdHash % 10000 + 1000;
    } else if (type.startsWith('evening')) {
      return userIdHash % 10000 + 2000;
    }
    return userIdHash % 10000 + 3000;
  }

Future<void> saveSkincareRoutine(String routineName, List<String> products, String time) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in.");
    }

    // Fetch user details from 'users' collection
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      throw Exception("User details not found.");
    }

    String name = userDoc['name'];
    String email = userDoc['email'];

    // Store routine in 'skincare_routines' collection
    await FirebaseFirestore.instance.collection('skincare_routines').add({
      'userId': user.uid,
      'name': name,
      'email': email,
      'routineName': routineName,
      'products': products,
      'time': time,
      'timestamp': FieldValue.serverTimestamp(),
    });

    print("Skincare routine saved successfully!");
  } catch (e) {
    print("Error saving routine: $e");
  }
}


  Future<void> _scheduleNotifications(bool isMorning) async {
    if (_enableSpecificDays && _selectedDays.isNotEmpty) {
      for (final day in _selectedDays) {
        await NotificationService._scheduleDailyNotification(
          id: _generateNotificationId(
              '${isMorning ? 'morning' : 'evening'}_${day.hashCode}'),
          title: isMorning 
              ? "🌞 Time for your morning skincare routine!" 
              : "🌙 Time for your evening skincare routine!",
          body: "Don't forget to use: ${_selectedProducts.join(', ')}",
          time: isMorning ? _morningTime : _eveningTime,
          payload: isMorning ? 'morning_routine' : 'evening_routine',
          specificDate: day,
        );
      }
    } else {
      await NotificationService._scheduleDailyNotification(
        id: _generateNotificationId(isMorning ? 'morning' : 'evening'),
        title: isMorning 
            ? "🌞 Time for your morning skincare routine!" 
            : "🌙 Time for your evening skincare routine!",
        body: "Don't forget to use: ${_selectedProducts.join(', ')}",
        time: isMorning ? _morningTime : _eveningTime,
        payload: isMorning ? 'morning_routine' : 'evening_routine',
      );
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          _hasExistingSchedule ? "Update Routine" : "Create Routine",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
/* ElevatedButton(
  onPressed: () {
    TimeOfDay selectedTime = TimeOfDay(hour: 11, minute: 42);  // Example Time
    NotificationService.scheduleNotificationFromTimeOfDay(
        1, "Reminder", "Time for your skincare routine!", selectedTime);
  },
  child: Text("Set Reminder"),
), */
ElevatedButton(
  onPressed: () async {
    print("Calling scheduleNotification...");
    await NotificationService.scheduleNotification(
      1,
      "Time for your skincare routine! 🧴",
      "Don't forget to apply your night cream!",
      DateTime.now().add(Duration(seconds: 60)), // Schedule after 10 seconds for testing
    );
    print("✅ scheduleNotification function called!");
  },
  child: Text("Schedule Reminder"),
),




                  // Welcome Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                    )],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, $username!",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: _primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: _textColor,
                            ),
                            children: [
                              
                              TextSpan(
                                text: _hasExistingSchedule 
                                    ? "Update your skincare routine "
                                    : "Let's create your personalized routine ",
                              ),
                              TextSpan(
                                text: "for your ",
                              ),
                              TextSpan(
                                text: skinType ?? "skin",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _accentColor,
                                ),
                              ),
                              const TextSpan(
                                text: ".",
                              ),
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Frequency Section
                  Text(
                    "Routine Frequency",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )],
                    ),
                    child: Column(
                      children: _frequencyOptions.map((option) {
                        return RadioListTile<String>(
                          title: Text(
                            option,
                            style: GoogleFonts.poppins(
                              color: _textColor,
                            ),
                          ),
                          value: option,
                          groupValue: _routineFrequency,
                          onChanged: (value) {
                            setState(() {
                              _routineFrequency = value;
                              _enableSpecificDays = value == 'Specific days';
                            });
                          },
                          activeColor: _accentColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Calendar for specific days selection
                  if (_enableSpecificDays)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Days for Your Routine",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _textColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: _cardColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                           ) ],
                          ),
                          child: TableCalendar(
                            firstDay: DateTime.now(),
                            lastDay: DateTime.now().add(const Duration(days: 365)),
                            focusedDay: _focusedDay,
                            calendarFormat: _calendarFormat,
                            selectedDayPredicate: (day) => _selectedDays.contains(day),
                            onDaySelected: _onDaySelected,
                            onFormatChanged: (format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                            calendarStyle: CalendarStyle(
                              selectedDecoration: BoxDecoration(
                                color: _accentColor,
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color: _accentColor.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              markersAlignment: Alignment.bottomCenter,
                              markersMaxCount: 1,
                              markerDecoration: BoxDecoration(
                                color: _accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: true,
                              formatButtonShowsNext: false,
                              formatButtonDecoration: BoxDecoration(
                                color: _accentColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              formatButtonTextStyle: TextStyle(
                                color: Colors.white),
                              titleTextStyle: GoogleFonts.poppins(
                                color: _textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: GoogleFonts.poppins(
                                color: _textColor.withOpacity(0.8),
                              ),
                              weekendStyle: GoogleFonts.poppins(
                                color: _textColor.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_selectedDays.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            children: _selectedDays.map((day) {
                              return Chip(
                                label: Text(
                                  "${day.day}/${day.month}/${day.year}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: _textColor,
                                  ),
                                ),
                                backgroundColor: _accentColor.withOpacity(0.1),
                                deleteIcon: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: _accentColor,
                                ),
                                onDeleted: () {
                                  setState(() {
                                    _selectedDays.remove(day);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),

                  // Time Selection Cards
                  if ((_routineFrequency == 'Morning only' || _routineFrequency == 'Both') && !_enableSpecificDays)
                    _buildTimeCard(
                      context,
                      isMorning: true,
                      time: _morningTime,
                    ),
                  
                  if ((_routineFrequency == 'Evening only' || _routineFrequency == 'Both') && !_enableSpecificDays)
                    _buildTimeCard(
                      context,
                      isMorning: false,
                      time: _eveningTime,
                    ),
                  
                  // Show time selection for specific days if enabled
                  if (_enableSpecificDays)
                    Column(
                      children: [
                        _buildTimeCard(
                          context,
                          isMorning: true,
                          time: _morningTime,
                        ),
                        _buildTimeCard(
                          context,
                          isMorning: false,
                          time: _eveningTime,
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 24),

                  // Product Selection
                  Text(
                    "Your Products",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                    )],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select products you use:",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: _textColor.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 12),
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
                              selectedColor: _accentColor.withOpacity(0.2),
                              checkmarkColor: _accentColor,
                              labelStyle: GoogleFonts.poppins(
                                fontSize: 13,
                                color: _selectedProducts.contains(product)
                                    ? _accentColor
                                    : _textColor.withOpacity(0.8),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: _selectedProducts.contains(product)
                                      ? _accentColor
                                      : Colors.grey.shade300,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedDays.isNotEmpty || !_enableSpecificDays
                          ? _saveRoutine
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(
                        _hasExistingSchedule ? "Update Routine" : "Save Routine",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTimeCard(BuildContext context, {required bool isMorning, required TimeOfDay time}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isMorning ? Icons.wb_sunny : Icons.nightlight_round,
                  color: _accentColor,
                ),
                const SizedBox(width: 8),
                Text(
                  isMorning ? "Morning Routine" : "Evening Routine",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.access_time,
                  color: _accentColor,
                ),
              ),
              title: Text(
                time.format(context),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: _textColor,
                ),
              ),
              trailing: TextButton(
                onPressed: () => _selectTime(context, isMorning),
                style: TextButton.styleFrom(
                  foregroundColor: _accentColor,
                ),
                child: Text(
                  "Change",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}