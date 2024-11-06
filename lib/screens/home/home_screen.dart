import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firestore
import 'package:galini/screens/home/appointment_screen.dart';
import 'package:galini/screens/home/settings_screen.dart';
import 'package:google_fonts/google_fonts.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> symptoms = [
    "Temperature",
    "Snuffle",
    "Fever",
    "Cough",
    "Cold",
  ];

  final List<String> imgs = [
    "doctor1.jpg",
    "doctor2.jpg",
    "doctor3.jpg",
    "doctor4.jpg",
  ];

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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 70, 
          automaticallyImplyLeading: false, // Disable the back arrow
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hello, $userName!",
                style: GoogleFonts.lobster(
                  textStyle: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage("images/doctor1.jpg"),
            ),
            //const SizedBox(width: 5),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingScreen(),
                  ),
                );
              },
              child: const Icon(Icons.menu, color: Colors.black),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildVisitCard(
                        context: context,
                        onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentScreen(),
                            ),
                          );
                        },
                        icon: Icons.local_hospital,
                        iconColor: const Color.fromARGB(255, 103, 164, 245),
                        title: "Clinic Visit",
                        subtitle: "Make an appointment",
                        backgroundColor: const Color.fromARGB(255, 103, 164, 245),
                      ),
                      _buildVisitCard(
                        context: context,
                        onTap: () {},
                        icon: Icons.video_call,
                        iconColor: const Color.fromARGB(255, 103, 164, 245),
                        title: "Virtual Visit",
                        subtitle: "Consult a doctor",
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // Popular Doctors section
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      "Popular Doctors",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: imgs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildDoctorCard(
                        context: context,
                        imageUrl: "images/${imgs[index]}",
                        name: "Dr. Doctor Name",
                        role: "Therapist",
                        rating: "4.9",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentScreen(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build the Clinic and Virtual Visit cards
  Widget _buildVisitCard({
    required BuildContext context,
    required VoidCallback onTap,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color backgroundColor,
    Color textColor = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 35,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                color: textColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build Doctor cards
  Widget _buildDoctorCard({
    required BuildContext context,
    required String imageUrl,
    required String name,
    required String role,
    required String rating,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage(imageUrl),
              ),
              Text(
                name,
                  style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),             
              ),
              Text(
                role,
                style: const TextStyle(
                  color: Colors.black45,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  Text(
                    rating,
                    style: const TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
