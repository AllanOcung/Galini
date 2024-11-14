import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firestore
import 'package:galini/screens/appointments/patient_appointment_screen.dart';
import 'package:galini/screens/home/appointment_screen.dart';
import 'package:galini/screens/home/settings_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
          userName = userDoc['fullName'] ?? 'User'; // Use 'User' if name not found
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
        backgroundColor: const Color(0xFFBDDDFC),
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false, // Disable the back arrow
        title: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Welcome,", style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                  ),
                ],
              ),
              const SizedBox(width: 115),
              const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage("images/doctor1.jpg"),
              ),
              // Notification Icon
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {
                  // Navigate to the notifications screen or show a dialog
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const NotificationsScreen(),
                  //   ),
                  // );
                },
              ),
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
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: const Text(
                      'What do you need today?',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildVisitCard(
                        context: context,
                        onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientAppointmentBookingScreen(),
                            ),
                          );
                        },
                        icon: Icons.calendar_today,
                        iconColor: const Color.fromARGB(255, 103, 164, 245),
                        title: "Book",
                        subtitle: "Appointment",
                        backgroundColor: const Color.fromARGB(255, 103, 164, 245),
                      ),
                      _buildVisitCard(
                        context: context,
                        onTap: () {},
                        icon: Icons.quiz,
                        iconColor: const Color.fromARGB(255, 103, 164, 245),
                        title: "Self",
                        subtitle: "Assessment",
                        backgroundColor: Colors.white, // FDFCDE
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                        'Next Appointment',
                        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      //SizedBox(width: 135),
                      InkWell(
                        // onTap: (){
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const ScheduleScreen(),
                        //     ),
                        //   );
                        // },
                        child: Text(
                          "See all",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                          
                        ),
                      ),
                      ],                   
                    ),
                  ),
                  // Next Appointment Card
                  _nextAppointmentCard(),
                  const SizedBox(height: 15),
                  // Popular Therapists section
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      "Popular Therapists",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  _specialistList(),
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
    double width = 160,
    double height = 160,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(15),
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
        child: Center(
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
              const SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              //const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

    Widget _nextAppointmentCard() {
    return Center(
      child: SizedBox(
        width: 320,
        height: 114,
        child: Card(
          color: const Color.fromARGB(255, 103, 164, 245),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('images/doctor1.jpg'), // Placeholder image
                  radius: 30,
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Therapy',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Dr. Gibson',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '17 June, 13:00 - 14:30',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _specialistList() {
    return StreamBuilder<QuerySnapshot>(
      // Fetch only documents where status is 'approved'
      stream: FirebaseFirestore.instance
          .collection('therapist_requests')
          .where('status', isEqualTo: 'approved')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No approved therapist requests found.'));
        }

        // Mapping Firestore data to _specialistItem widgets
        return Column(
          children: snapshot.data!.docs.map((doc) {
            String name = doc['name'] ?? 'No Name';
            String role = doc['role'] ?? 'No Role';
            String therapistId = doc.id;

            return _specialistItem(name, role, therapistId);
          }).toList(),
        );
      },
    );
  }

  Widget _specialistItem(String name, String role, String therapistId) {
    return Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('images/doctor2.jpg'), 
        ),
        title: Text(name),
        subtitle: Text(role),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () {
          // Navigate to specialist profile or details
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentScreen(therapistId: therapistId, currentUserId: currentUser!.uid),
          ),
        );
        },
      ),
    );
  }

}

