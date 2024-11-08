import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galini/widgets/navbar_roots.dart';

class FirstTimeQuestionnaireScreen extends StatefulWidget {
  final String userId; // Pass user ID

  const FirstTimeQuestionnaireScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _FirstTimeQuestionnaireScreenState createState() => _FirstTimeQuestionnaireScreenState();
}

class _FirstTimeQuestionnaireScreenState extends State<FirstTimeQuestionnaireScreen> {
  // List of options
  final List<String> options = [
    'Anxiety', 'Depression', 'Relationship Issues', 
    'ADHD', 'Panic Attacks', 'Phobia', 
    'Abuse', 'Mental Breakdown'
  ];
  
  // Track selected options
  final Set<String> selectedOptions = {};

  // Toggle option selection
  void toggleSelection(String option) {
    setState(() {
      selectedOptions.contains(option)
          ? selectedOptions.remove(option)
          : selectedOptions.add(option);
    });
  }

  // Save the selected options to Firestore
  Future<void> saveSelections() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
            'helpReasons': selectedOptions.toList(),
            'hasCompletedIntro': true,
          });
      // Navigate to the next screen or home screen
     Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NavBarRoots(),
          ),
        );
    } catch (e) {
      print("Error saving selections: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E3B55),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E3B55),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "What led you to seek help today?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "Select all that apply",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options.map((option) {
                final isSelected = selectedOptions.contains(option);
                return ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (_) => toggleSelection(option),
                  backgroundColor: Colors.grey[600],
                  selectedColor: Colors.orangeAccent,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: selectedOptions.isNotEmpty ? saveSelections : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF67A4F5),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
