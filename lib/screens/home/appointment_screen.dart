import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galini/screens/appointments/patient_appointment2_screen.dart';
import 'package:galini/screens/home/patient_chat_screen.dart';

class AppointmentScreen extends StatelessWidget {
  final String therapistId; // Pass the therapist's document ID when navigating to this screen
  final String currentUserId;

  const AppointmentScreen({super.key, required this.therapistId, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBDDDFC),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('therapist_requests')
            .doc(therapistId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Therapist details not found."));
          }
    
          // Retrieve therapist data
          var data = snapshot.data!.data() as Map<String, dynamic>;
          String name = data['name'] ?? 'No Name';
          String role = data['specialty'] ?? 'No Specialty';
          String email = data['email'] ?? 'No Email';
          String experience = data['experience'] ?? 'No Experience';
          String location = data['location'] ?? 'No Location';
          String phoneNumber = data['phoneNumber'] ?? 'N/A';
          String qualification = data['qualifications'] ?? 'No Qualification';
    
          return SingleChildScrollView(
            child: Column(
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.blue,
                                size: 25,
                              ),
                            ),
                            const Icon(
                              Icons.more_vert,
                              color: Colors.blue,
                              size: 28,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const CircleAvatar(
                                radius: 35,
                                backgroundImage: AssetImage("images/doctor2.jpg"),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                role,
                                style: const TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 103, 164, 245),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.call,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(30), // Make sure the ripple stays within the circle
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PatientChatScreen(
                                            therapistId: therapistId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 103, 164, 245),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        CupertinoIcons.chat_bubble_text_fill,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),                                                             ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 20, left: 15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                           const Text(
                            "Contact Information",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.email, color: Colors.black54),
                            title: Text(email),
                          ),
                          ListTile(
                            leading: const Icon(Icons.phone, color: Colors.black54),
                            title: Text(phoneNumber),
                          ),
                          const SizedBox(height: 5),
                            Row(
                            children: [
                              const Text(
                                "Experience:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                experience,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                "years",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          ListTile(
                            leading: const Icon(Icons.location_on,
                                color: Color.fromARGB(255, 103, 164, 245)),
                            title: Text(location),
                            subtitle: const Text("address line of the medical center"),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Card(
                                color: Colors.grey[200],
                                elevation: 3.5, // Shadow for a lifted effect
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "About:",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        qualification,
                                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                     
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15),
        height: 130,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Booking fee",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "\$20",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientAppointmentBookingScreen2(therapistId: therapistId),
                    ),
                  );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 103, 164, 245),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Book Meeting",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

