import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galini/screens/therapist/question_display_screen.dart';

class AssessmentCategoriesScreen extends StatelessWidget {
  const AssessmentCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text("Self-Assessment Tools"),
      backgroundColor: const Color(0xFFBDDDFC),
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
              String assessmentName = assessments[index].id;
              return ListTile(
                title: Text(assessmentName),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionDisplayScreen(assessmentName: assessmentName),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
