import 'package:flutter/material.dart';

class TherapistProfileScreen extends StatelessWidget {
  final String name;
  final String specialty;
  final String location;

  const TherapistProfileScreen({
    super.key,
    required this.name,
    required this.specialty,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("images/doctor1.jpg"), // Replace with actual image
            ),
            const SizedBox(height: 20),
            const Text(
              "Specialty: specialty",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black,),
            ),
            const SizedBox(height: 10),
            const Text(
              "Location: location",
              style: const TextStyle(fontSize: 16, color: Colors.black,),
            ),
            const SizedBox(height: 20),
            const Text(
              "About the Therapist",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black,),
            ),
            const SizedBox(height: 10),
            const Text(
              "Dr. Allan is a licensed therapist specializing in specialty. They have over 10 years of experience and work with clients to help them overcome their mental health challenges.",
              style: TextStyle(fontSize: 16,color: Colors.black,),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Navigate to booking screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 103, 164, 245),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
              child: const Text(
                "Book an Appointment",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
