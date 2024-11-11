import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TherapistManagementScreen extends StatefulWidget {
  @override
  _TherapistManagementScreenState createState() => _TherapistManagementScreenState();
}

class _TherapistManagementScreenState extends State<TherapistManagementScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  List<String> selectedTimeSlots = [];
  DateTime? selectedDate;
  List<String> availableTimeSlots = [];
  final TextEditingController timeSlotController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAvailableTimeSlots();
  }

  // Fetch default available time slots set by the therapist
  Future<void> fetchAvailableTimeSlots() async {
    final doc = await FirebaseFirestore.instance
        .collection('therapistTimeSlots')
        .doc(currentUser!.uid)
        .get();

    if (doc.exists) {
      setState(() {
        availableTimeSlots = List<String>.from(doc.data()?['timeSlots'] ?? []);
      });
    } else {
      setState(() {
        availableTimeSlots = []; // Default to empty if no slots are set
      });
    }
  }

  // Save default available time slots to Firestore
  Future<void> saveDefaultTimeSlots() async {
    try {
      await FirebaseFirestore.instance
          .collection('therapistTimeSlots')
          .doc(currentUser!.uid)
          .set({'timeSlots': availableTimeSlots});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Time slots saved successfully!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save time slots: $e")));
    }
  }

  // Set availability for selected date and time slots
Future<void> setAvailability() async {
  if (selectedDate != null && selectedTimeSlots.isNotEmpty) {
    // Format selectedDate to yyyy-MM-dd
    final formattedDate = "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

    final dateRef = FirebaseFirestore.instance
        .collection('therapistAvailability')
        .doc(currentUser!.uid)
        .collection('dates')
        .doc(formattedDate); // Store the formatted date as the document ID

    try {
      await dateRef.set({'timeSlots': selectedTimeSlots});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Availability set successfully!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to set availability: $e")));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a date and time slots.")));
  }
}


  // Date Picker for selecting availability date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedTimeSlots = []; // Reset time slots when date changes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Appointments"),
        backgroundColor: const Color(0xFFBDDDFC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Manage Default Time Slots", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: timeSlotController,
              decoration: InputDecoration(
                labelText: 'Enter Time Slot (e.g., 10:00 AM - 11:00 AM)',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final timeSlot = timeSlotController.text.trim();
                if (timeSlot.isNotEmpty && !availableTimeSlots.contains(timeSlot)) {
                  setState(() {
                    availableTimeSlots.add(timeSlot);
                    timeSlotController.clear();
                  });
                }
              },
              child: Text("Add Time Slot"),
            ),
            Wrap(
              spacing: 8,
              children: availableTimeSlots.map((timeSlot) {
                return Chip(
                  label: Text(timeSlot),
                  onDeleted: () {
                    setState(() {
                      availableTimeSlots.remove(timeSlot);
                    });
                  },
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: saveDefaultTimeSlots,
              child: Text("Save Default Time Slots"),
            ),
            Divider(),
            Text("Set Daily Availability", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(selectedDate == null ? 'Select Date' : selectedDate.toString().substring(0, 10)),
            ),
            Wrap(
              spacing: 8,
              children: availableTimeSlots.map((timeSlot) {
                return FilterChip(
                  label: Text(timeSlot),
                  selected: selectedTimeSlots.contains(timeSlot),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedTimeSlots.add(timeSlot);
                      } else {
                        selectedTimeSlots.remove(timeSlot);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: setAvailability,
                child: Text("Set Availability for Selected Date"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}









// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class TherapistManagementScreen extends StatefulWidget {
//   @override
//   _TherapistManagementScreenState createState() => _TherapistManagementScreenState();
// }

// class _TherapistManagementScreenState extends State<TherapistManagementScreen> {

//  User? currentUser = FirebaseAuth.instance.currentUser;

//   //String therapistId = currentUser!.uid;
//   List<String> selectedTimeSlots = [];
//   DateTime? selectedDate;
//   List<String> availableTimeSlots = ['10:00 AM - 11:00 AM', '11:00 AM - 12:00 PM', '2:00 PM - 3:00 PM'];

//   // Fetch appointments for the therapist
//   Stream<QuerySnapshot> fetchAppointments() {
//     return FirebaseFirestore.instance
//         .collection('appointments')
//         .where('therapistId', isEqualTo: currentUser!.uid)
//         .where('appointmentDate', isGreaterThanOrEqualTo: DateTime.now().toIso8601String())
//         .orderBy('appointmentDate')
//         .snapshots();
//   }

//   // Update the appointment status
//   Future<void> updateAppointmentStatus(String appointmentId, String newStatus) async {
//     try {
//       await FirebaseFirestore.instance.collection('appointments').doc(appointmentId).update({'status': newStatus});
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Appointment status updated to $newStatus.")));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update appointment status: $e")));
//     }
//   }

//   // Set availability for selected date
//   Future<void> setAvailability() async {
//     if (selectedDate != null && selectedTimeSlots.isNotEmpty) {
//       final dateRef = FirebaseFirestore.instance
//           .collection('therapistAvailability')
//           .doc(currentUser!.uid)
//           .collection('dates')
//           .doc(selectedDate!.toIso8601String());

//       try {
//         await dateRef.set({'timeSlots': selectedTimeSlots});
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Availability set successfully!")));
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to set availability: $e")));
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a date and time slots.")));
//     }
//   }

//   // Date Picker for selecting availability date
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(Duration(days: 30)),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         selectedTimeSlots = []; // Reset time slots when date changes
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Therapist Dashboard"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Upcoming Appointments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: fetchAppointments(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return Text("No upcoming appointments.");
//                   }

//                   return ListView(
//                     children: snapshot.data!.docs.map((doc) {
//                       final data = doc.data() as Map<String, dynamic>;
//                       return Card(
//                         child: ListTile(
//                           title: Text("Appointment with Patient ${data['patientId']}"),
//                           subtitle: Text("Date: ${data['appointmentDate']} \nTime Slot: ${data['timeSlot']} \nStatus: ${data['status']}"),
//                           trailing: DropdownButton<String>(
//                             hint: Text("Update Status"),
//                             onChanged: (newStatus) {
//                               if (newStatus != null) {
//                                 updateAppointmentStatus(data['appointmentId'], newStatus);
//                               }
//                             },
//                             items: ['pending', 'confirmed', 'completed'].map((status) {
//                               return DropdownMenuItem(
//                                 value: status,
//                                 child: Text(status),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//             Text("Set Availability", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: () => _selectDate(context),
//               child: Text(selectedDate == null ? 'Select Date' : selectedDate.toString().substring(0, 10)),
//             ),
//             SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               children: availableTimeSlots.map((timeSlot) {
//                 return FilterChip(
//                   label: Text(timeSlot),
//                   selected: selectedTimeSlots.contains(timeSlot),
//                   onSelected: (bool selected) {
//                     setState(() {
//                       if (selected) {
//                         selectedTimeSlots.add(timeSlot);
//                       } else {
//                         selectedTimeSlots.remove(timeSlot);
//                       }
//                     });
//                   },
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 16),
//             Center(
//               child: ElevatedButton(
//                 onPressed: setAvailability,
//                 child: Text("Set Availability"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
