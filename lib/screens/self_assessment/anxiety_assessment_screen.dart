import 'package:flutter/material.dart';

class AnxietyAssessmentScreen extends StatefulWidget {
  const AnxietyAssessmentScreen({super.key});

  @override
  _AnxietyAssessmentScreenState createState() => _AnxietyAssessmentScreenState();
}

class _AnxietyAssessmentScreenState extends State<AnxietyAssessmentScreen> {
  final List<Question> _questions = [
    Question(
      text: "I feel anxious or nervous frequently.",
      options: [
        Option(text: "Not at all", score: 0),
        Option(text: "Several days", score: 1),
        Option(text: "More than half the days", score: 2),
        Option(text: "Nearly every day", score: 3),
      ],
    ),
    Question(
      text: "I have trouble relaxing.",
      options: [
        Option(text: "Not at all", score: 0),
        Option(text: "Several days", score: 1),
        Option(text: "More than half the days", score: 2),
        Option(text: "Nearly every day", score: 3),
      ],
    ),
    Question(
      text: "I get easily annoyed or irritable.",
      options: [
        Option(text: "Not at all", score: 0),
        Option(text: "Several days", score: 1),
        Option(text: "More than half the days", score: 2),
        Option(text: "Nearly every day", score: 3),
      ],
    ),
    Question(
      text: "I feel like something bad might happen.",
      options: [
        Option(text: "Not at all", score: 0),
        Option(text: "Several days", score: 1),
        Option(text: "More than half the days", score: 2),
        Option(text: "Nearly every day", score: 3),
      ],
    ),
    Question(
      text: "I have difficulty sleeping due to worry or stress.",
      options: [
        Option(text: "Not at all", score: 0),
        Option(text: "Several days", score: 1),
        Option(text: "More than half the days", score: 2),
        Option(text: "Nearly every day", score: 3),
      ],
    ),
  ];

  Map<int, int> _answers = {};

  void _calculateScore() {
    // Check if all questions have been answered
    if (_answers.length < _questions.length) {
      // Show alert if not all questions are answered
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Incomplete Assessment"),
          content: const Text("Please answer all questions before submitting."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Calculate score if all questions are answered
    int totalScore = _answers.values.fold(0, (sum, score) => sum + score);
    String result = "";

    if (totalScore <= 3) {
      result = "Low Anxiety";
    } else if (totalScore <= 8) {
      result = "Moderate Anxiety";
    } else {
      result = "High Anxiety";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Assessment Result"),
        content: Text("Your anxiety level is: $result"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );

    // Clear selected options after showing the result
    setState(() {
      _answers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Anxiety Assessment"),
        backgroundColor: const Color(0xFFBDDDFC),
        ),
      body: Column(
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
                        question.text,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...question.options.map((option) {
                        return RadioListTile<int>(
                          title: Text(option.text),
                          value: option.score,
                          groupValue: _answers[index],
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(() {
                              _answers[index] = value!;
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
                onPressed: _calculateScore,                
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
