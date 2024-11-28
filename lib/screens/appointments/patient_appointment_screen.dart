import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientAppointmentBookingScreen extends StatefulWidget {
  const PatientAppointmentBookingScreen({super.key});

  @override
  _PatientAppointmentBookingScreenState createState() => _PatientAppointmentBookingScreenState();
}

class _PatientAppointmentBookingScreenState extends State<PatientAppointmentBookingScreen> {
  String? selectedTherapistId;
  DateTime? selectedDate;
  String? selectedTimeSlot;
  List<String> availableDates = [];
  List<String> availableTimeSlots = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch therapists from Firestore
  Future<List<Map<String, dynamic>>> fetchTherapists() async {
    final snapshot = await FirebaseFirestore.instance.collection('therapist_requests').get();
    return snapshot.docs.map((doc) => {
      'therapistId': doc.id,
      'name': doc['name'],
    }).toList();
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
        // Assuming doc.id is a valid DateTime string or timestamp
        DateTime date = DateTime.parse(doc.id); // Ensure it's parsed as DateTime
        return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      }).toList();
      availableTimeSlots = []; // Reset time slots
    });
  } else {
    setState(() {
      availableDates = [];
      availableTimeSlots = [];  // No available dates or time slots
    });
  }
}


  // Fetch available time slots for a selected therapist and date
  Future<void> fetchAvailableTimeSlots(String therapistId, DateTime date) async {
    final dateString = date.toIso8601String().split("T")[0]; // Format date for consistency
    final availabilityRef = FirebaseFirestore.instance
        .collection('therapistAvailability')
        .doc(therapistId)
        .collection('dates')
        .doc(dateString);

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

  if (selectedTherapistId != null && selectedDate != null && selectedTimeSlot != null) {
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
      final therapistDoc = await _firestore.collection('therapist_requests').doc(selectedTherapistId).get();
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
      'therapistId': selectedTherapistId,
      'therapistName': therapistName,
      'appointmentDate': Timestamp.fromDate(selectedDate!),
      'timeSlot': selectedTimeSlot,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore.collection('appointments').doc(appointmentId).set(appointmentData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment booked successfully!")),
      );

      // Optionally, reset the form
      setState(() {
        selectedTherapistId = null;
        selectedDate = null;
        selectedTimeSlot = null;
        availableDates = [];
        availableTimeSlots = [];
      });
    } catch (e) {
      print("Error booking appointment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to book appointment: $e")),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please complete all fields.")),
    );
  }
}


  // Select date using a date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedTimeSlot = null; // Reset time slot selection when date changes
      });
      if (selectedTherapistId != null) {
        fetchAvailableTimeSlots(selectedTherapistId!, picked);
      }
    }
  }

  // Convert DateTime to string and display it in the dropdown
  String? formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3E9FF),
      appBar: AppBar(
        title: const Text(
          "Book Meeting",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 103, 164, 245),
          ),
          ),
        backgroundColor: const Color(0xFFBDDDFC),
        iconTheme: const IconThemeData(
          color: Colors.blue, // Set the back arrow color here
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Therapist Dropdown
            FutureBuilder<List<Map<String, dynamic>>>( 
              future: fetchTherapists(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No therapists available.");
                }

                final therapists = snapshot.data!;
                return DropdownButtonFormField<String>(
                  hint: const Text("Select Therapist"),
                  value: selectedTherapistId,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTherapistId = newValue;
                      selectedDate = null; // Reset date when therapist changes
                      selectedTimeSlot = null; // Reset time slot
                      availableDates = [];
                      availableTimeSlots = [];
                    });
                    if (newValue != null) {
                      fetchAvailableDates(newValue);
                    }
                  },
                  items: therapists.map((therapist) {
                    return DropdownMenuItem<String>(
                      value: therapist['therapistId'],
                      child: Text(therapist['name'] ?? "Therapist"),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 16),

            // Date Picker - Display available dates if available
            availableDates.isEmpty
              ? const Text("No available dates.")
              : DropdownButtonFormField<String>(
                  hint: const Text("Select Date"),
                  value: selectedDate == null ? null : formatDate(selectedDate!),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDate = DateTime.parse(newValue!);
                      selectedTimeSlot = null; // Reset time slot when date changes
                    });
                    if (selectedTherapistId != null) {
                      fetchAvailableTimeSlots(selectedTherapistId!, selectedDate!);
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
                child: const Text("Confirm", style: TextStyle(color: Colors.blue),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
