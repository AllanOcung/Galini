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

  void _addQuestion() {
    setState(() {
      _questions.add(QuestionInput(
        questionController: TextEditingController(),
        optionControllers: List.generate(4, (_) => TextEditingController()),
        scoreControllers: List.generate(4, (_) => TextEditingController()),
      ));
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

    List<Map<String, dynamic>> questionsData = _questions.map((q) {
      return {
        'questionText': q.questionController.text.trim(),
        'options': q.optionControllers.map((controller) => controller.text.trim()).toList(),
        'scores': q.scoreControllers.map((controller) => int.tryParse(controller.text) ?? 0).toList(),
      };
    }).toList();

    await _firestore.collection('assessments').doc(assessmentName).set({
      'questions': questionsData,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Assessment saved successfully!")),
    );

    _clearInputs();
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
      appBar: AppBar(
        title: const Text("Assessment Questions"),
        backgroundColor: const Color(0xFF7D99AA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _assessmentNameController,
              decoration: const InputDecoration(labelText: "Assessment Name"),
            ),
            const SizedBox(height: 16),
            ..._questions.asMap().entries.map((entry) {
              int index = entry.key;
              QuestionInput questionInput = entry.value;
              return _buildQuestionInput(index, questionInput);
            }).toList(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _addQuestion,
                  child: const Text("Add Question"),
                ),
                ElevatedButton(
                  onPressed: _saveAssessment,
                  child: const Text("Save Assessment"),
                ),
              ],
            ),
          ],
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
            Text("Question ${index + 1}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: questionInput.questionController,
              decoration: const InputDecoration(labelText: "Question Text"),
            ),
            const SizedBox(height: 8),
            ...List.generate(4, (optionIndex) {
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
                ],
              );
            }),
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
