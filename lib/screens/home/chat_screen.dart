import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String therapistId;

  const ChatScreen({
    Key? key,
    required this.currentUserId,
    required this.therapistId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _conversationId {
    final userId = _auth.currentUser!.uid;
    final sortedIds = [userId, widget.therapistId]..sort();
    return "${sortedIds[0]}_${sortedIds[1]}";
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    final user = _auth.currentUser;

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(_conversationId)
        .collection('messages')
        .add({
      'senderId': user!.uid,
      'receiverId': widget.therapistId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  Future<Map<String, dynamic>> _getUserInfo() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('therapist_requests')
        .doc(widget.therapistId)
        .get();
    return userDoc.data() ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
        appBar: AppBar(
        backgroundColor: const Color(0xFFBDDDFC),
        titleSpacing: 0,  // Removes default spacing
        title: FutureBuilder<Map<String, dynamic>>(
          future: _getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            final userInfo = snapshot.data!;
            final userName = userInfo['name'] ?? 'User';
      
            return Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('images/doctor2.jpg'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    userName,
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.videocam),
                  onPressed: () {
                    // Video call functionality
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.call),
                  onPressed: () {
                    // Audio call functionality
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // More options functionality
                  },
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(_conversationId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index];
                    final isSentByCurrentUser =
                        messageData['senderId'] == _auth.currentUser!.uid;

                    return Row(
                      mainAxisAlignment: isSentByCurrentUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          constraints: BoxConstraints(maxWidth: 250),
                          decoration: BoxDecoration(
                            color: isSentByCurrentUser
                                ? const Color.fromARGB(255, 103, 164, 245)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: Radius.circular(
                                  isSentByCurrentUser ? 12 : 0),
                              bottomRight: Radius.circular(
                                  isSentByCurrentUser ? 0 : 12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                messageData['message'],
                                style: TextStyle(
                                  color: isSentByCurrentUser
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                              messageData['timestamp'] != null
                                  ? DateFormat('HH:mm').format(
                                      (messageData['timestamp'] as Timestamp).toDate().toLocal())
                                  : '',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                //color: Colors.grey.shade600,
                                
                              ),
                            ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Container(
            color: const Color(0xFFBDDDFC),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.grey),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.grey),
                    onPressed: () {},
                  ),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Color.fromARGB(255, 103, 164, 245), size: 30),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
