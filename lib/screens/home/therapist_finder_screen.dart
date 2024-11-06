import 'package:flutter/material.dart';
import 'package:galini/screens/home/therapist_profile_screen.dart';

class TherapistFinderScreen extends StatelessWidget {
  const TherapistFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Find a Therapist",
          style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold,
            color: Colors.blue),
          ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _therapistTile(
            context: context,
            name: "Dr. Jane Doe",
            specialty: "Anxiety & Depression",
            location: "New York, NY",
          ),
          _therapistTile(
            context: context,
            name: "Dr. John Smith",
            specialty: "Family Therapy",
            location: "Los Angeles, CA",
          ),
          _therapistTile(
            context: context,
            name: "Dr. Emily Rose",
            specialty: "Cognitive Behavioral Therapy (CBT)",
            location: "Chicago, IL",
          ),
        ],
      ),
    );
  }

  Widget _therapistTile({
    required BuildContext context,
    required String name,
    required String specialty,
    required String location,
  }) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage("images/doctor1.jpg"), // Placeholder image
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text("$specialty • $location"),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Navigate to the therapist profile page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TherapistProfileScreen(
              name: name,
              specialty: specialty,
              location: location,
            ),
          ),
        );
      },
    );
  }
}
