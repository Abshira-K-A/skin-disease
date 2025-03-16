


// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'firebase_service.dart';

// class ChatbotService {
//   final FirebaseService _firebaseService = FirebaseService();
//   final Map<String, dynamic> userRoutine = {}; // Store user responses

//   // 🔹 Move API key to environment variable for security
//   final String apiKey = "AIzaSyDNXiytm8sLQLPi590SYYlaei5pFVL6s7c";  
//   static const String apiUrl =
//       "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";

//   /// ✅ **Enhanced Chatbot Logic**
//   Future<String> getChatbotResponse(String userMessage, String userId) async {
//     userMessage = userMessage.toLowerCase().trim(); // Convert to lowercase for better matching
//     print("User message received: $userMessage");

//     String botResponse = "";

//     // 🔹 **Step 0: Show Welcome Message on First Open**
//     if (userMessage == "start" || userMessage == "hello" || userMessage == "hi") {
//       return "Hello! I'm your skincare assistant. 😊 Ask me anything about skincare, or type 'schedule' to set a skincare routine.";
//     }

//     // 🔹 **Handle Routine Setup Flow**
//     if (userMessage.contains("schedule") || userMessage.contains("set up routine")) {
//       userRoutine.clear(); // Reset routine tracking
//       return "Great! Let's set up your skincare routine. What products do you use?";
//     }

//     if (userRoutine.isNotEmpty && !userRoutine.containsKey("products")) {
//       userRoutine["products"] = userMessage;
//       return "At what times do you use these products? (e.g., morning, night, specific hours)";
//     }

//     if (userRoutine.containsKey("products") && !userRoutine.containsKey("timing")) {
//       userRoutine["timing"] = userMessage;
//       return "Got it! Would you like me to schedule reminders for your routine? (yes/no)";
//     }

//     if (userRoutine.containsKey("products") && userRoutine.containsKey("timing")) {
//       if (userMessage.contains("yes")) {
//         await _firebaseService.saveSkincareRoutine(userId, userRoutine["products"], userRoutine["timing"]);
//         userRoutine.clear(); // Clear after saving
//         return "Your skincare routine has been saved! You'll receive reminders at the scheduled times. 😊";
//       } else {
//         userRoutine.clear(); // Reset if user cancels
//         return "Okay, let me know if you want to make any changes.";
//       }
//     }

//     // 🔹 **Recognize & Respond to Skincare Concerns**
//     Map<String, String> skincareResponses = {
//       "dry skin": "For dry skin, use a hydrating cleanser and a moisturizer with hyaluronic acid. Avoid alcohol-based products.",
//       "oily skin": "For oily skin, use an oil-free cleanser and a lightweight, non-comedogenic moisturizer.",
//       "sensitive skin": "For sensitive skin, use fragrance-free, hypoallergenic skincare products. Avoid harsh chemicals.",
//       "acne": "For acne-prone skin, try using salicylic acid or benzoyl peroxide. Avoid touching your face frequently.",
//       "sunscreen": "Use SPF 30 or higher every morning. Reapply every 2 hours when outdoors.",
//       "dark spots": "For dark spots, try vitamin C or niacinamide. Sunscreen is essential to prevent further pigmentation.",
//       "anti-aging": "For anti-aging, consider using retinol, peptides, and sunscreen daily.",
//       "moisturizer": "Choose a moisturizer based on your skin type. Gel-based for oily skin, cream-based for dry skin.",
//       "exfoliation": "Exfoliate 2-3 times a week using AHA or BHA, depending on your skin type.",
//       "best skincare routine": "A good skincare routine includes: 1. Cleanser, 2. Toner, 3. Serum, 4. Moisturizer, 5. Sunscreen."
//     };

//     for (var key in skincareResponses.keys) {
//       if (userMessage.contains(key)) {
//         return skincareResponses[key]!;
//       }
//     }

//     // 🔹 **Fallback to AI for Unrecognized Queries**
//     return await fetchGeminiResponse(userMessage);
//   }

//   /// 🔹 **Call Gemini AI for Generic Queries**
//   Future<String> fetchGeminiResponse(String userMessage) async {
//     try {
//       final response = await http.post(
//         Uri.parse("$apiUrl?key=$apiKey"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "contents": [
//             {
//               "parts": [
//                 {"text": userMessage}
//               ]
//             }
//           ]
//         }),
//       );

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data['candidates'] != null &&
//             data['candidates'].isNotEmpty &&
//             data['candidates'][0]['content']['parts'] != null &&
//             data['candidates'][0]['content']['parts'].isNotEmpty) {
//           return data['candidates'][0]['content']['parts'][0]['text'];
//         } else {
//           return "I'm not sure about that. Can you clarify?";
//         }
//       } else {
//         print("API Error: ${response.statusCode} - ${response.body}");
//         return "I'm having trouble responding right now. Try again later.";
//       }
//     } catch (e) {
//       print("API Exception: $e");
//       return "Error: Could not connect to the chatbot service.";
//     }
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'firebase_service.dart';

class ChatbotService {
  final FirebaseService _firebaseService = FirebaseService();
  final Map<String, dynamic> userRoutine = {}; // Store user responses

  // 🔹 API key (Move to environment variable for security)
  final String apiKey = "AIzaSyDNXiytm8sLQLPi590SYYlaei5pFVL6s7c";  
  static const String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";

  /// ✅ Chatbot Logic for Scheduling Routines
  Future<String> getChatbotResponse(String userMessage, String userId) async {
    userMessage = userMessage.toLowerCase().trim(); // Convert to lowercase for better matching
    print("User message received: $userMessage");
    String botResponse = "";

    // 🔹 **Step 1: Ask About Skincare Products**
    if (!userRoutine.containsKey("products")) {
      userRoutine["products"] = userMessage;
      botResponse = "At what times do you use these products? (e.g., morning, night, specific hours)";

    // 🔹 **Step 2: Ask About Skincare Timing**
    } else if (!userRoutine.containsKey("timing")) {
      userRoutine["timing"] = userMessage;
      botResponse = "Got it! Would you like me to schedule reminders for your routine? (yes/no)";

    // 🔹 **Step 3: Save Routine in Firebase**
    } else if (userMessage.contains("yes")) {
      await _firebaseService.saveSkincareRoutine(
          userId, userRoutine["products"], userRoutine["timing"], ["Cleanser", "Toner", "Moisturizer"], "daily");
      botResponse = "Your skincare routine has been saved! You'll receive reminders at the scheduled times. 😊";

    // 🔹 **Recognize Skincare Questions**
    } else if (userMessage.contains("dry skin")) {
      botResponse = "For dry skin, use a gentle, hydrating cleanser and apply a moisturizer with hyaluronic acid.";
    } else if (userMessage.contains("oily skin")) {
      botResponse = "For oily skin, use an oil-free cleanser and a lightweight, non-comedogenic moisturizer.";
    } else if (userMessage.contains("sensitive skin")) {
      botResponse = "For sensitive skin, avoid harsh products. Use fragrance-free, hypoallergenic skincare products.";
      
    // 🔹 **Fallback to AI for Unrecognized Queries**
    } else {
      botResponse = await fetchGeminiResponse(userMessage);
    }

    return botResponse;
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

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] ?? "I'm not sure about that. Can you clarify?";
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
        return "I'm having trouble responding right now. Try again later.";
      }
    } catch (e) {
      print("API Exception: $e");
      return "Error: Could not connect to the chatbot service.";
    }
  }
}
