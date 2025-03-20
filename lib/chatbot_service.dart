

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'firebase_service.dart';

// class ChatbotService {
//   final FirebaseService _firebaseService = FirebaseService();
//   final Map<String, dynamic> userRoutine = {}; // Store user responses

//   // 🔹 API key (Move to environment variable for security)
//   final String apiKey = "AIzaSyDNXiytm8sLQLPi590SYYlaei5pFVL6s7c";  
//   static const String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";

//   /// ✅ Chatbot Logic for Scheduling Routines
//   Future<String> getChatbotResponse(String userMessage, String userId) async {
//     userMessage = userMessage.toLowerCase().trim(); // Convert to lowercase for better matching
//     print("User message received: $userMessage");
//     String botResponse = "";

//     // 🔹 **Step 1: Ask About Skincare Products**
//     if (!userRoutine.containsKey("products")) {
//       userRoutine["products"] = userMessage;
//       botResponse = "At what times do you use these products? (e.g., morning, night, specific hours)";

//     // 🔹 **Step 2: Ask About Skincare Timing**
//     } else if (!userRoutine.containsKey("timing")) {
//       userRoutine["timing"] = userMessage;
//       botResponse = "Got it! Would you like me to schedule reminders for your routine? (yes/no)";

//     // 🔹 **Step 3: Save Routine in Firebase**
//     } else if (userMessage.contains("yes")) {
//       await _firebaseService.saveSkincareRoutine(
//           userId, userRoutine["products"], userRoutine["timing"], ["Cleanser", "Toner", "Moisturizer"], "daily");
//       botResponse = "Your skincare routine has been saved! You'll receive reminders at the scheduled times. 😊";

//     // 🔹 **Recognize Skincare Questions**
//     } else if (userMessage.contains("dry skin")) {
//       botResponse = "For dry skin, use a gentle, hydrating cleanser and apply a moisturizer with hyaluronic acid.";
//     } else if (userMessage.contains("oily skin")) {
//       botResponse = "For oily skin, use an oil-free cleanser and a lightweight, non-comedogenic moisturizer.";
//     } else if (userMessage.contains("sensitive skin")) {
//       botResponse = "For sensitive skin, avoid harsh products. Use fragrance-free, hypoallergenic skincare products.";
      
//     // 🔹 **Fallback to AI for Unrecognized Queries**
//     } else {
//       botResponse = await fetchGeminiResponse(userMessage);
//     }

//     return botResponse;
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
//         return data['candidates'][0]['content']['parts'][0]['text'] ?? "I'm not sure about that. Can you clarify?";
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




// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'firebase_service.dart';

// class ChatbotService {
//   final FirebaseService _firebaseService = FirebaseService();
  
//   // 🔹 API key (Move to environment variable for security)
//   final String apiKey = "AIzaSyDNXiytm8sLQLPi590SYYlaei5pFVL6s7c";  
//   static const String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";

//   /// ✅ **Chatbot Logic for Direct Responses**
//   Future<String> getChatbotResponse(String userMessage, String userId) async {
//     userMessage = userMessage.toLowerCase().trim(); // Convert to lowercase for better matching
//     print("User message received: $userMessage");
//     String botResponse = "";

//     // 🔹 **Recognize Skincare Questions**
//     if (userMessage.contains("how to reduce acne")) {
//       botResponse = "To reduce acne, cleanse your face twice a day, use oil-free products, and apply benzoyl peroxide or salicylic acid treatments.";
//     } else if (userMessage.contains("best moisturizer for dry skin")) {
//       botResponse = "A good moisturizer for dry skin is one with hyaluronic acid, ceramides, and glycerin. CeraVe and Neutrogena Hydro Boost are great options!";
//     } else if (userMessage.contains("sunscreen recommendation")) {
//       botResponse = "Use a broad-spectrum SPF 30+ sunscreen. Some great options are La Roche-Posay Anthelios and Neutrogena Ultra Sheer.";
//     } else if (userMessage.contains("why is my skin oily")) {
//       botResponse = "Oily skin is caused by overactive sebaceous glands. It can be influenced by genetics, hormonal changes, and using harsh skincare products.";
//     } else if (userMessage.contains("how to remove dark spots")) {
//       botResponse = "Use vitamin C serums, niacinamide, and sunscreen daily. Treatments like glycolic acid and retinol can help fade dark spots over time.";
//     } else if (userMessage.contains("how to treat sensitive skin")) {
//       botResponse = "For sensitive skin, use fragrance-free, hypoallergenic products. Avoid alcohol-based cleansers and apply soothing ingredients like aloe vera and ceramides.";

//     // 🔹 **General Skincare Advice**
//     } else if (userMessage.contains("what is the best skincare routine")) {
//       botResponse = "A simple skincare routine includes: \n1. Cleanser \n2. Moisturizer \n3. Sunscreen in the morning \n4. Treatment (like retinol) at night.";
//     } else if (userMessage.contains("how often should i exfoliate")) {
//       botResponse = "Exfoliate 2-3 times a week with a gentle exfoliator. Avoid over-exfoliating, as it can cause irritation.";
//     } else if (userMessage.contains("what are the benefits of vitamin c for skin")) {
//       botResponse = "Vitamin C helps brighten skin, reduce hyperpigmentation, and boost collagen production for a youthful glow.";

//     // 🔹 **Fallback to AI for Unrecognized Queries**
//     } else {
//       botResponse = await fetchGeminiResponse(userMessage);
//     }

//     return botResponse;
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
//         return data['candidates'][0]['content']['parts'][0]['text'] ??
//             "I'm not sure about that. Can you clarify?";
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


// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'firebase_service.dart';

// class ChatbotService {
//   final FirebaseService _firebaseService = FirebaseService();

//   // 🔹 API key (Move to environment variable for security)
//   final String apiKey = "AIzaSyDNXiytm8sLQLPi590SYYlaei5pFVL6s7c";
//   static const String apiUrl =
//       "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";

//   /// ✅ **Chatbot Logic for Direct Responses**
//   Future<String> getChatbotResponse(String userMessage, String userId) async {
//     userMessage = userMessage.toLowerCase().trim();
//     print("User message received: $userMessage");
//     String botResponse = "";

//     // 🔹 **Recognize Skincare Questions**
//     if (userMessage.contains("how to reduce acne")) {
//       botResponse = "To reduce acne, cleanse your face twice a day, use oil-free products, and apply benzoyl peroxide or salicylic acid treatments.";
//     } else if (userMessage.contains("best moisturizer for dry skin")) {
//       botResponse = "A good moisturizer for dry skin is one with hyaluronic acid, ceramides, and glycerin. CeraVe and Neutrogena Hydro Boost are great options!";
//     } else if (userMessage.contains("sunscreen recommendation")) {
//       botResponse = "Use a broad-spectrum SPF 30+ sunscreen. Some great options are La Roche-Posay Anthelios and Neutrogena Ultra Sheer.";
//     } else if (userMessage.contains("why is my skin oily")) {
//       botResponse = "Oily skin is caused by overactive sebaceous glands. It can be influenced by genetics, hormonal changes, and using harsh skincare products.";
//     } else if (userMessage.contains("how to remove dark spots")) {
//       botResponse = "Use vitamin C serums, niacinamide, and sunscreen daily. Treatments like glycolic acid and retinol can help fade dark spots over time.";
//     } else if (userMessage.contains("how to treat sensitive skin")) {
//       botResponse = "For sensitive skin, use fragrance-free, hypoallergenic products. Avoid alcohol-based cleansers and apply soothing ingredients like aloe vera and ceramides.";

//     // 🔹 **General Skincare Advice**
//     } else if (userMessage.contains("what is the best skincare routine")) {
//       botResponse = "A simple skincare routine includes: \n1. Cleanser \n2. Moisturizer \n3. Sunscreen in the morning \n4. Treatment (like retinol) at night.";
//     } else if (userMessage.contains("how often should i exfoliate")) {
//       botResponse = "Exfoliate 2-3 times a week with a gentle exfoliator. Avoid over-exfoliating, as it can cause irritation.";
//     } else if (userMessage.contains("what are the benefits of vitamin c for skin")) {
//       botResponse = "Vitamin C helps brighten skin, reduce hyperpigmentation, and boost collagen production for a youthful glow.";

//     // 🔹 **Fallback to AI for Unrecognized Queries**
//     } else {
//       botResponse = await fetchGeminiResponse(userMessage);
//     }

//     return botResponse;
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

//       print("API Response Status: ${response.statusCode}");
//       print("API Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);

//         // Check if the response has valid text data
//         if (data.containsKey('candidates') &&
//             data['candidates'].isNotEmpty &&
//             data['candidates'][0].containsKey('content') &&
//             data['candidates'][0]['content'].containsKey('parts') &&
//             data['candidates'][0]['content']['parts'].isNotEmpty) {
//           return data['candidates'][0]['content']['parts'][0]['text'] ??
//               "I'm not sure about that. Can you clarify?";
//         } else {
//           return "I couldn't find a proper response. Try rephrasing your question.";
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
