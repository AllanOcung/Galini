import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:galini/screens/authenticate/login_screen.dart';
import 'package:galini/screens/therapist/news_feed_screen.dart';
import 'package:galini/screens/therapist/posts_screen.dart';

class MoreScreen extends StatelessWidget {
  MoreScreen({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(
          child: Text(
            "More",
            style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
            ),
            ),
        backgroundColor: const Color(0xFF7D99AA),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              // Navigate to settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text("My Posts"),
            onTap: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TherapistPostsScreen(),
                    ),
                  );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text("Help & Support"),
            onTap: () {
              // Navigate to help and support
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About"),
            onTap: () {
              // Show app information
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("Logout"),
             onTap: () async {
                await _auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
              },
          ),
        ],
      ),
    );
  }
}
