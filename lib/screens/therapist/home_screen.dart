import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galini/screens/therapist/posts_screen.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galini/screens/therapist/assessment_management_screen.dart';

import '../appointments/therapist_appointment _management_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Fetch the count of active patients with 'approved' status
  Future<int> _getActivePatientsCount() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'user') 
        .get();
    
    return querySnapshot.docs.length; // Return the count of approved appointments
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, MMMM d');
    return formatter.format(now);
  }

  Future<String> _getUserName() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return 'User';
    
    final userDoc = await FirebaseFirestore.instance.collection('therapist_requests').doc(userId).get();
    return userDoc['name'] ?? 'User';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40), // For spacing at the top
              FutureBuilder<String>(
                future: _getUserName(),
                builder: (context, snapshot) {
                  final userName = snapshot.data ?? 'User';
                  final greeting = _getGreeting();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$greeting, $userName",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                        _getFormattedDate(),
                        style: const TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(width: 80,),
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage("images/doctor1.jpg"),
                          ),
                        ],
                      ),
                      
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              // Search bar
              Center(
                child: SizedBox(
                  height: 50,
                  width: 335,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      hintText: 'Search',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Dashboard",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              FutureBuilder<int>(
                future: _getActivePatientsCount(),
                builder: (context, snapshot) {
                  String activePatientsCount = '0';
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    activePatientsCount = snapshot.data.toString();
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildOverviewCard(activePatientsCount, "Active Patients", Colors.white, Icons.person),
                      _buildOverviewCard("04", "Rescheduled", Colors.white, Icons.refresh),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Next Appointment',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      child: Text(
                        "See all",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              _nextAppointmentCard(),
              const SizedBox(height: 10),
               Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: const Text(
                    "Assessments",
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TherapistAssessmentManagementScreen()),
                  );
                },
                child: Card(
                  color: const Color(0xFF293325),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Manage assessments",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
              // My posts
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: const Text(
                    "My Posts",
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to a detailed My Posts screen
                     Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TherapistPostsScreen(),
                    ),
                  );
                  },
                  child: Card(
                    color: const Color(0xFF293325),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "View and Manage Posts",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: const Text(
                  "Availability",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TherapistManagementScreen()),
                  );
                },
                child: Card(
                  color: const Color(0xFF293325),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Manage Availability",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFF7D99AA),
    );
  }

  Widget _buildOverviewCard(String count, String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF293325),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _nextAppointmentCard() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
  return StreamBuilder<QuerySnapshot>(
    
    stream: FirebaseFirestore.instance
        .collection('appointments')
        .where('status', isEqualTo: 'approved') // Filter for approved appointments
        .where('therapistId', isEqualTo: userId)
        .orderBy('appointmentDate') // Order by appointment date (ascending)
        .limit(1) // Get only the soonest appointment
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Card(
          color: Colors.grey[200],
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'You have no upcoming appointments.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }

      // Extract the first appointment document
      var appointment = snapshot.data!.docs.first;
      String therapistName = appointment['patientName'] ?? 'Patient';
      String therapistImage = 'images/doctor1.jpg';

      // Safely handle `appointmentDate` as a Firestore Timestamp
      Timestamp? appointmentDateTimestamp = appointment['appointmentDate'];
      String appointmentDate = appointmentDateTimestamp != null
          ? DateFormat('dd MMM yyyy').format(appointmentDateTimestamp.toDate())
          : 'Unknown Date';

      String timeSlot = appointment['timeSlot'] ?? 'Unknown Time';

      return Center(
        child: SizedBox(
          width: 320,
          height: 114,
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(therapistImage), // Using dynamic image or placeholder
                    radius: 30,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        therapistName,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        appointmentDate,
                        style: const TextStyle(color: Colors.black45, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        timeSlot,
                        style: const TextStyle(color: Colors.black45),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}


}
