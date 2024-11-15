import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TherapistAppointmentsScreen extends StatefulWidget {
  const TherapistAppointmentsScreen({super.key});

  @override
  _TherapistAppointmentsScreenState createState() =>
      _TherapistAppointmentsScreenState();
}

class _TherapistAppointmentsScreenState
    extends State<TherapistAppointmentsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> pendingAppointments = [];
  List<Map<String, dynamic>> upcomingAppointments = [];
  List<Map<String, dynamic>> completedAppointments = [];

  String selectedCategory = 'Pending';

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('appointments')
          .where('therapistId', isEqualTo: user.uid)
          .get();

      setState(() {
        pendingAppointments = [];
        upcomingAppointments = [];
        completedAppointments = [];

        for (var doc in snapshot.docs) {
          final appointment = {
            'appointmentId': doc.id,
            'patientId': doc['patientId'],
            'patientName': doc['patientName'],
            'appointmentDate': doc['appointmentDate'].toDate(),
            'timeSlot': doc['timeSlot'],
            'status': doc['status'],
          };

          if (doc['status'] == 'pending') {
            pendingAppointments.add(appointment);
          } else if (doc['status'] == 'approved') {
            upcomingAppointments.add(appointment);
          } else if (doc['status'] == 'completed') {
            completedAppointments.add(appointment);
          }
        }
      });
    }
  }

  Widget _buildAppointmentList(
    List<Map<String, dynamic>> appointments) {
  return appointments.isEmpty
      ? const Center(child: Text('No appointments available in this category'))
      : ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: const Offset(0, 3), // Shadow offset
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                title: Text(
                  '${appointment['patientName']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text('Date: ${appointment['appointmentDate']}'),
                    Text('Time: ${appointment['timeSlot']}'),
                    Text('Status: ${appointment['status']}'),
                  ],
                ),
                trailing: selectedCategory == 'Pending'
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check),
                            color: const Color(0xFF7D99AA),
                            onPressed: () => _approveAppointment(
                                appointment['appointmentId']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel),
                            color: Colors.red,
                            onPressed: () => _declineAppointment(
                                appointment['appointmentId']),
                          ),
                        ],
                      )
                    : selectedCategory == 'Upcoming'
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.access_time),
                                color: Colors.orange,
                                onPressed: () => _rescheduleAppointment(
                                    appointment['appointmentId']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.done),
                                color: const Color(0xFF7D99AA),
                                onPressed: () => _markAppointmentComplete(
                                    appointment['appointmentId']),
                              ),
                            ],
                          )
                        : null,
              ),
            );
          },
        );
}


  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> selectedAppointments;
    if (selectedCategory == 'Pending') {
      selectedAppointments = pendingAppointments;
    } else if (selectedCategory == 'Upcoming') {
      selectedAppointments = upcomingAppointments;
    } else {
      selectedAppointments = completedAppointments;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(child: Text("Appointments")),
        backgroundColor: const Color(0xFF7D99AA),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Category buttons
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedCategory = 'Pending';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategory == 'Pending'
                        ? const Color(0xFF293325)
                        : Colors.grey,
                  ),
                  child: const Text("Pending", style: TextStyle(color: Colors.white),),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedCategory = 'Upcoming';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategory == 'Upcoming'
                        ? const Color(0xFF293325)
                        : Colors.grey,
                  ),
                  child: const Text("Upcoming", style: TextStyle(color: Colors.white),),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedCategory = 'Completed';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategory == 'Completed'
                        ? const Color(0xFF293325)
                        : Colors.grey,
                  ),
                  child: const Text("Completed", style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
          // Display the selected category appointments
          Expanded(
            child: _buildAppointmentList(selectedAppointments),
          ),
        ],
      ),
    );
  }

  // Approve Appointment
void _approveAppointment(String appointmentId) async {
  try {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': 'approved',
    });
    setState(() {
      pendingAppointments.removeWhere(
          (appointment) => appointment['appointmentId'] == appointmentId);
      _fetchAppointments(); // Refresh the appointments
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment approved successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to approve appointment: $e')),
    );
  }
}

// Decline Appointment
void _declineAppointment(String appointmentId) async {
  try {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': 'declined',
    });
    setState(() {
      pendingAppointments.removeWhere(
          (appointment) => appointment['appointmentId'] == appointmentId);
      _fetchAppointments(); // Refresh the appointments
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment declined successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to decline appointment: $e')),
    );
  }
}

// Reschedule Appointment with Editable Date and Time
void _rescheduleAppointment(String appointmentId) async {
  try {
    // Select new date
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (newDate == null) return; // Return if no date is selected

    // Select new time
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (newTime == null) return; // Return if no time is selected

    // Combine date and time into a single DateTime object
    DateTime newDateTime = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      newTime.hour,
      newTime.minute,
    );

    // Update Firestore with new date and time
    await _firestore.collection('appointments').doc(appointmentId).update({
      'appointmentDate': newDateTime,
      'status': 'approved',
    });

    setState(() {
      upcomingAppointments.removeWhere(
          (appointment) => appointment['appointmentId'] == appointmentId);
      _fetchAppointments(); // Refresh the appointments
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment rescheduled to $newDateTime')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to reschedule appointment: $e')),
    );
  }
}

// Mark Appointment Complete
void _markAppointmentComplete(String appointmentId) async {
  try {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': 'completed',
    });
    setState(() {
      upcomingAppointments.removeWhere(
          (appointment) => appointment['appointmentId'] == appointmentId);
      _fetchAppointments(); // Refresh the appointments
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment marked as completed')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to mark appointment as completed: $e')),
    );
  }
}

}
