import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galini/screens/therapist/edit_assessment_screen.dart';

class TherapistAssessmentManagementScreen extends StatelessWidget {
  const TherapistAssessmentManagementScreen({super.key});

  Future<void> _deleteAssessment(String assessmentId) async {
    await FirebaseFirestore.instance.collection('assessments').doc(assessmentId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Assessments")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('assessments').snapshots(),
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
              String assessmentId = assessments[index].id;
              return ListTile(
                title: Text(assessmentId),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAssessmentScreen(assessmentId: assessmentId),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _deleteAssessment(assessmentId);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
