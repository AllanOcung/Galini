import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditAssessmentScreen extends StatefulWidget {
  final String assessmentId;

  const EditAssessmentScreen({required this.assessmentId, super.key});

  @override
  _EditAssessmentScreenState createState() => _EditAssessmentScreenState();
}

class _EditAssessmentScreenState extends State<EditAssessmentScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    _loadAssessment();
  }

  Future<void> _loadAssessment() async {
    DocumentSnapshot doc = await _firestore.collection('assessments').doc(widget.assessmentId).get();
    if (doc.exists) {
      List<Question> loadedQuestions = [];
      List<dynamic> questionsData = doc['questions'];

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

  Future<void> _updateAssessment() async {
    List<Map<String, dynamic>> updatedQuestions = _questions.map((question) {
      return {
        'questionText': question.text,
        'options': question.options.map((option) => option.text).toList(),
        'scores': question.options.map((option) => option.score).toList(),
      };
    }).toList();

    await _firestore.collection('assessments').doc(widget.assessmentId).update({
      'questions': updatedQuestions,
    });

    Navigator.pop(context);
  }

  void _addNewQuestion() {
    setState(() {
      _questions.add(Question(text: '', options: [Option(text: '', score: 0)]));
    });
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  void _addNewOption(int questionIndex) {
    setState(() {
      _questions[questionIndex].options.add(Option(text: '', score: 0));
    });
  }

  void _deleteOption(int questionIndex, int optionIndex) {
    setState(() {
      _questions[questionIndex].options.removeAt(optionIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Assessment")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._questions.asMap().entries.map((entry) {
            int questionIndex = entry.key;
            Question question = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: TextEditingController(text: question.text),
                  decoration: const InputDecoration(labelText: 'Question Text'),
                  onChanged: (value) => question.text = value,
                ),
                ...question.options.asMap().entries.map((optionEntry) {
                  int optionIndex = optionEntry.key;
                  Option option = optionEntry.value;
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: option.text),
                          decoration: const InputDecoration(labelText: 'Option Text'),
                          onChanged: (value) => option.text = value,
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: TextField(
                          controller: TextEditingController(text: option.score.toString()),
                          decoration: const InputDecoration(labelText: 'Score'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => option.score = int.tryParse(value) ?? 0,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteOption(questionIndex, optionIndex),
                      ),
                    ],
                  );
                }).toList(),
                TextButton(
                  onPressed: () => _addNewOption(questionIndex),
                  child: const Text("Add Option"),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: () => _deleteQuestion(questionIndex),
                ),
                const Divider(),
              ],
            );
          }).toList(),
          ElevatedButton(
            onPressed: _addNewQuestion,
            child: const Text("Add New Question"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _updateAssessment,
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }
}

class Question {
  String text;
  List<Option> options;

  Question({required this.text, required this.options});
}

class Option {
  String text;
  int score;

  Option({required this.text, required this.score});
}
