import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String patientId;

  const ChatScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _conversationId {
    final userId = _auth.currentUser!.uid;
    final sortedIds = [userId, widget.patientId]..sort();
    return "${sortedIds[0]}_${sortedIds[1]}";
  }

  Future<Map<String, dynamic>> _getUserInfo() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.patientId)
        .get();
    return userDoc.data() ?? {};
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
      'receiverId': widget.patientId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7D99AA),
        titleSpacing: 0,  // Removes default spacing
        title: FutureBuilder<Map<String, dynamic>>(
          future: _getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            final userInfo = snapshot.data!;
            final userName = userInfo['fullName'] ?? 'User';
      
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
          // Messages List
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

                    return Align(
                      alignment: isSentByCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSentByCurrentUser
                              ? const Color.fromARGB(255, 180, 205, 221) // Light green for sent messages
                              : Colors.white, // White for received messages
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isSentByCurrentUser
                                ? const Radius.circular(12)
                                : Radius.zero,
                            bottomRight: isSentByCurrentUser
                                ? Radius.zero
                                : const Radius.circular(12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              messageData['message'],
                              style: TextStyle(
                                color: isSentByCurrentUser
                                    ? Colors.black
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              messageData['timestamp'] != null
                                  ? DateFormat('HH:mm').format(
                                      (messageData['timestamp'] as Timestamp)
                                          .toDate()
                                          .toLocal())
                                  : '',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Message Input Field
          Padding(
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
                    style: const TextStyle(
                      color: Colors.black, // Change the color of the message being typed
                    ),
                    cursorColor: const Color(0xFF7D99AA), // Change the color of the cursor
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                          
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
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
                  icon: const Icon(Icons.send, color: Color(0xFF7D99AA), size: 30),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFEDEDED),
    );
  }
}
