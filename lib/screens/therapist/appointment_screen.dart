import 'package:flutter/material.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(child: Text("Appointments")),
        backgroundColor: const Color(0xFF7D99AA),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: 5, // Example number of appointments
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text("Patient ${index + 1}"),
            subtitle: const Text("10:00 AM - 11:00 AM"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Show appointment details
            },
          );
        },
      ),
    );
  }
}
