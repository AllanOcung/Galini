import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesScreen extends StatelessWidget {
  final String currentUserId;

  const MessagesScreen({super.key, required this.currentUserId});

  Future<List<Map<String, dynamic>>> _fetchMessages() async {
    List<Map<String, dynamic>> chatsList = [];
    QuerySnapshot chatDocs = await FirebaseFirestore.instance
        .collection('chats')
        .where('patientId', isEqualTo: currentUserId)
        .get();

    for (var chat in chatDocs.docs) {
      String chatId = chat.id;
      String therapistId = chat['therapistId'];
      String lastMessage = "";
      Timestamp lastMessageTimestamp;

      // Fetch the last message from the messages sub-collection
      QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (messagesSnapshot.docs.isNotEmpty) {
        lastMessage = messagesSnapshot.docs.first['text'];
        lastMessageTimestamp = messagesSnapshot.docs.first['timestamp'];
      } else {
        lastMessageTimestamp = Timestamp.now(); // Default to now if no messages
      }

      // Fetch therapist details
      DocumentSnapshot therapistDoc = await FirebaseFirestore.instance
          .collection('therapist_requests')
          .doc(therapistId)
          .get();
      String therapistName = therapistDoc['name'];

      chatsList.add({
        'therapistId': therapistId,
        'therapistName': therapistName,
        'lastMessage': lastMessage,
        'lastMessageTime': lastMessageTimestamp.toDate(),
      });
    }

    return chatsList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchMessages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No messages yet"));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Messages",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 335,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      hintText: 'Search',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var chat = snapshot.data![index];
                  var lastMessageTime = chat['lastMessageTime'] as DateTime;
                  var formattedTime = '${lastMessageTime.hour}:${lastMessageTime.minute}';

                  return ListTile(
                    onTap: () {
                      // Navigate to ChatScreen
                    },
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(chat['therapistImage']),
                    ),
                    title: Text(
                      chat['therapistName'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      chat['lastMessage'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    trailing: Text(
                      formattedTime,
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}











// import 'package:flutter/material.dart';

// class MessagesScreen extends StatelessWidget {
//   final List imgs = [
//     "doctor1.jpg",
//     "doctor2.jpg",
//     "doctor3.jpg",
//     "doctor4.jpg",
//     "doctor1.jpg",
//     "doctor2.jpg",
//   ];

//   final bool activeStatus = true;

//   MessagesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 40),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: Text(
//               "Messages",
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(height: 30),
//         // Search bar
//           Center(
//             child: SizedBox(
//               height: 50,
//               width: 335,
//               child: TextField(
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
//                   hintText: 'Search',
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             height: 90,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: 6,
//               shrinkWrap: true,
//               itemBuilder: (context, index) {
//                 return Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 12),
//                   width: 65,
//                   height: 65,
//                   decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                           offset: Offset(0, 3),
//                         ),
//                       ]),
//                   child: Stack(
//                     textDirection: TextDirection.rtl,
//                     children: [
//                       Center(
//                         child: SizedBox(
//                           height: 65,
//                           width: 65,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(30),
//                             child: Image.asset(
//                               "images/${imgs[index]}",
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.all(2),
//                         padding: const EdgeInsets.all(3),
//                         height: 20,
//                         width: 20,
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             color: Colors.blue,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           ListView.builder(
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: 6,
//             shrinkWrap: true,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 onTap: () {
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(
//                   //     builder: (context) => ChatScreen(
//                   //       conversationId: conversationId, // Pass the correct conversation ID here
//                   //       currentUserId: currentUserId,   // Pass the correct user ID here
//                   //     ),
//                   //   ),
//                   // );
//                 },
//                 leading: CircleAvatar(
//                   radius: 30,
//                   backgroundImage: AssetImage(
//                     "images/${imgs[index]}",
//                   ),
//                 ),
//                 title: const Text(
//                   "Doctor Name",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 subtitle: const Text(
//                   "Hello, Doctor, are you there? asd as d asd a sd asd as d s",
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 trailing: const Text(
//                   "12:30",
//                   style: TextStyle(fontSize: 15, color: Colors.black54),
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
