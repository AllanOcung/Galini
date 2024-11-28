import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galini/screens/home/question_display_screen.dart';

class AssessmentCategoriesScreen extends StatelessWidget {
  const AssessmentCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Self-Assessment",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 103, 164, 245),
          ),
        ),
        backgroundColor: const Color(0xFFBDDDFC),
         iconTheme: const IconThemeData(
          color: Colors.blue, // Set the back arrow color here
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('assessments').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No assessments available."));
          }

          final assessments = snapshot.data!.docs;
          return ListView.builder(
            itemCount: assessments.length,
            itemBuilder: (context, index) {
              final assessment = assessments[index];
              final assessmentName = assessment.id; // Document ID as the assessment name
              final createdBy = assessment['createdBy'] ?? 'Unknown'; // Fetch createdBy or fallback

              return Card(
                color: Colors.grey[200],
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    assessmentName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    "By: $createdBy",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionDisplayScreen(assessmentName: assessmentName),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
