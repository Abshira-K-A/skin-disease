


// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'firebase_service.dart';

// class ChatbotService {
//   final FirebaseService _firebaseService = FirebaseService();

//   // 🔹 Secure API key (Move to environment variable for security)
//   final String apiKey = "AIzaSyDNXiytm8sLQLPi590SYYlaei5pFVL6s7c";
//   static const String apiUrl =
//       "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";

//   /// ✅ **Chatbot Logic for Direct Responses**
//   Future<String> getChatbotResponse(String userMessage, String userId) async {
//     userMessage = userMessage.toLowerCase().trim();
//     print("User message received: $userMessage");
   
//     // 🔹 **Recognize Skincare Questions using RegExp**
//     Map<RegExp, String> skincareResponses = {
//       RegExp(r"\bacne\b|\bpimples\b"): "To reduce acne, cleanse your face twice a day, use oil-free products, and apply benzoyl peroxide or salicylic acid treatments.",
//       RegExp(r"\bdry skin\b|\bmoisturizer\b"): "A good moisturizer for dry skin contains hyaluronic acid, ceramides, and glycerin. Try CeraVe or Neutrogena Hydro Boost.",
//       RegExp(r"\bsunscreen\b|\bspf\b"): "Use a broad-spectrum SPF 30+ sunscreen. Some great options are La Roche-Posay Anthelios and Neutrogena Ultra Sheer.",
//       RegExp(r"\boily skin\b"): "Oily skin is caused by overactive sebaceous glands. It can be influenced by genetics, hormones, and harsh skincare products.",
//       RegExp(r"\bdark spots\b|\bpigmentation\b"): "Use vitamin C serums, niacinamide, and sunscreen daily. Treatments like glycolic acid and retinol help fade dark spots.",
//       RegExp(r"\bsensitive skin\b"): "For sensitive skin, use fragrance-free, hypoallergenic products. Avoid alcohol-based cleansers and use aloe vera and ceramides.",
//       RegExp(r"\bskincare routine\b|\bsteps\b"): "A simple skincare routine: 1. Cleanser 2. Moisturizer 3. Sunscreen (morning) 4. Treatment (like retinol) at night.",
//       RegExp(r"\bexfoliate\b|\bexfoliation\b"): "Exfoliate 2-3 times a week with a gentle exfoliator. Avoid over-exfoliating to prevent irritation.",
//       RegExp(r"\bvitamin c\b|\bbenefits\b"): "Vitamin C brightens skin, reduces hyperpigmentation, and boosts collagen production for a youthful glow."
//     };

//     for (var entry in skincareResponses.entries) {
//       if (entry.key.hasMatch(userMessage)) {
//         return entry.value;
//       }
//     }

//     // 🔹 **Fallback to Gemini AI for Unrecognized Queries**
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

//       print("API Response Status: ${response.statusCode}");
//       print("API Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);

//         if (data.containsKey('candidates') &&
//             data['candidates'].isNotEmpty &&
//             data['candidates'][0].containsKey('content') &&
//             data['candidates'][0]['content'].containsKey('parts') &&
//             data['candidates'][0]['content']['parts'] is List) {
//           var parts = data['candidates'][0]['content']['parts'];
//           return parts.isNotEmpty && parts[0].containsKey('text')
//               ? parts[0]['text']
//               : "I couldn't find a proper response. Try rephrasing your question.";
//         } else {
//           return "I'm having trouble understanding your query. Can you rephrase it?";
//         }
//       } else {
//         print("API Error: ${response.statusCode} - ${response.body}");
//         return "I'm experiencing issues retrieving information. Try again later.";
//       }
//     } catch (e) {
//       print("API Exception: $e");
//       return "Error: Could not connect to the chatbot service.";
//     }
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skinCure/chat_ui_theme.dart';
import 'firebase_service.dart';

class ChatbotService {
  final FirebaseService _firebaseService = FirebaseService();
  final String apiKey = "AIzaSyDNXiytm8sLQLPi590SYYlaei5pFVL6s7c";
  static const String apiUrl = 
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";
  
   Future<Widget> getChatResponseWidget(String userMessage, String userId) async {
    final response = await getChatbotResponse(userMessage, userId);
    return _buildResponseWidget(response, isUser: false);
  }

  Widget _buildResponseWidget(String text, {required bool isUser}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUser ? ChatColors.userBubble : ChatColors.botBubble,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isUser ? 12 : 4),
          topRight: Radius.circular(isUser ? 4 : 12),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
            boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Row(
              children: [
                Icon(Icons.spa, size: 16, color: ChatColors.accent),
                SizedBox(width: 4),
                Text('SkinCure Assistant',
                    style: TextStyle(
                      color: ChatColors.accent,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(
              color: isUser ? ChatColors.userText : ChatColors.botText,
              fontSize: 14,
            ),
          ),
                ],
      ),
    );
  }




  Future<String> getChatbotResponse(String userMessage, String userId) async {
    userMessage = userMessage.toLowerCase().trim();
    print("User message received: $userMessage");
   
    // Expanded skincare knowledge base
    Map<RegExp, String> skincareResponses = {
      // Acne and Breakouts
      RegExp(r"\bacne\b|\bpimples\b|\bbreakouts\b"): 
          "For acne: 1) Cleanse with salicylic acid 2) Apply benzoyl peroxide spot treatment "
          "3) Use oil-free moisturizer 4) Try niacinamide serums. Avoid picking at pimples!",
      
      // Dry Skin
      RegExp(r"\bdry skin\b|\bflaky skin\b|\bdehydrated skin\b"):
          "Dry skin solutions: 1) Use cream cleansers 2) Apply hyaluronic acid on damp skin "
          "3) Seal with ceramide moisturizer 4) Try overnight masks with squalane",
      
      // Sun Protection
      RegExp(r"\bsunscreen\b|\bspf\b|\bsun protection\b"):
          "Sunscreen tips: 1) Use SPF 30+ daily 2) Reapply every 2 hours outdoors "
          "3) Mineral sunscreens (zinc oxide) are gentler for sensitive skin "
          "4) Don't forget neck and hands!",
      
      // Oily Skin
      RegExp(r"\boily skin\b|\bshiny skin\b|\bgreasy skin\b"):
          "Oily skin care: 1) Gel-based cleansers 2) Oil-free, non-comedogenic products "
          "3) Blotting papers for touch-ups 4) Clay masks 1-2x weekly",
      
      // Hyperpigmentation
      RegExp(r"\bdark spots\b|\bpigmentation\b|\bhyperpigmentation\b|\bdiscoloration\b"):
          "For dark spots: 1) Vitamin C serum in AM 2) Niacinamide treatments "
          "3) Retinoids at night 4) Daily SPF to prevent worsening",
      
      // Sensitive Skin
      RegExp(r"\bsensitive skin\b|\bredness\b|\birritation\b"):
          "Sensitive skin care: 1) Fragrance-free products 2) Soothing ingredients like aloe "
          "3) Avoid alcohol-based toners 4) Patch test new products",
      
      // Anti-Aging
      RegExp(r"\bwrinkles\b|\baging\b|\bfine lines\b|\banti-aging\b"):
          "Anti-aging tips: 1) Retinol at night 2) Vitamin C in morning "
          "3) Peptides in moisturizers 4) Always wear SPF",
      
      // Skincare Routines
      RegExp(r"\bskincare routine\b|\bsteps\b|\bregimen\b"):
          "Basic routine: AM - 1) Cleanser 2) Antioxidant serum 3) Moisturizer 4) SPF\n"
          "PM - 1) Cleanser 2) Treatment (retinol/acids) 3) Moisturizer",
      
      // Exfoliation
      RegExp(r"\bexfoliate\b|\bexfoliation\b|\bscrub\b"):
          "Exfoliation guide: 1) Chemical exfoliants (AHAs/BHAs) better than scrubs "
          "2) Start 1-2x weekly 3) Don't mix with retinoids 4) Always moisturize after",
      
      // Ingredients
      RegExp(r"\bvitamin c\b|\bretinol\b|\bhyaluronic acid\b|\bniacinamide\b"):
          "Key ingredients:\n"
          "- Vitamin C: Brightens, protects from pollution\n"
          "- Retinol: Anti-aging, acne treatment\n"
          "- Hyaluronic Acid: Hydration booster\n"
          "- Niacinamide: Reduces inflammation, evens tone",
      
      // Skin Conditions
      RegExp(r"\broseacea\b|\beczema\b|\bdermatitis\b"):
          "For skin conditions: 1) See a dermatologist 2) Use fragrance-free products "
          "3) Avoid triggers (heat/spicy food for rosacea) 4) Try colloidal oatmeal",
      
      // Pores
      RegExp(r"\bpores\b|\blarge pores\b"):
          "Pore care: 1) Niacinamide serums 2) Regular exfoliation "
          "3) Clay masks 4) Non-comedogenic makeup",
      
      // Dark Circles
      RegExp(r"\bdark circles\b|\beye bags\b"):
          "For dark circles: 1) Caffeine serums 2) Cold compresses "
          "3) Adequate sleep 4) Vitamin K creams",
      
      // Face Masks
      RegExp(r"\bface mask\b|\bsheet mask\b"):
          "Mask recommendations:\n"
          "- Hydration: Hyaluronic acid masks\n"
          "- Acne: Clay or charcoal masks\n"
          "- Brightening: Vitamin C masks\n"
          "Use 1-3x weekly after cleansing",
      
      // Cleansing
      RegExp(r"\bcleanser\b|\bwashing face\b"):
          "Cleansing tips: 1) Wash AM/PM 2) Use lukewarm water "
          "3) Double cleanse if wearing makeup 4) Pat dry - don't rub",
      
      // Seasonal Care
      RegExp(r"\bwinter skincare\b|\bsummer skincare\b"):
          "Seasonal adjustments:\n"
          "WINTER: Richer creams, humidifiers\n"
          "SUMMER: Lighter textures, more SPF\n"
          "SPRING/FALL: Transition products gradually",
      
      // Product Recommendations
      RegExp(r"\brecommend\b|\bbest product\b|\bgood for\b"):
          "For personalized recommendations, please specify:\n"
          "1) Your skin type\n"
          "2) Main concerns\n"
          "3) Budget range\n"
          "4) Any ingredient preferences",
      
      // Skin Types
      RegExp(r"\bskin type\b|\bnormal skin\b|\bcombination skin\b"):
          "Skin type guide:\n"
          "- Normal: Balanced, few issues\n"
          "- Dry: Tight, flaky\n"
          "- Oily: Shiny, prone to acne\n"
          "- Combination: Oily T-zone, dry cheeks",
    };

    // Check for matching skincare questions
    for (var entry in skincareResponses.entries) {
      if (entry.key.hasMatch(userMessage)) {
        await _firebaseService.logChatQuery(userId, userMessage, entry.value);
        return entry.value;
      }
    }

    // Fallback to Gemini AI
    final response = await fetchGeminiResponse(userMessage);
    await _firebaseService.logChatQuery(userId, userMessage, response);
    return response;
  }

  Future<String> fetchGeminiResponse(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl?key=$apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [{
            "parts": [{"text": "You are a dermatology skincare assistant. "
                "Provide concise, professional advice for: $userMessage"}]
          }],
          "safetySettings": [
            {
              "category": "HARM_CATEGORY_DEROGATORY",
              "threshold": "BLOCK_ONLY_HIGH"
            }
          ],
          "generationConfig": {
            "temperature": 0.7,
            "maxOutputTokens": 500
          }
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['candidates']?[0]['content']['parts']?[0]['text'] ?? 
            "I couldn't process that request. Could you rephrase?";
      } else {
        return "I'm having technical difficulties. Please try again later.";
      }
    } catch (e) {
      print("API Exception: $e");
      return "Connection error. Please check your internet and try again.";
    }
  }
}