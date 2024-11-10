import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(child: Text("Inbox")),
        backgroundColor: const Color(0xFF7D99AA),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: 10, // Example number of messages
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text("P${index + 1}")),
            title: Text("Patient ${index + 1}"),
            subtitle: const Text("Last message preview..."),
            onTap: () {
              // Open chat with patient
            },
          );
        },
      ),
    );
  }
}
