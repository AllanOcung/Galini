import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionDisplayScreen extends StatefulWidget {
  final String assessmentName;
  const QuestionDisplayScreen({required this.assessmentName, super.key});

  @override
  _QuestionDisplayScreenState createState() => _QuestionDisplayScreenState();
}

class _QuestionDisplayScreenState extends State<QuestionDisplayScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Question> _questions = [];
  final Map<int, int?> _answers = {}; // Changed value type to int? for nullable values

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final DocumentSnapshot assessmentDoc = await _firestore
        .collection('assessments')
        .doc(widget.assessmentName)
        .get();

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

  void _calculateScore() {
    // Check if all questions are answered
    if (_answers.values.contains(null)) {
      // If there's an unanswered question, show a message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Warning"),
          content: const Text("Please answer all questions before submitting."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return; // Don't proceed with the calculation
    }

    int totalScore = _answers.values
        .whereType<int>()
        .fold(0, (sum, score) => sum + score);
    String result = "";
    String advice = "";

    // Refined mental health status levels
    if (totalScore <= 3) {
      result = "Very Low Mental Health Concerns";
      advice = "You're in a great mental state. Keep maintaining your balance!";
    } else if (totalScore <= 6) {
      result = "Low Mental Health Concerns";
      advice = "You seem to be managing well. Keep up the good work!";
    } else if (totalScore <= 9) {
      result = "Moderate Mental Health Concerns";
      advice = "It's okay to have some concerns. Consider practicing mindfulness or talking to someone.";
    } else if (totalScore <= 12) {
      result = "High Mental Health Concerns";
      advice = "You may be experiencing high concerns. It's helpful to seek support or engage in stress-relief activities.";
    } else {
      result = "Very High Mental Health Concerns";
      advice = "You're experiencing high concerns. It's important to seek professional support and practice self-care.";
    }

    // Displaying the result in the dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Mental Health Status"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Mental Health Status:", style: TextStyle(fontWeight: FontWeight.bold),),
              Text("*$result"),
              const SizedBox(height: 16),
              const Text("Advice:", style: TextStyle(fontWeight: FontWeight.bold),),
              Text("*$advice"),
              const SizedBox(height: 8),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close", style: TextStyle(color: Colors.blue),),
          ),
        ],
      ),
    );

    // Clear the answers after showing the result
    setState(() {
      _answers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          widget.assessmentName,
          style: const TextStyle(
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
      body: _questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: _questions.asMap().entries.map((entry) {
                      int index = entry.key;
                      Question question = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${index + 1}. ${question.text}", // Numbered question
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...question.options.map((option) {
                              return RadioListTile<int?>(
                                title: Text(option.text),
                                value: option.score,
                                groupValue: _answers[index],
                                activeColor: Colors.black,
                                onChanged: (value) {
                                  setState(() {
                                    // Deselect option if already selected
                                    if (_answers[index] == value) {
                                      _answers[index] = null;
                                    } else {
                                      _answers[index] = value;
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  color: const Color(0xFFBDDDFC),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _answers.length == _questions.length // Enable the button only when all questions are answered
                          ? _calculateScore
                          : null, // Disable the button if not all questions are answered
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: const Color.fromARGB(255, 103, 164, 245),
                      ),
                      child: const Text(
                        "Submit Assessment",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
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
