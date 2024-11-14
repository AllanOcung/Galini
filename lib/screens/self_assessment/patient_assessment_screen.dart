import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientAssessmentScreen extends StatefulWidget {
  final String assessmentId;

  const PatientAssessmentScreen({super.key, required this.assessmentId});

  @override
  _PatientAssessmentScreenState createState() => _PatientAssessmentScreenState();
}

class _PatientAssessmentScreenState extends State<PatientAssessmentScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Question> _questions = [];
  final Map<int, int> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _fetchAssessment();
  }

  Future<void> _fetchAssessment() async {
    final DocumentSnapshot assessmentDoc =
        await _firestore.collection('assessments').doc(widget.assessmentId).get();

    if (assessmentDoc.exists) {
      List<Question> loadedQuestions = [];
      List<dynamic> questionsData = assessmentDoc['questions'];

      for (var questionData in questionsData) {
        List<Option> options = [];
        for (int i = 0; i < questionData['options'].length; i++) {
          options.add(Option(
            text: questionData['options'][i],
            score: questionData['scores'][i],
          ));
        }
        loadedQuestions.add(Question(
          text: questionData['questionText'],
          options: options,
        ));
      }

      setState(() {
        _questions = loadedQuestions;
      });
    }
  }

  void _submitAssessment() {
    int totalScore = _selectedAnswers.values.fold(0, (sum, score) => sum + score);
    String result = "";

    if (totalScore <= 3) {
      result = "Low level of concern.";
    } else if (totalScore <= 8) {
      result = "Moderate level of concern.";
    } else {
      result = "High level of concern.";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Assessment Result"),
        content: Text("Your assessment result: $result"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );

    setState(() {
      _selectedAnswers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Assessment"),
      ),
      body: _questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      Question question = _questions[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.text,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ...question.options.asMap().entries.map((entry) {
                              int optionIndex = entry.key;
                              Option option = entry.value;
                              return RadioListTile<int>(
                                title: Text(option.text),
                                value: option.score,
                                groupValue: _selectedAnswers[index],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAnswers[index] = value!;
                                  });
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _selectedAnswers.length == _questions.length ? _submitAssessment : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text("Submit Assessment"),
                  ),
                ),
              ],
            ),
    );
  }
}

class Question {
  final String text;
  final List<Option> options;

  Question({required this.text, required this.options});
}

class Option {
  final String text;
  final int score;

  Option({required this.text, required this.score});
}
