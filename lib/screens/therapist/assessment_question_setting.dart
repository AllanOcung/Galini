import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TherapistQuestionSettingScreen extends StatefulWidget {
  const TherapistQuestionSettingScreen({super.key});

  @override
  _TherapistQuestionSettingScreenState createState() => _TherapistQuestionSettingScreenState();
}

class _TherapistQuestionSettingScreenState extends State<TherapistQuestionSettingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<QuestionInput> _questions = [];
  final TextEditingController _assessmentNameController = TextEditingController();
  bool _isSaving = false; // For progress indicator

  void _addQuestion() {
    setState(() {
      _questions.add(QuestionInput(
        questionController: TextEditingController(),
        optionControllers: [],
        scoreControllers: [],
      ));
    });
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  void _addOption(QuestionInput questionInput) {
    setState(() {
      questionInput.optionControllers.add(TextEditingController());
      questionInput.scoreControllers.add(TextEditingController());
    });
  }

  void _removeOption(QuestionInput questionInput, int optionIndex) {
    setState(() {
      questionInput.optionControllers.removeAt(optionIndex);
      questionInput.scoreControllers.removeAt(optionIndex);
    });
  }


Future<void> _saveAssessment() async {
  String assessmentName = _assessmentNameController.text.trim();
  if (assessmentName.isEmpty || _questions.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter assessment name and at least one question.")),
    );
    return;
  }

  setState(() {
    _isSaving = true;
  });

  // Get the currently logged-in user
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User not logged in. Please log in and try again.")),
    );
    setState(() {
      _isSaving = false;
    });
    return;
  }

  // Fetch user name or email
  String userName = currentUser.displayName ?? currentUser.email ?? "Unknown User";

  List<Map<String, dynamic>> questionsData = _questions.map((q) {
    return {
      'questionText': q.questionController.text.trim(),
      'options': q.optionControllers.map((controller) => controller.text.trim()).toList(),
      'scores': q.scoreControllers.map((controller) => int.tryParse(controller.text) ?? 0).toList(),
    };
  }).toList();

  await _firestore.collection('assessments').doc(assessmentName).set({
    'questions': questionsData,
    'createdBy': userName, // Add the logged-in user's name
    'createdAt': FieldValue.serverTimestamp(), // Add a timestamp
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Assessment saved successfully!")),
  );

  _clearInputs();
  setState(() {
    _isSaving = false;
  });
}


  void _clearInputs() {
    _assessmentNameController.clear();
    for (var questionInput in _questions) {
      questionInput.questionController.clear();
      for (var optionController in questionInput.optionControllers) {
        optionController.clear();
      }
      for (var scoreController in questionInput.scoreControllers) {
        scoreController.clear();
      }
    }
    setState(() {
      _questions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Assessment Questions",
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: _questions.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      TextField(
                        controller: _assessmentNameController,
                        decoration: const InputDecoration(labelText: "Assessment Title"),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                } else {
                  return _buildQuestionInput(index - 1, _questions[index - 1]);
                }
              },
            ),
          ),
          if (_isSaving)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuestion,
        backgroundColor: const Color(0xFF7D99AA),
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isSaving ? null : _saveAssessment,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7D99AA),
            foregroundColor: Colors.white,
          ),
          child: const Text("Save Assessment"),
        ),
      ),
    );
  }

  Widget _buildQuestionInput(int index, QuestionInput questionInput) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Question ${index + 1}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black)),
                IconButton(
                  onPressed: () => _deleteQuestion(index),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            TextField(
              controller: questionInput.questionController,
              decoration: const InputDecoration(labelText: "Question Text"),
            ),
            const SizedBox(height: 8),
            ...questionInput.optionControllers.asMap().entries.map((entry) {
              int optionIndex = entry.key;
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: questionInput.optionControllers[optionIndex],
                      decoration: InputDecoration(labelText: "Option ${optionIndex + 1}"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 60,
                    child: TextField(
                      controller: questionInput.scoreControllers[optionIndex],
                      decoration: const InputDecoration(labelText: "Score"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _removeOption(questionInput, optionIndex),
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                  ),
                ],
              );
            }).toList(),
            TextButton.icon(
              onPressed: () => _addOption(questionInput),
              icon: const Icon(Icons.add, color: Colors.black54,),
              label: const Text("Add Option", style: TextStyle(color: Colors.black54),),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionInput {
  final TextEditingController questionController;
  final List<TextEditingController> optionControllers;
  final List<TextEditingController> scoreControllers;

  QuestionInput({
    required this.questionController,
    required this.optionControllers,
    required this.scoreControllers,
  });
}
