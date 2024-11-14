import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StressLevelAssessmentScreen extends StatefulWidget {
  const StressLevelAssessmentScreen({super.key});

  @override
  _StressLevelAssessmentScreenState createState() => _StressLevelAssessmentScreenState();
}

class _StressLevelAssessmentScreenState extends State<StressLevelAssessmentScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Question> _questions = [];
  final Map<int, int> _answers = {};

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final DocumentSnapshot assessmentDoc = await _firestore.collection('assessments').doc('stressAssessment').get();

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
    int totalScore = _answers.values.fold(0, (sum, score) => sum + score);
    String result = "";

    if (totalScore <= 3) {
      result = "Low Stress";
    } else if (totalScore <= 8) {
      result = "Moderate Stress";
    } else {
      result = "High Stress";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Assessment Result"),
        content: Text("Your stress level is: $result"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );

    setState(() {
      _answers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stress Level Checker")),
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
                              question.text,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ...question.options.map((option) {
                              return RadioListTile<int>(
                                title: Text(option.text),
                                value: option.score,
                                groupValue: _answers[index],
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _calculateScore,
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







// import 'package:flutter/material.dart';

// class StressLevelAssessmentScreen extends StatefulWidget {
//   const StressLevelAssessmentScreen({super.key});

//   @override
//   _StressLevelAssessmentScreenState createState() => _StressLevelAssessmentScreenState();
// }

// class _StressLevelAssessmentScreenState extends State<StressLevelAssessmentScreen> {
//   final List<Question> _questions = [
//     Question(
//       text: "I feel overwhelmed with my daily tasks.",
//       options: [
//         Option(text: "Not at all", score: 0),
//         Option(text: "Sometimes", score: 1),
//         Option(text: "Often", score: 2),
//         Option(text: "Very often", score: 3),
//       ],
//     ),
//     Question(
//       text: "I find it hard to unwind and relax.",
//       options: [
//         Option(text: "Not at all", score: 0),
//         Option(text: "Sometimes", score: 1),
//         Option(text: "Often", score: 2),
//         Option(text: "Very often", score: 3),
//       ],
//     ),
//     Question(
//       text: "I have trouble sleeping due to stress.",
//       options: [
//         Option(text: "Not at all", score: 0),
//         Option(text: "Sometimes", score: 1),
//         Option(text: "Often", score: 2),
//         Option(text: "Very often", score: 3),
//       ],
//     ),
//     Question(
//       text: "I feel irritable or easily frustrated.",
//       options: [
//         Option(text: "Not at all", score: 0),
//         Option(text: "Sometimes", score: 1),
//         Option(text: "Often", score: 2),
//         Option(text: "Very often", score: 3),
//       ],
//     ),
//     Question(
//       text: "I feel like I can't cope with certain situations.",
//       options: [
//         Option(text: "Not at all", score: 0),
//         Option(text: "Sometimes", score: 1),
//         Option(text: "Often", score: 2),
//         Option(text: "Very often", score: 3),
//       ],
//     ),
//   ];

//   Map<int, int> _answers = {};

//   void _calculateScore() {
//     // Check if all questions have been answered
//     if (_answers.length < _questions.length) {
//       // Show alert if not all questions are answered
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("Incomplete Assessment"),
//           content: const Text("Please answer all questions before submitting."),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text("OK"),
//             ),
//           ],
//         ),
//       );
//       return;
//     }

//     int totalScore = _answers.values.fold(0, (sum, score) => sum + score);
//     String result = "";

//     if (totalScore <= 3) {
//       result = "Low";
//     } else if (totalScore <= 8) {
//       result = "Moderate";
//     } else {
//       result = "High";
//     }

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Assessment Result"),
//         content: Text("Your stress level is: $result"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("Close"),
//           ),
//         ],
//       ),
//     );

//     // Clear selected options after showing the result
//     setState(() {
//       _answers.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(title: const Text("Stress Level Checker"),
//       backgroundColor: const Color(0xFFBDDDFC),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: _questions.asMap().entries.map((entry) {
//                 int index = entry.key;
//                 Question question = entry.value;
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         question.text,
//                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       ...question.options.map((option) {
//                         return RadioListTile<int>(
//                           title: Text(option.text),
//                           value: option.score,
//                           groupValue: _answers[index],
//                           activeColor: Colors.blue,
//                           onChanged: (value) {
//                             setState(() {
//                               _answers[index] = value!;
//                             });
//                           },
//                         );
//                       }).toList(),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//           Container(
//             color: const Color(0xFFBDDDFC),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 onPressed: _calculateScore,
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size.fromHeight(50),
//                   backgroundColor: const Color.fromARGB(255, 103, 164, 245),
//                 ),
//                 child: const Text(
//                   "Submit Assessment",
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                   ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Question {
//   final String text;
//   final List<Option> options;

//   Question({required this.text, required this.options});
// }

// class Option {
//   final String text;
//   final int score;

//   Option({required this.text, required this.score});
// }
