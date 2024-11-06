import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galini/screens/authenticate/login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userName = "User"; // Placeholder for user name
  User? currentUser = FirebaseAuth.instance.currentUser; // Get current user

  @override
  void initState() {
    super.initState();
    fetchUserName(); // Fetch the user's name when the screen initializes
  }

  Future<void> fetchUserName() async {
    if (currentUser != null) {
      try {
        // Assuming Firestore collection 'users' where the document ID is the user's UID
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get();

        // Update state with the fetched user's name
        setState(() {
          userName = userDoc['FullName'] ?? 'User'; // Use 'User' if name not found
        });
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the content in a Scaffold to provide the Material widget
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("images/doctor1.jpg"),
                ),
                title: Text(
                  "Dear $userName",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                  ),
                ),
                subtitle: const Text("Profile"),
              ),
              const Divider(height: 50),
              ListTile(
                onTap: () {},
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.person,
                    color: Colors.blue,
                    size: 35,
                  ),
                ),
                title: const Text(
                  "Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              const SizedBox(height: 20),
              ListTile(
                onTap: () {},
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none_outlined,
                    color: Colors.deepPurple,
                    size: 35,
                  ),
                ),
                title: const Text(
                  "Notifications",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              const SizedBox(height: 20),
              ListTile(
                onTap: () {},
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.privacy_tip_outlined,
                    color: Colors.indigo,
                    size: 35,
                  ),
                ),
                title: const Text(
                  "Privacy",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              const SizedBox(height: 20),
              ListTile(
                onTap: () {},
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.settings_suggest_outlined,
                    color: Colors.green,
                    size: 35,
                  ),
                ),
                title: const Text(
                  "General",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              const SizedBox(height: 20),
              ListTile(
                onTap: () {},
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.orange,
                    size: 35,
                  ),
                ),
                title: const Text(
                  "About Us",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              const Divider(height: 40),
              ListTile(
                onTap: () async {
                  await _auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.exit_to_app,
                    color: Colors.redAccent,
                    size: 35,
                  ),
                ),
                title: const Text(
                  "Log Out",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
