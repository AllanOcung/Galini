import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompletedSchedule extends StatelessWidget {
  const CompletedSchedule({super.key});

  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    // Retrieve only appointments with 'completed' status and matching patientId
    final querySnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('status', isEqualTo: 'completed')
        .where('patientId', isEqualTo: userId)
        .get();

    final appointments = await Future.wait(querySnapshot.docs.map((doc) async {
      var data = doc.data();
      data['appointmentDate'] = _formatTimestamp(data['appointmentDate']);
      
      // Fetch therapist details using therapistId
      final therapistId = data['therapistId'];  // Therapist ID from appointment
      final therapistData = await _fetchTherapistData(therapistId);

      // Add therapist data to appointment
      data['role'] = therapistData['role'] ?? 'Unknown';
      data['therapistName'] = therapistData['name'] ?? 'Unknown';
      return data;
    }));

    return appointments;
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
      final dateTime = timestamp.toDate();  // Convert Timestamp to DateTime
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';  // Format as mm/dd/yyyy
    }
    return 'Unknown';  // Return a default value if the value is not a Timestamp
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAppointments(),
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
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AppointmentCard(
                        doctorName: appointments[index]['therapistName'] ?? 'Unknown',
                        specialization: appointments[index]['role'] ?? 'therapist',
                        date: appointments[index]['appointmentDate'] ?? 'Unknown',
                        time: appointments[index]['timeSlot'] ?? 'Unknown',
                        statusColor: Colors.blue,
                        statusText: "Completed",
                        imagePath: "images/doctor2.jpg",
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

  const AppointmentCard({
    super.key,
    required this.doctorName,
    required this.specialization,
    required this.date,
    required this.time,
    required this.statusColor,
    required this.statusText,
    required this.imagePath,
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
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
