import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color.fromARGB(255, 51, 172, 92),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        children: [
          _dashboardItem(
            context,
            title: 'User Management',
            icon: Icons.people,
            onTap: () {
              // Navigate to user management screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserManagementScreen()),
              );
            },
          ),
          _dashboardItem(
            context,
            title: 'Therapist Management',
            icon: Icons.person,
            onTap: () {
              // Navigate to therapist management screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TherapistManagementScreen()),
              );
            },
          ),
          _dashboardItem(
            context,
            title: 'Appointment Management',
            icon: Icons.calendar_today,
            onTap: () {
              // Navigate to appointment management screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AppointmentManagementScreen()),
              );
            },
          ),
          _dashboardItem(
            context,
            title: 'Resource Management',
            icon: Icons.book,
            onTap: () {
              // Navigate to resource management screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ResourceManagementScreen()),
              );
            },
          ),
          _dashboardItem(
            context,
            title: 'System Monitoring',
            icon: Icons.monitor,
            onTap: () {
              // Navigate to system monitoring screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SystemMonitoringScreen()),
              );
            },
          ),
          _dashboardItem(
            context,
            title: 'Notifications',
            icon: Icons.notifications,
            onTap: () {
              // Navigate to notifications screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
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
              Icon(icon, size: 50, color: const Color.fromARGB(255, 51, 172, 92)),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: const Center(child: Text('User Management Screen')),
    );
  }
}

class TherapistManagementScreen extends StatelessWidget {
  const TherapistManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Therapist Management')),
      body: const Center(child: Text('Therapist Management Screen')),
    );
  }
}

class AppointmentManagementScreen extends StatelessWidget {
  const AppointmentManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Management')),
      body: const Center(child: Text('Appointment Management Screen')),
    );
  }
}

class ResourceManagementScreen extends StatelessWidget {
  const ResourceManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resource Management')),
      body: const Center(child: Text('Resource Management Screen')),
    );
  }
}

class SystemMonitoringScreen extends StatelessWidget {
  const SystemMonitoringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('System Monitoring')),
      body: const Center(child: Text('System Monitoring Screen')),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(child: Text('Notifications Screen')),
    );
  }
}
