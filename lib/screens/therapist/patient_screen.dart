import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:galini/screens/therapist/patient_details_screen.dart';

class PatientsScreen extends StatelessWidget {
  const PatientsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Patients",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24, // Adjusted font size for better readability
          ),
        ),
        backgroundColor: const Color(0xFF7D99AA),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 4, // Add shadow for a more elevated look
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'user') // Filter users by role
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No patients found",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          final patients = snapshot.data!.docs;

          // Sort patients alphabetically by name
          patients.sort((a, b) {
            final patientNameA = (a.data() as Map<String, dynamic>)['fullName'] ?? '';
            final patientNameB = (b.data() as Map<String, dynamic>)['fullName'] ?? '';
            return patientNameA.compareTo(patientNameB);
          });

          return ListView.separated(
            itemCount: patients.length,
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              thickness: 0.8,
            ),
            itemBuilder: (context, index) {
              final patient = patients[index].data() as Map<String, dynamic>;
              final patientId = patients[index].id;
              final patientName = patient['fullName'] ?? 'Unknown Patient';
              final helpReasons = List<String>.from(patient['helpReasons'] ?? []);

              return Card(
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  leading: const CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage("images/doctor2.jpg"),
                  ),
                  title: Text(
                    patientName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: helpReasons.isEmpty
                      ? const Text(
                          "No conditions listed",
                          style: TextStyle(color: Colors.grey),
                        )
                      : Text(
                          helpReasons.join(', '),
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF7D99AA),
                  ),
                  onTap: () {
                    // Navigate to detailed patient screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientDetailsScreen(patientId: patientId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
