import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final String id;
  final List<String> participants;
  final String lastMessage;

  Conversation({required this.id, required this.participants, required this.lastMessage});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'participants': participants,
      'lastMessage': lastMessage
    };
  }
}

class Message{
  final String senderId;
  final String receiverId;
  final String content;
  final Timestamp timestamp;

  Message({required this.senderId, required this.receiverId, required this.content, required this.timestamp});
  
  Map<String, dynamic> toMap(){
    return {
     'senderId': senderId,
     'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp,
    };
  }
}