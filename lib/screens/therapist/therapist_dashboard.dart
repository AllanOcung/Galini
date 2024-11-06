import 'package:flutter/material.dart';

class TherapistDashboard extends StatelessWidget {
  const TherapistDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Therapist Dashboard'),
        backgroundColor: const Color.fromARGB(255, 103, 164, 245),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        children: [
          _dashboardItem(
            context,
            title: 'Profile Management',
            icon: Icons.person,
            onTap: () {
              // Navigate to profile management screen
            },
          ),
          _dashboardItem(
            context,
            title: 'Appointment Management',
            icon: Icons.calendar_today,
            onTap: () {
              // Navigate to appointment management screen
            },
          ),
          _dashboardItem(
            context,
            title: 'Patient Profiles',
            icon: Icons.people,
            onTap: () {
              // Navigate to patient profiles screen
            },
          ),
          _dashboardItem(
            context,
            title: 'Resource Sharing',
            icon: Icons.book,
            onTap: () {
              // Navigate to resource sharing screen
            },
          ),
          _dashboardItem(
            context,
            title: 'Feedback & Reviews',
            icon: Icons.star,
            onTap: () {
              // Navigate to feedback and reviews screen
            },
          ),
          _dashboardItem(
            context,
            title: 'Notifications',
            icon: Icons.notifications,
            onTap: () {
              // Navigate to notifications screen
            },
          ),
        ],
      ),
    );
  }

  Widget _dashboardItem(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: const Color.fromARGB(255, 103, 164, 245)),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
