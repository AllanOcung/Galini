import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:galini/screens/home/appointment_screen.dart';

class TherapistFinderScreen extends StatelessWidget {
  const TherapistFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user's UID
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text('User not logged in.'));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Find a Therapist",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFBDDDFC),
      ),
      body: _specialistList(currentUser.uid), // Pass currentUserId to the widget
    );
  }

  Widget _specialistList(String currentUserId) {
  return StreamBuilder<QuerySnapshot>(
    // Fetch only documents where status is 'approved'
    stream: FirebaseFirestore.instance
        .collection('therapist_requests')
        .where('status', isEqualTo: 'approved')
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text('No approved therapist requests found.'));
      }

      // Mapping Firestore data to _specialistItem widgets
      return ListView(
        children: snapshot.data!.docs.map((doc) {
          String name = doc['name'] ?? 'No Name';
          String location = doc['location'] ?? 'No location';
          String role = doc['specialty'] ?? 'No Specialty';
          String therapistId = doc.id;

          return _specialistItem(
            context: context, // Pass the context here
            name: name,
            location: location,
            role: role,
            therapistId: therapistId,
            currentUserId: currentUserId,
          );
        }).toList(),
      );
    },
  );
}


 Widget _specialistItem({
  required BuildContext context,
  required String name,
  required String location,
  required String role,
  required String therapistId,
  required String currentUserId,
}) {
  return Card(
    color: Colors.grey[200],
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage('images/doctor2.jpg'),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "$role • $location", // Show role and location together
        style: const TextStyle(color: Colors.black54),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
      onTap: () {
        // Navigate to specialist profile or details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentScreen(
              therapistId: therapistId,
              currentUserId: currentUserId,
            ),
          ),
        );
      },
    ),
  );
}

}
