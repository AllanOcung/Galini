import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galini/screens/admin/request_list_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  String userName = "User"; // Placeholder for user name
  User? currentUser = FirebaseAuth.instance.currentUser; // Get current user
  int pendingRequestsCount = 0; // Count of pending requests
  int totalUsersCount = 0; 

  @override
  void initState() {
    super.initState();
    fetchUserName(); // Fetch the user's name when the screen initializes
    fetchPendingRequestsCount(); // Fetch pending requests count
  }

  Future<void> fetchUserName() async {
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get();
        setState(() {
          userName = userDoc['fullName'] ?? 'User'; // Use 'User' if name not found
        });
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> fetchPendingRequestsCount() async {
    try {
      // Query the therapist_requests collection to count pending requests
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('therapist_requests')
          .where('status', isEqualTo: 'pending')
          .get();

      setState(() {
        pendingRequestsCount = snapshot.docs.length; // Set the count of pending requests
      });
    } catch (e) {
      print('Error fetching pending requests: $e');
    }
  }

  Future<void> fetchTotalUsersCount() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'user')
          .get();

      setState(() {
       totalUsersCount = snapshot.docs.length; 
      });
    } catch (e) {
      print('Error fetching total users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false, // Disable the back arrow
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Welcome Back,", style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Text(
                    userName,
                    style: GoogleFonts.lobster(
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage("images/doctor1.jpg"),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: 50,
                  width: 350,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search here...",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _dashboardCard("Requests", pendingRequestsCount.toString(), Icons.pending),
                  const SizedBox(width: 10),
                  _dashboardCard("Total Users", totalUsersCount.toString(), Icons.group),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _dashboardCard("Total Therapists", "20", FontAwesomeIcons.userDoctor),
                  const SizedBox(width: 10),
                  _dashboardCard("Recent Activities", "3", Icons.history),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Quick Actions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _quickActionButton(context, "View All Therapist Requests"),
              _quickActionButton(context, "View All Users"),
              _quickActionButton(context, "Admin Settings"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dashboardCard(String title, String count, IconData icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Navigate to the requests list page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RequestsListScreen(), // Replace with your requests list screen
            ),
          );
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Icon(icon, size: 40, color: const Color.fromARGB(255, 103, 164, 245)),
                  const SizedBox(height: 10),
                  Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(title),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _quickActionButton(BuildContext context, String label) {
    return ElevatedButton(
      onPressed: () {
        // Implement navigation or action
      },
      style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 103, 164, 245)),
      child: Text(label),
    );
  }
}

// Dummy screen for the Requests List, replace with your actual screen
// class RequestsListScreen extends StatelessWidget {
//   const RequestsListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Pending Therapist Requests")),
//       body: Center(child: const Text("List of Pending Therapist Requests")),
//     );
//   }
// }
