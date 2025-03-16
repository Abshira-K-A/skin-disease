
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
  int _currentQuestionIndex = 0;

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
  ];

  void _answerQuestion(String skinType) {
    setState(() {
      if (skinType == 'oily') _oilyScore++;
      if (skinType == 'dry') _dryScore++;
      if (skinType == 'sensitive') _sensitiveScore++;
      if (skinType == 'combination') _combinationScore++;

      _currentQuestionIndex++;
    });

    if (_currentQuestionIndex >= _questions.length) {
      _determineSkinType();
    }
  }

  void _determineSkinType() async {
    String skinType;
    if (_oilyScore > _dryScore && _oilyScore > _sensitiveScore && _oilyScore > _combinationScore) {
      skinType = "Oily";
    } else if (_dryScore > _oilyScore && _dryScore > _sensitiveScore && _dryScore > _combinationScore) {
      skinType = "Dry";
    } else if (_sensitiveScore > _oilyScore && _sensitiveScore > _dryScore && _sensitiveScore > _combinationScore) {
      skinType = "Sensitive";
    } else if (_combinationScore > _oilyScore && _combinationScore > _dryScore && _combinationScore > _sensitiveScore) {
      skinType = "Combination";
    } else {
      skinType = "Normal";
    }

    // Save the skin type in Firestore
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'skinType': skinType,
      });
    }

    // Navigate to result page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SkinTypeResultPage(skinType: skinType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestionIndex >= _questions.length) {
      return const Center(child: CircularProgressIndicator());
    }

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Skin Type Test", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple.shade400,
        centerTitle: true,
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
                Card(
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () => _answerQuestion(entry.value),
                              child: Text(entry.key, style: const TextStyle(fontSize: 16)),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Question ${_currentQuestionIndex + 1} of ${_questions.length}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SkinTypeResultPage extends StatelessWidget {
  final String skinType;

  const SkinTypeResultPage({super.key, required this.skinType});

  @override
  Widget build(BuildContext context) {
    Map<String, String> recommendations = {
      "Oily": "Use oil-free moisturizers, clay masks, and avoid heavy creams.",
      "Dry": "Use hydrating cleansers, rich moisturizers, and avoid alcohol-based products.",
      "Combination": "Use lightweight moisturizers, balance oily and dry areas separately.",
      "Normal": "Maintain a simple skincare routine with gentle products.",
      "Sensitive": "Use fragrance-free, hypoallergenic products and avoid harsh chemicals.",
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Skin Type Result"),
        backgroundColor: Colors.purple.shade400,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your Skin Type is:", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(skinType, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple.shade700)),
            const SizedBox(height: 20),
            Text(recommendations[skinType] ?? "No data", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}

