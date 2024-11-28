import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddNewsScreen extends StatefulWidget {
  const AddNewsScreen({Key? key}) : super(key: key);

  @override
  _AddNewsScreenState createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  String? authorName;

  @override
  void initState() {
    super.initState();
    _fetchAuthorName();
  }

  Future<void> _fetchAuthorName() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final uid = currentUser.uid;
        final therapistDoc = await FirebaseFirestore.instance
            .collection('therapist_requests')
            .doc(uid)
            .get();

        if (therapistDoc.exists) {
          setState(() {
            authorName = therapistDoc.data()?['name'] ?? 'Unknown Author';
          });
        } else {
          setState(() {
            authorName = 'Unknown Author';
          });
        }
      }
    } catch (e) {
      print('Error fetching therapist name: $e');
      setState(() {
        authorName = 'Unknown Author';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF7D99AA),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the back arrow color here
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final currentUser = FirebaseAuth.instance.currentUser?.uid;
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('news_feed').add({
                    'title': titleController.text,
                    'content': contentController.text,
                    'author': authorName ?? 'Unknown Author',
                    'authorId': currentUser,
                    'created_at': Timestamp.now(),
                    'likes': 0,
                    "liked_users": [],  // List of UIDs
                    "comments": [],
                    "commented_users": []
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Title and content are required!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7D99AA), // Button color
                foregroundColor: Colors.white, // Text color
              ),
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
