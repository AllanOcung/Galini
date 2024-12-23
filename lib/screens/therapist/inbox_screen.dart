import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galini/screens/therapist/chat_screen.dart';


class InboxScreen extends StatelessWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "My Chats",
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            ),
          ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF7D99AA),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
              debugPrint("Search tapped");
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // More options
              debugPrint("More options tapped");
            },
          ),
        ],
      ),
      body: const ChatList(),
    );
  }
}

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  Stream<List<Map<String, dynamic>>> _fetchChatsStream() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return Stream.value([]); // Return an empty list if no user is authenticated
  }

  return FirebaseFirestore.instance
      .collection('chats')
      .where('participants', arrayContains: user.uid)
      .snapshots()
      .asyncMap((snapshot) async {
    List<Map<String, dynamic>> chatList = [];

    for (var doc in snapshot.docs) {
      //final chatData = doc.data();
      final subCollection = await FirebaseFirestore.instance
          .collection('chats')
          .doc(doc.id)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (subCollection.docs.isNotEmpty) {
        final latestMessage = subCollection.docs.first.data();
        final receiverId = latestMessage['receiverId'];

        // Fetch the receiver's name from the users collection
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(receiverId)
            .get();
        final userName = userDoc.data()?['fullName'] ?? 'Unknown';

        chatList.add({
          'conversationId': doc.id,
          'lastMessage': latestMessage['message'] ?? '',
          'lastMessageTime': (latestMessage['timestamp'] as Timestamp?)?.toDate(),
          'receiverId': receiverId,
          'name': userName, // Add the receiver's name
        });
      } 
    }

    return chatList;
  });
}


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _fetchChatsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading chats"));
        }

        final chats = snapshot.data ?? [];

        if (chats.isEmpty) {
          return const Center(child: Text("No chats available"));
        }

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: const Text(
                  'a',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                chat['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                chat['lastMessage'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                chat['lastMessageTime'] != null
                    ? "${chat['lastMessageTime'].hour}:${chat['lastMessageTime'].minute.toString().padLeft(2, '0')}"
                    : '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen(patientId: chat['receiverId']),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
