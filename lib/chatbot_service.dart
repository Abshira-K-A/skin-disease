


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'firebase_service.dart';

class ChatbotService {
  final FirebaseService _firebaseService = FirebaseService();

  // 🔹 Secure API key (Move to environment variable for security)
  final String apiKey = "AIzaSyDNXiytm8sLQLPi590SYYlaei5pFVL6s7c";
  static const String apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";

  /// ✅ **Chatbot Logic for Direct Responses**
  Future<String> getChatbotResponse(String userMessage, String userId) async {
    userMessage = userMessage.toLowerCase().trim();
    print("User message received: $userMessage");
   
    // 🔹 **Recognize Skincare Questions using RegExp**
    Map<RegExp, String> skincareResponses = {
      RegExp(r"\bacne\b|\bpimples\b"): "To reduce acne, cleanse your face twice a day, use oil-free products, and apply benzoyl peroxide or salicylic acid treatments.",
      RegExp(r"\bdry skin\b|\bmoisturizer\b"): "A good moisturizer for dry skin contains hyaluronic acid, ceramides, and glycerin. Try CeraVe or Neutrogena Hydro Boost.",
      RegExp(r"\bsunscreen\b|\bspf\b"): "Use a broad-spectrum SPF 30+ sunscreen. Some great options are La Roche-Posay Anthelios and Neutrogena Ultra Sheer.",
      RegExp(r"\boily skin\b"): "Oily skin is caused by overactive sebaceous glands. It can be influenced by genetics, hormones, and harsh skincare products.",
      RegExp(r"\bdark spots\b|\bpigmentation\b"): "Use vitamin C serums, niacinamide, and sunscreen daily. Treatments like glycolic acid and retinol help fade dark spots.",
      RegExp(r"\bsensitive skin\b"): "For sensitive skin, use fragrance-free, hypoallergenic products. Avoid alcohol-based cleansers and use aloe vera and ceramides.",
      RegExp(r"\bskincare routine\b|\bsteps\b"): "A simple skincare routine: 1. Cleanser 2. Moisturizer 3. Sunscreen (morning) 4. Treatment (like retinol) at night.",
      RegExp(r"\bexfoliate\b|\bexfoliation\b"): "Exfoliate 2-3 times a week with a gentle exfoliator. Avoid over-exfoliating to prevent irritation.",
      RegExp(r"\bvitamin c\b|\bbenefits\b"): "Vitamin C brightens skin, reduces hyperpigmentation, and boosts collagen production for a youthful glow."
    };

    for (var entry in skincareResponses.entries) {
      if (entry.key.hasMatch(userMessage)) {
        return entry.value;
      }
    }

    // 🔹 **Fallback to Gemini AI for Unrecognized Queries**
    return await fetchGeminiResponse(userMessage);
  }

  /// 🔹 **Call Gemini AI for Generic Queries**
  Future<String> fetchGeminiResponse(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl?key=$apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": userMessage}
              ]
            }
          ]
        }),
      );

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data.containsKey('candidates') &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0].containsKey('content') &&
            data['candidates'][0]['content'].containsKey('parts') &&
            data['candidates'][0]['content']['parts'] is List) {
          var parts = data['candidates'][0]['content']['parts'];
          return parts.isNotEmpty && parts[0].containsKey('text')
              ? parts[0]['text']
              : "I couldn't find a proper response. Try rephrasing your question.";
        } else {
          return "I'm having trouble understanding your query. Can you rephrase it?";
        }
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
        return "I'm experiencing issues retrieving information. Try again later.";
      }
    } catch (e) {
      print("API Exception: $e");
      return "Error: Could not connect to the chatbot service.";
    }
  }
}
