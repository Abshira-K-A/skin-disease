


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SkinTypeTestPage extends StatefulWidget {
  const SkinTypeTestPage({super.key});

  @override
  SkinTypeTestPageState createState() => SkinTypeTestPageState();
}

class SkinTypeTestPageState extends State<SkinTypeTestPage> {
  // Using your home page color palette
  final Color _primaryColor = const Color(0xFF8B4513); // Warm saddle brown
  final Color _secondaryColor = const Color(0xFFD2B48C); // Tan
  final Color _accentColor = const Color(0xFFCD853F); // Peru (warm orange-brown)
  final Color _backgroundColor = const Color(0xFFFAF9F6); // Off-white
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF5D4037); // Dark brown

  int _oilyScore = 0;
  int _dryScore = 0;
  int _sensitiveScore = 0;
  int _combinationScore = 0;
  int _normalScore = 0;
  int _currentQuestionIndex = 0;
  String? _skinType;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'How does your skin feel after washing?',
      'options': {
        'Tight & flaky': 'dry',
        'Greasy after a few hours': 'oily',
        'Oily in T-zone, dry elsewhere': 'combination',
        'Feels fine & balanced': 'normal',
        'Gets red & irritated': 'sensitive',
      }
    },
    {
      'question': 'How visible are your pores?',
      'options': {
        'Large & noticeable': 'oily',
        'Small & barely visible': 'dry',
        'Only visible in the T-zone': 'combination',
        'Average-sized, not too visible': 'normal',
        'Often red or inflamed': 'sensitive',
      }
    },
    {
      'question': 'How does your skin react to new skincare products?',
      'options': {
        'Burns or gets red easily': 'sensitive',
        'No reaction, adapts well': 'normal',
        'Breaks out often': 'oily',
        'Becomes flaky or rough': 'dry',
        'Some areas react, some don\'t': 'combination',
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
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          "Skin Type Test",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_currentQuestionIndex < _questions.length)
              _buildQuestionCard()
            else
              _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    final question = _questions[_currentQuestionIndex];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              question['question'],
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ...question['options'].entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _answerQuestion(entry.value),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentColor.withOpacity(0.1),
                      foregroundColor: _textColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: _accentColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                    child: Text(
                      entry.key,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            Text(
              "Question ${_currentQuestionIndex + 1} of ${_questions.length}",
              style: GoogleFonts.poppins(
                color: _textColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    Map<String, Map<String, String>> skinTypeData = {
      "Oily": {
        "description": "Your skin produces excess sebum, often appearing shiny with visible pores.",
        "recommendation": "Use oil-free moisturizers, clay masks, and products with salicylic acid or niacinamide. Avoid heavy creams and look for 'non-comedogenic' labels."
      },
      "Dry": {
        "description": "Your skin lacks natural oils, often feeling tight or showing flakiness.",
        "recommendation": "Use creamy cleansers, hyaluronic acid serums, and rich moisturizers with ceramides. Avoid alcohol-based products and hot water."
      },
      "Combination": {
        "description": "Your skin has both oily and dry areas, typically oily in the T-zone.",
        "recommendation": "Use lightweight moisturizers, balance oily and dry areas separately. Consider using different products for different zones."
      },
      "Normal": {
        "description": "Your skin is well-balanced with few concerns.",
        "recommendation": "Maintain a simple routine with gentle cleansers and light moisturizers. Focus on prevention with antioxidants and SPF."
      },
      "Sensitive": {
        "description": "Your skin reacts easily to products or environmental factors.",
        "recommendation": "Use fragrance-free, hypoallergenic products with soothing ingredients like aloe vera and chamomile. Patch test new products."
      },
    };

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Your Skin Type Is",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: _accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: _accentColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                _skinType ?? "Unknown",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _accentColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              skinTypeData[_skinType]?['description'] ?? "",
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: _textColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              "Recommended Care:",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              skinTypeData[_skinType]?['recommendation'] ?? "",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: _textColor.withOpacity(0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Retake Test",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}