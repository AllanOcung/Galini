import 'package:flutter/material.dart';

class PatientsScreen extends StatelessWidget {
  const PatientsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(child: const Text("Patients")),
        backgroundColor: const Color(0xFF7D99AA),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: 10, // Example number of patients
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text("P${index + 1}")),
            title: Text("Patient ${index + 1}"),
            subtitle: const Text("Condition: Anxiety, Stress"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to patient details
            },
          );
        },
      ),
    );
  }
}
