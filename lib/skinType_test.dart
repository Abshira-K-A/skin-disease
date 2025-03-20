
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SkinTypeTestPage extends StatefulWidget {
  const SkinTypeTestPage({super.key});

  @override
  SkinTypeTestPageState createState() => SkinTypeTestPageState();
}

class SkinTypeTestPageState extends State<SkinTypeTestPage> {
  int _oilyScore = 0;
  int _dryScore = 0;
  int _sensitiveScore = 0;
  int _combinationScore = 0;
  int _normalScore = 0;
  int _currentQuestionIndex = 0;
  String? _skinType;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'How does your skin feel **after washing**?',
      'options': {
        'Tight & flaky': 'dry',
        'Greasy after a few hours': 'oily',
        'Oily in T-zone, dry elsewhere': 'combination',
        'Feels fine & balanced': 'normal',
        'Gets red & irritated': 'sensitive',
      }
    },
    {
      'question': 'How **visible are your pores**?',
      'options': {
        'Large & noticeable': 'oily',
        'Small & barely visible': 'dry',
        'Only visible in the T-zone': 'combination',
        'Average-sized, not too visible': 'normal',
        'Often red or inflamed': 'sensitive',
      }
    },
    {
      'question': 'How does your skin **react to new skincare products**?',
      'options': {
        'Burns or gets red easily': 'sensitive',
        'No reaction, adapts well': 'normal',
        'Breaks out often': 'oily',
        'Becomes flaky or rough': 'dry',
        'Some areas react, some don’t': 'combination',
      }
    },
    {
      'question': 'At the end of the day, your skin feels...',
      'options': {
        'Extremely dry & rough': 'dry',
        'Very oily & shiny': 'oily',
        'Oily in some places, dry in others': 'combination',
        'Soft and balanced': 'normal',
        'Sensitive or itchy': 'sensitive',
      }
    },
    {
      'question': 'How does your skin react to cold weather?',
      'options': {
        'Gets very dry & flaky': 'dry',
        'Remains oily & shiny': 'oily',
        'Some areas get dry, others oily': 'combination',
        'Feels normal & balanced': 'normal',
        'Becomes red & irritated': 'sensitive',
      }
    },
  ];

  void _answerQuestion(String skinType) {
    setState(() {
      if (skinType == 'oily') _oilyScore++;
      if (skinType == 'dry') _dryScore++;
      if (skinType == 'sensitive') _sensitiveScore++;
      if (skinType == 'combination') _combinationScore++;
      if (skinType == 'normal') _normalScore++;

      _currentQuestionIndex++;
    });

    if (_currentQuestionIndex >= _questions.length) {
      _determineSkinType();
    }
  }

  void _determineSkinType() async {
    Map<String, int> scores = {
      "Oily": _oilyScore,
      "Dry": _dryScore,
      "Sensitive": _sensitiveScore,
      "Combination": _combinationScore,
      "Normal": _normalScore,
    };

    String skinType = scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    setState(() {
      _skinType = skinType;
    });

    // Save to Firebase
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'skinType': skinType,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Skin Type Test"),
        backgroundColor: Colors.purple.shade400,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentQuestionIndex < _questions.length)
                  _buildQuestionCard()
                else
                  _buildResultCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    final question = _questions[_currentQuestionIndex];

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              question['question'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...question['options'].entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade300,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () => _answerQuestion(entry.value),
                  child: Text(entry.key, style: const TextStyle(fontSize: 16)),
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            Text("Question ${_currentQuestionIndex + 1} of ${_questions.length}"),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    Map<String, String> recommendations = {
      "Oily": "Use oil-free moisturizers, clay masks, and avoid heavy creams.",
      "Dry": "Use hydrating cleansers, rich moisturizers, and avoid alcohol-based products.",
      "Combination": "Use lightweight moisturizers, balance oily and dry areas separately.",
      "Normal": "Maintain a simple skincare routine with gentle products.",
      "Sensitive": "Use fragrance-free, hypoallergenic products and avoid harsh chemicals.",
    };

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Your Skin Type:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _skinType ?? "Analyzing...",
              style: TextStyle(fontSize: 24, color: Colors.purple.shade700, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              recommendations[_skinType] ?? "No data",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade400,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                setState(() {
                  _currentQuestionIndex = 0;
                  _oilyScore = 0;
                  _dryScore = 0;
                  _sensitiveScore = 0;
                  _combinationScore = 0;
                  _normalScore = 0;
                  _skinType = null;
                });
              },
              child: const Text("Retake Test"),
            ),
          ],
        ),
      ),
    );
  }
}
