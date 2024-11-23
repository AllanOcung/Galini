import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpcomingSchedule extends StatelessWidget {
  const UpcomingSchedule({super.key});

  Stream<List<Map<String, dynamic>>> appointmentsStream() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('status', isEqualTo: 'approved')
        .where('patientId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              var data = doc.data();
              data['appointmentDate'] = _formatTimestamp(data['appointmentDate']);
              
              // Add therapist data to appointment (async function call handled separately)
              return data;
            }).toList());
  }

  Future<Map<String, dynamic>> _fetchTherapistData(String therapistId) async {
    final therapistDoc = await FirebaseFirestore.instance
        .collection('therapist_requests')
        .doc(therapistId)
        .get();

    return therapistDoc.exists ? therapistDoc.data() ?? {} : {};
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final dateTime = timestamp.toDate();
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
    return 'Unknown';
  }

  Future<void> cancelAppointment(BuildContext context, String appointmentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': 'cancelled'});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment cancelled successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel appointment: $e')),
      );
    }
  }

  Future<void> markAsComplete(BuildContext context, String appointmentId) async {
  try {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentId)
        .update({'status': 'completed'});
    
    // Check if the widget is still mounted before showing a SnackBar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment marked as complete')),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark as complete: $e')),
      );
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: appointmentsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No upcoming appointments"));
          }

          final appointments = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Upcoming Appointments",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AppointmentCard(
                        doctorName: appointments[index]['therapistName'] ?? 'Unknown',
                        specialization: appointments[index]['specialty'] ?? 'therapist',
                        date: appointments[index]['appointmentDate'] ?? 'Unknown',
                        time: appointments[index]['timeSlot'] ?? 'Unknown',
                        statusColor: Colors.blue,
                        statusText: "Confirmed",
                        imagePath: "images/doctor2.jpg",
                        onCancel: () => cancelAppointment(context, appointments[index]['appointmentId']),
                        onComplete: () => markAsComplete(context, appointments[index]['appointmentId']),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String doctorName;
  final String specialization;
  final String date;
  final String time;
  final Color statusColor;
  final String statusText;
  final String imagePath;
  final VoidCallback onCancel;
  final VoidCallback onComplete;  // Add callback for marking as complete

  const AppointmentCard({
    super.key,
    required this.doctorName,
    required this.specialization,
    required this.date,
    required this.time,
    required this.statusColor,
    required this.statusText,
    required this.imagePath,
    required this.onCancel,
    required this.onComplete,  // Pass the function for marking as complete
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListTile(
            title: Text(
              doctorName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(specialization),
            trailing: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(imagePath),
            ),
          ),
          const Divider(thickness: 1, height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.black54),
                    const SizedBox(width: 5),
                    Text(date, style: const TextStyle(color: Colors.black54)),
                  ],
                ),
                const SizedBox(width: 110),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(statusText, style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Divider(thickness: 1, height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                const Icon(Icons.access_time_filled, color: Colors.black54),
                const SizedBox(width: 5),
                Text(time, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: onCancel,
                child: Container(
                  width: 110,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: onComplete,  // Call onComplete when this button is pressed
                child: Container(
                  width: 110,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 103, 164, 245),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Complete",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
