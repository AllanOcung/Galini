import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientAppointmentBookingScreen2 extends StatefulWidget {
  final String therapistId; // Added therapistId as a parameter to the constructor

  const PatientAppointmentBookingScreen2({super.key, required this.therapistId});

  @override
  _PatientAppointmentBookingScreenState createState() =>
      _PatientAppointmentBookingScreenState();
}

class _PatientAppointmentBookingScreenState extends State<PatientAppointmentBookingScreen2> {
  String? selectedDate;
  String? selectedTimeSlot;
  List<String> availableDates = [];
  List<String> availableTimeSlots = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchAvailableDates(widget.therapistId); // Fetch available dates for the provided therapistId
  }

  // Fetch available dates for a selected therapist
  Future<void> fetchAvailableDates(String therapistId) async {
    final datesRef = FirebaseFirestore.instance
        .collection('therapistAvailability')
        .doc(therapistId)
        .collection('dates');
    final snapshot = await datesRef.get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        // Format the date in yyyy-MM-dd format before adding to the list
        availableDates = snapshot.docs.map((doc) {
          DateTime date = DateTime.parse(doc.id); // Ensure it's parsed as DateTime
          return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        }).toList();
        availableTimeSlots = []; // Reset time slots
      });
    } else {
      setState(() {
        availableDates = [];
        availableTimeSlots = []; // No available dates or time slots
      });
    }
  }

  // Fetch available time slots for a selected therapist and date
  Future<void> fetchAvailableTimeSlots(String therapistId, String date) async {
    final availabilityRef = FirebaseFirestore.instance
        .collection('therapistAvailability')
        .doc(therapistId)
        .collection('dates')
        .doc(date);

    final doc = await availabilityRef.get();
    if (doc.exists) {
      setState(() {
        availableTimeSlots = List<String>.from(doc.data()?['timeSlots'] ?? []);
      });
    } else {
      setState(() {
        availableTimeSlots = []; // No available slots for the selected date
      });
    }
  }

  // Book the appointment
  Future<void> bookAppointment() async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in to book an appointment.")),
      );
      return;
    }

    if (selectedDate != null && selectedTimeSlot != null) {
      final appointmentId = _firestore.collection('appointments').doc().id;

      // Fetch the patient’s name (current user)
      String patientName = '';
      try {
        final patientDoc = await _firestore.collection('users').doc(user.uid).get();
        if (patientDoc.exists) {
          patientName = patientDoc.data()?['fullName'] ?? 'Patient'; // Default to 'Patient' if no name is found
        }
      } catch (e) {
        print("Error fetching patient name: $e");
        patientName = 'Patient';
      }

      // Fetch the therapist’s name
      String therapistName = '';
      try {
        final therapistDoc = await _firestore.collection('therapist_requests').doc(widget.therapistId).get();
        if (therapistDoc.exists) {
          therapistName = therapistDoc.data()?['name'] ?? 'Therapist'; // Default to 'Therapist' if no name is found
        }
      } catch (e) {
        print("Error fetching therapist name: $e");
        therapistName = 'Therapist';
      }

      // Prepare appointment data
      final appointmentData = {
        'appointmentId': appointmentId,
        'patientId': user.uid,
        'patientName': patientName,
        'therapistId': widget.therapistId,
        'therapistName': therapistName,
        'appointmentDate': Timestamp.fromDate(DateTime.parse(selectedDate!)),
        'timeSlot': selectedTimeSlot,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      try {
        await _firestore.collection('appointments').doc(appointmentId).set(appointmentData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Meeting booked successfully!")),
        );

        // Optionally, reset the form
        setState(() {
          selectedDate = null;
          selectedTimeSlot = null;
          availableDates = [];
          availableTimeSlots = [];
        });
      } catch (e) {
        print("Error booking appointment: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to book a meeting: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3E9FF),
      appBar: AppBar(
        title: const Text("Book A Meeting", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
        backgroundColor: const Color(0xFFBDDDFC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker - Display available dates if available
            availableDates.isEmpty
              ? const Text("No available dates.")
              : DropdownButtonFormField<String>(
                  hint: const Text("Select Date"),
                  value: selectedDate,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDate = newValue;
                      selectedTimeSlot = null; // Reset time slot when date changes
                    });
                    if (selectedDate != null) {
                      fetchAvailableTimeSlots(widget.therapistId, selectedDate!);
                    }
                  },
                  items: availableDates.map((date) {
                    return DropdownMenuItem<String>(
                      value: date,
                      child: Text(date),
                    );
                  }).toList(),
                ),
            const SizedBox(height: 16),

            // Time Slot Dropdown - Display available time slots if available
            availableTimeSlots.isEmpty
                ? const Text("No available time slots.")
                : DropdownButtonFormField<String>(
                    hint: const Text("Select Time Slot"),
                    value: selectedTimeSlot,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTimeSlot = newValue;
                      });
                    },
                    items: availableTimeSlots.map((timeSlot) {
                      return DropdownMenuItem<String>(
                        value: timeSlot,
                        child: Text(timeSlot),
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 24),

            // Book Appointment Button
            Center(
              child: ElevatedButton(
                onPressed: bookAppointment,
                child: const Text("Confirm Booking", style: TextStyle(color: Colors.blue),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
