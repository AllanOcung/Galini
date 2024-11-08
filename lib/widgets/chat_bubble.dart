import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String content;
  final bool isSender;

  const ChatBubble({required this.content, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isSender ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          content,
          style: TextStyle(color: isSender ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
