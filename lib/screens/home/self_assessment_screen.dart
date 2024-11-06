import 'package:flutter/material.dart';

class SelfAssessmentScreen extends StatelessWidget {
  const SelfAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Self-Assessment Tools"),
        backgroundColor: const Color.fromARGB(255, 103, 164, 245),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _assessmentTile(
            title: "Anxiety Assessment",
            description: "Evaluate your anxiety levels with this quick test.",
          ),
          _assessmentTile(
            title: "Depression Self-Test",
            description: "Check for symptoms of depression.",
          ),
          _assessmentTile(
            title: "Stress Level Checker",
            description: "Measure how stressed you feel on a daily basis.",
          ),
        ],
      ),
    );
  }

  Widget _assessmentTile({required String title, required String description}) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(description),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Navigate to assessment quiz
      },
    );
  }
}
