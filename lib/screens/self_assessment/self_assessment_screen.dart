import 'package:flutter/material.dart';
import 'package:galini/screens/self_assessment/anxiety_assessment_screen.dart';
import 'package:galini/screens/self_assessment/depression_assessment_screen.dart';
import 'package:galini/screens/self_assessment/stress_level_assessment.dart';

class SelfAssessmentScreen extends StatelessWidget {
  const SelfAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Self-Assessment Tools"),
        backgroundColor: const Color(0xFFBDDDFC),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AssessmentTile(
            title: "Anxiety Assessment",
            description: "Evaluate your anxiety levels with this quick test.",
            onTap: () {
              // Navigate to Anxiety Assessment Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnxietyAssessmentScreen()),
              );
            },
          ),
          AssessmentTile(
            title: "Depression Self-Test",
            description: "Check for symptoms of depression.",
            onTap: () {
              // Navigate to Depression Self-Test Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DepressionAssessmentScreen()),
              );
            },
          ),
          AssessmentTile(
            title: "Stress Level Checker",
            description: "Measure how stressed you feel on a daily basis.",
            onTap: () {
              // Navigate to Stress Level Checker Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StressLevelAssessmentScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AssessmentTile extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const AssessmentTile({
    required this.title,
    required this.description,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(description),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}


