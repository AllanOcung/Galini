import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String chatId;

  @override
  void initState() {
    super.initState();
    // Initialize chat ID based on the combination of user IDs to ensure unique chat
    chatId = widget.currentUserId.compareTo(widget.therapistId) > 0
        ? "${widget.currentUserId}_${widget.therapistId}"
        : "${widget.therapistId}_${widget.currentUserId}";
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': widget.currentUserId,
      'receiverId': widget.therapistId,
      'text': _messageController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Clear the message input
    _messageController.clear();
  }

  Widget _buildMessage(DocumentSnapshot message) {
    bool isMe = message['senderId'] == widget.currentUserId;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message['text'],
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with Therapist"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) =>
                      _buildMessage(snapshot.data!.docs[index]),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type your message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}













// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:galini/models/conversation.dart';
// import 'package:galini/widgets/chat_bubble.dart';

// class ChatScreen extends StatefulWidget {
//   final String currentUserId;
//   final String therapistId;

//   const ChatScreen({
//     Key? key,
//     required this.currentUserId,
//     required this.therapistId,
//   }) : super(key: key);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();

//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }

//   // Sends a message and updates the conversation's last message and timestamp
//   Future<void> _sendMessage(String content) async {
//     final senderId = widget.currentUserId;
//     final receiverId = widget.therapistId;

//     Message message = Message(
//       senderId: senderId,
//       receiverId: receiverId,
//       content: content,
//       timestamp: Timestamp.now(),
//     );

//     // Send message to Firestore
//     await FirebaseFirestore.instance
//         .collection('conversations')
//         .doc(widget.conversationId)
//         .collection('messages')
//         .add(message.toMap());

//     // Update last message and timestamp in conversation document
//     await FirebaseFirestore.instance
//         .collection('conversations')
//         .doc(widget.conversationId)
//         .update({
//           'lastMessage': content,
//           'timestamp': Timestamp.now(),
//         });
//   }

//   // Message input widget
//   Widget _buildMessageInput() {
//     return Container(
//       height: 65,
//       decoration: BoxDecoration(color: Colors.white, boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.5),
//           spreadRadius: 2,
//           blurRadius: 10,
//           offset: const Offset(0, 3),
//         ),
//       ]),
//       child: Row(
//         children: [
//           const Padding(
//             padding: EdgeInsets.only(left: 8),
//             child: Icon(
//               Icons.add,
//               size: 30,
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.only(left: 5),
//             child: Icon(
//               Icons.emoji_emotions_outlined,
//               size: 30,
//               color: Color.fromARGB(255, 51, 172, 92),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: TextFormField(
//                 controller: _messageController,
//                 decoration: const InputDecoration(
//                   hintText: "Type something",
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(
//               Icons.send,
//               color: Color.fromARGB(255, 51, 172, 92),
//             ),
//             onPressed: () {
//               if (_messageController.text.trim().isNotEmpty) {
//                 _sendMessage(_messageController.text.trim());
//                 _messageController.clear();
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(70.0),
//         child: AppBar(
//           backgroundColor: Colors.white,
//           leadingWidth: 30,
//           title: StreamBuilder<DocumentSnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('therapist_requests')
//                 .doc(widget.therapistId)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const CircularProgressIndicator();
//               }

//               if (snapshot.hasError || !snapshot.hasData) {
//                 return const Text("Therapist Not Found");
//               }

//               var therapistData = snapshot.data!;
//               String therapistName = therapistData['name'];

//               return Row(
//                 children: [
//                   const CircleAvatar(
//                     radius: 25,
//                     backgroundImage: AssetImage("images/doctor1.jpg"),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10),
//                     child: Text(
//                       therapistName,
//                       style: const TextStyle(
//                         color: Color.fromARGB(255, 51, 172, 92),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//           actions: const [
//             Padding(
//               padding: EdgeInsets.only(right: 20),
//               child: Icon(
//                 Icons.call,
//                 color: Color.fromARGB(255, 51, 172, 92),
//                 size: 26,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(right: 15),
//               child: Icon(
//                 Icons.video_call,
//                 color: Color.fromARGB(255, 51, 172, 92),
//                 size: 30,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(right: 10),
//               child: Icon(
//                 Icons.more_vert,
//                 color: Color.fromARGB(255, 51, 172, 92),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('conversations')
//             .doc(widget.conversationId)
//             .collection('messages')
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No messages yet."));
//           }

//           // Build the list of messages
//           return ListView.builder(
//             reverse: true,
//             padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 80),
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               var data = snapshot.data!.docs[index];
//               bool isSender = data['senderId'] == widget.currentUserId;

//               return ChatBubble(
//                 content: data['content'],
//                 isSender: isSender,
//               );
//             },
//           );
//         },
//       ),
//       bottomSheet: _buildMessageInput(),
//     );
//   }
// }
