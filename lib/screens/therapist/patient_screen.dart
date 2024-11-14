import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:galini/screens/therapist/patient_details_screen.dart';

class PatientsScreen extends StatelessWidget {
  const PatientsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Patients", textAlign: TextAlign.center),
        backgroundColor: Color(0xFF7D99AA),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: userId == null
          ? const Center(child: Text("User not logged in"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('therapistId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No patients found"));
                }

                final appointments = snapshot.data!.docs;

                // Use a Set to track unique patientIds
                Set<String> uniquePatientIds = {};
                List<Map<String, dynamic>> uniquePatientsList = [];

                for (var appointment in appointments) {
                  final patientId = appointment['patientId'] ?? '';

                  // Add to Set if it's a new patientId, ensuring uniqueness
                  if (!uniquePatientIds.contains(patientId)) {
                    uniquePatientIds.add(patientId);
                    uniquePatientsList.add(appointment.data() as Map<String, dynamic>);
                  }
                }

                return ListView.separated(
                  itemCount: uniquePatientsList.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final patientId = uniquePatientsList[index]['patientId'];
                    final patientName = uniquePatientsList[index]['patientName'] ?? 'Unknown Patient';

                    // Fetch helpReasons from the users collection using patientId
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(patientId)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return const ListTile(
                            title: Text("Loading patient details..."),
                          );
                        }

                        if (userSnapshot.hasError) {
                          return const ListTile(
                            title: Text("Error loading patient details"),
                          );
                        }

                        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                          return const ListTile(
                            title: Text("No data found for this patient"),
                          );
                        }

                        final userDoc = userSnapshot.data!;
                        final helpReasons = List<String>.from(userDoc['helpReasons'] ?? []);

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            child: Text(
                              patientName[0], // Display the first letter of the patient's name
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(patientName),
                          subtitle: helpReasons.isEmpty
                              ? const Text("No conditions listed")
                              : Text(helpReasons.join(', ')), // Displaying the list of helpReasons
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigate to detailed patient screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientDetailsScreen(patientId: patientId),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}

// // Placeholder for the Patient Details Screen
// class PatientDetailsScreen extends StatelessWidget {
//   final String patientName;
//   const PatientDetailsScreen({Key? key, required this.patientName}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("$patientName's Details"),
//       ),
//       body: Center(
//         child: Text("Details for $patientName"),
//       ),
//     );
//   }
// }
