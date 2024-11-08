import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:galini/models/conversation.dart';
import 'package:galini/widgets/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  final String conversationId;
  final String currentUserId; // The ID of the current user

  const ChatScreen({
    Key? key,
    required this.conversationId,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.white,
          leadingWidth: 30,
          title: const Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(
                  "images/doctor1.jpg",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Dr. Doctor Name",
                  style: TextStyle(
                    color: Color.fromARGB(255, 51, 172, 92),
                  ),
                ),
              ),
            ],
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.call,
                color: Color.fromARGB(255, 51, 172, 92),
                size: 26,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.video_call,
                color: Color.fromARGB(255, 51, 172, 92),
                size: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.more_vert,
                color: Color.fromARGB(255, 51, 172, 92),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('conversations')
            .doc(conversationId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No messages yet."));
          }
          
          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 80),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];
              bool isSender = data['senderId'] == currentUserId;

              return ChatBubble(
                content: data['content'],
                isSender: isSender,
              );
            },
          );
        },
      ),
      bottomSheet: _buildMessageInput(),
    );
  }

  Widget _buildMessageInput() {
    TextEditingController messageController = TextEditingController();

    return Container(
      height: 65,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ]),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(
              Icons.add,
              size: 30,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Icon(
              Icons.emoji_emotions_outlined,
              size: 30,
              color: Color.fromARGB(255, 51, 172, 92),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: "Type something",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.send,
              color: Color.fromARGB(255, 51, 172, 92),
            ),
            onPressed: () {
              if (messageController.text.trim().isNotEmpty) {
                _sendMessage(messageController.text.trim());
                messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String content) async {
    final senderId = currentUserId;

    Message message = Message(
      senderId: senderId,
      receiverId: '', // Specify receiver ID if needed
      content: content,
      timestamp: Timestamp.now(),
    );

    await FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add(message.toMap());

    // Update last message in conversation document if needed
    await FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .update({'lastMessage': content});
  }
}
