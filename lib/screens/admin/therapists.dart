import 'package:flutter/material.dart';

class AdminTherapistsScreen extends StatelessWidget {
  const AdminTherapistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Therapists"),
        backgroundColor: const Color.fromARGB(255, 103, 164, 245),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Search Therapists",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with actual therapist count
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Therapist Name"),
                    subtitle: const Text("therapist@example.com"),
                    trailing: const Text("Approved"), // Replace with actual status
                    onTap: () {
                      // Option to view therapist profile or approve/reject
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
