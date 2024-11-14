import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:galini/screens/therapist/chat_screen.dart';
//import 'package:url_launcher/url_launcher.dart';

class PatientDetailsScreen extends StatelessWidget {
  final String patientId;

  const PatientDetailsScreen({
    Key? key,
    required this.patientId,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Get the currently logged-in user
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Patient Details"),
          backgroundColor: const Color(0xFF7D99AA),
          centerTitle: true,
        ),
        body: const Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Patient Details"),
        backgroundColor: const Color(0xFF7D99AA),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(patientId)
            .get(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasError) {
            return const Center(child: Text("Error loading patient details"));
          }

          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return const Center(child: Text("No data found for this patient"));
          }

          final userDoc = userSnapshot.data!;
          final patientName = userDoc['fullName'] ?? 'Unknown Patient';
          final helpReasons = List<String>.from(userDoc['helpReasons'] ?? []);
          final email = userDoc['email'] ?? 'No email provided';
          final phoneNumber = userDoc['phoneNumber'] ?? 'No phone number provided';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Patient Name Section
                Text(
                  patientName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 110.0),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        // Phone Call Section                
                      IconButton(
                        onPressed: () {
                          //_makePhoneCall(phoneNumber);
                        },
                        icon: const Icon(Icons.phone, size: 30.0, color: Color(0xFF7D99AA)),
                        tooltip: 'Call Patient',
                      ),
                      
                      // Chat Section (Icon)
                      const SizedBox(width: 10.0),
                      IconButton(
                        onPressed: () {
                          // Navigate to chat screen (you can replace this with actual navigation logic)
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatScreen(patientId: patientId)),
                          );
                        },
                        icon: const Icon(Icons.chat, size: 30.0, color: Color(0xFF7D99AA)),
                        tooltip: 'Chat with Patient',
                      ),
                    ],
                    ),
                ),
                const SizedBox(height: 8.0),
                Divider(color: Colors.grey.shade400),

                // Help Reasons Section
                const SizedBox(height: 16.0),
                Text(
                  'Help Reasons',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: const Color.fromARGB(255, 61, 57, 57),),
                ),
                const SizedBox(height: 8.0),
                helpReasons.isEmpty
                    ? const Text("No help reasons listed.", style: TextStyle(color: Colors.grey))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: helpReasons
                            .map((reason) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text('• $reason', style: const TextStyle(color: Color.fromARGB(255, 121, 118, 118),),),
                                ))
                            .toList(),
                      ),

                // Contact Information Section
                const SizedBox(height: 16.0),
                Text(
                  'Contact Information',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: const Color.fromARGB(255, 61, 57, 57),),
                ),
                const SizedBox(height: 8.0),
                Text('• Email: $email', style: const TextStyle(color: Color.fromARGB(255, 121, 118, 118),),),
                Text('• Phone: $phoneNumber', style: const TextStyle(color: Color.fromARGB(255, 121, 118, 118),),),             
              ],
            ),
          );
        },
      ),
    );
  }
}

// class ChatScreen extends StatelessWidget {
//   const ChatScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Placeholder for the chat screen, you can integrate your existing chat UI here
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Chat"),
//         backgroundColor: const Color(0xFF7D99AA),
//       ),
//       body: const Center(child: Text("Chat with the patient here")),
//     );
//   }
// }
