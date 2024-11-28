import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompletedSchedule extends StatelessWidget {
  const CompletedSchedule({super.key});

  // Stream for fetching completed appointments
  Stream<List<Map<String, dynamic>>> fetchAppointments() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return FirebaseFirestore.instance
        .collection('appointments')
        .where('status', isEqualTo: 'completed')
        .where('patientId', isEqualTo: userId)
        .snapshots() // Listen to real-time updates
        .asyncMap((snapshot) async {
          // Ensure we resolve each future inside the map
          List<Map<String, dynamic>> appointments = [];
          for (var doc in snapshot.docs) {
            var data = doc.data();
            data['appointmentDate'] = _formatTimestamp(data['appointmentDate']);

            final therapistId = data['therapistId'];
            final therapistData = await _fetchTherapistData(therapistId);
            
            data['role'] = therapistData['role'] ?? 'Unknown';
            data['therapistName'] = therapistData['name'] ?? 'Unknown';
            data['appointmentId'] = doc.id; // Store the document ID for deletion
            appointments.add(data);
          }
          return appointments;
        });
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

  Future<void> deleteAppointment(String appointmentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .delete();
      print('Appointment deleted');
    } catch (e) {
      print('Error deleting appointment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: fetchAppointments(), // Stream for real-time updates
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No completed appointments"));
          }

          final appointments = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Completed Appointments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppointmentCard(
                      doctorName: appointment['therapistName'] ?? 'Unknown',
                      specialization: appointment['role'] ?? 'therapist',
                      date: appointment['appointmentDate'] ?? 'Unknown',
                      time: appointment['timeSlot'] ?? 'Unknown',
                      statusColor: Colors.blue,
                      statusText: "Completed",
                      imagePath: "images/doctor2.jpg",
                      appointmentId: appointment['appointmentId'], // Pass appointment ID for deletion
                      onDelete: () {
                        deleteAppointment(appointment['appointmentId']);
                      },
                    ),
                  );
                },
              ),
            ],
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
  final String appointmentId;
  final VoidCallback onDelete; // Callback for delete action

  const AppointmentCard({
    super.key,
    required this.doctorName,
    required this.specialization,
    required this.date,
    required this.time,
    required this.statusColor,
    required this.statusText,
    required this.imagePath,
    required this.appointmentId,
    required this.onDelete,
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
                const SizedBox(width: 20),
                Row(
                  children: [
                    const Icon(Icons.access_time_filled, color: Colors.black54),
                    const SizedBox(width: 5),
                    Text(time, style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const Divider(thickness: 1, height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                const SizedBox(width: 30),
                // Delete Button
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
