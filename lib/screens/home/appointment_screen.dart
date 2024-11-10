import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galini/screens/home/chat_screen.dart';

class AppointmentScreen extends StatelessWidget {
  final String therapistId; // Pass the therapist's document ID when navigating to this screen
  final String currentUserId;

  const AppointmentScreen({super.key, required this.therapistId, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 103, 164, 245),
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
          String role = data['role'] ?? 'No Role';
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
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            const Icon(
                              Icons.more_vert,
                              color: Colors.white,
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
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                role,
                                style: const TextStyle(
                                  color: Colors.white60,
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
                                      color: Color(0xFF9F97E2),
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
                                          builder: (context) => ChatScreen(
                                            //conversationId: conversationId,
                                            currentUserId: currentUserId,
                                            therapistId: therapistId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF9F97E2),
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
                          const Text(
                            "About Doctor",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            qualification,
                            style: const TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                "Experience:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
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
                          const SizedBox(height: 5),
                           Row(
                            children: [
                              const Text(
                                "Reviews",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 10),
                              const Text(
                                "4.9",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                "(124)",
                                style: TextStyle(color: Colors.black54),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "See all",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 103, 164, 245),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //const SizedBox(height: 10),
                            SizedBox(
                            height: 170,
                            // width: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.symmetric(vertical: 5),
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
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width / 1.4,
                                    child: const Column(
                                      children: [
                                        ListTile(
                                          leading: CircleAvatar(
                                            radius: 25,
                                            backgroundImage:
                                                AssetImage("images/doctor3.jpg"),
                                          ),
                                          title: Text(
                                            "therapist's Name",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text("1 day ago"),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              Text(
                                                "4.9",
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            "Many thanks to Dr. Dear. He is a great and a professional doctor.",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          //const SizedBox(height: 10),
                          const Text(
                            "Location",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.location_on,
                                color: Color.fromARGB(255, 103, 164, 245)),
                            title: Text(location),
                            subtitle: const Text("address line of the medical center"),
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
                  "Consultation price",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "\$100",
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
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 103, 164, 245),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Book Appointment",
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
















// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:galini/screens/home/chat_screen.dart';

// class AppointmentScreen extends StatelessWidget {
//   final String therapistId;
//   final String currentUserId;

//   const AppointmentScreen({super.key, required this.therapistId, required this.currentUserId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 103, 164, 245),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance
//             .collection('therapist_requests')
//             .doc(therapistId)
//             .get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text("Therapist details not found."));
//           }

//           var data = snapshot.data!.data() as Map<String, dynamic>;
//           String name = data['name'] ?? 'No Name';
//           String role = data['role'] ?? 'No Role';
//           String email = data['email'] ?? 'No Email';
//           String experience = data['experience'] ?? 'No Experience';
//           String location = data['location'] ?? 'No Location';
//           String phoneNumber = data['phoneNumber'] ?? 'N/A';
//           String qualification = data['qualifications'] ?? 'No Qualification';

//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 const SizedBox(height: 50),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Stack(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Icon(
//                               Icons.arrow_back_ios_new,
//                               color: Colors.white,
//                               size: 25,
//                             ),
//                           ),
//                           const Icon(
//                             Icons.more_vert,
//                             color: Colors.white,
//                             size: 28,
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             const CircleAvatar(
//                               radius: 35,
//                               backgroundImage: AssetImage("images/doctor2.jpg"),
//                             ),
//                             const SizedBox(height: 15),
//                             Text(
//                               name,
//                               style: const TextStyle(
//                                 fontSize: 23,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               role,
//                               style: const TextStyle(
//                                 color: Colors.white60,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 15),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(10),
//                                   decoration: const BoxDecoration(
//                                     color: Color(0xFF9F97E2),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Icon(
//                                     Icons.call,
//                                     color: Colors.white,
//                                     size: 25,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 20),
//                                 InkWell(
//                                   borderRadius: BorderRadius.circular(30),
//                                   onTap: () async {
//                                     String conversationId = await getOrCreateConversationId(currentUserId, therapistId);
//                                     if (conversationId.isNotEmpty) {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => ChatScreen(
//                                             conversationId: conversationId,
//                                             currentUserId: currentUserId,
//                                             therapistId: therapistId,
//                                           ),
//                                         ),
//                                       );
//                                     } else {
//                                       ScaffoldMessenger.of(context).showSnackBar(
//                                         const SnackBar(content: Text("Unable to start chat")),
//                                       );
//                                     }
//                                   },
//                                   child: Container(
//                                     padding: const EdgeInsets.all(10),
//                                     decoration: const BoxDecoration(
//                                       color: Color(0xFF9F97E2),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: const Icon(
//                                       CupertinoIcons.chat_bubble_text_fill,
//                                       color: Colors.white,
//                                       size: 25,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 Container(
//                   height: MediaQuery.of(context).size.height / 1.5,
//                   width: double.infinity,
//                   padding: const EdgeInsets.only(top: 20, left: 15),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       topRight: Radius.circular(10),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         const Text(
//                           "Contact Information",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         ListTile(
//                           leading: const Icon(Icons.email, color: Colors.black54),
//                           title: Text(email),
//                         ),
//                         ListTile(
//                           leading: const Icon(Icons.phone, color: Colors.black54),
//                           title: Text(phoneNumber),
//                         ),
//                         const SizedBox(height: 5),
//                         const Text(
//                           "About Doctor",
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           qualification,
//                           style: const TextStyle(fontSize: 16, color: Colors.black54),
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           children: [
//                             const Text(
//                               "Experience:",
//                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                             ),
//                             const SizedBox(width: 10),
//                             Text(
//                               experience,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16,
//                                 color: Colors.black54,
//                               ),
//                             ),
//                             const SizedBox(width: 5),
//                             const Text(
//                               "years",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16,
//                                 color: Colors.black54,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<String> getOrCreateConversationId(String currentUserId, String therapistId) async {
//     try {
//       // Check if a conversation already exists between the user and therapist
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('conversations')
//           .where('participants', arrayContains: [currentUserId, therapistId])
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         // Conversation exists, return the ID
//         return querySnapshot.docs.first.id;
//       }

//       // No existing conversation, create a new one
//       DocumentReference newConversation = await FirebaseFirestore.instance.collection('conversations').add({
//         'participants': [currentUserId, therapistId],
//         'createdAt': Timestamp.now(),
//       });

//       return newConversation.id;
//     } catch (e) {
//       print("Error getting or creating conversation: $e");
//       return '';
//     }
//   }
// }
