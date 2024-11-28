import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:galini/screens/authenticate/login_screen.dart';

class AdminSettingsScreen extends StatelessWidget {
  AdminSettingsScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Admin Profile",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title:  Text("Admin Name"),
              subtitle: Text("admin@example.com"),
            ),
            const Divider(),
            const Text(
              "Settings",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Change Password"),
              onTap: () {
                // Handle password change
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notification Settings"),
              onTap: () {
                // Handle notification settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("System Settings"),
              onTap: () {
                // Handle system settings
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Sign out", style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}
