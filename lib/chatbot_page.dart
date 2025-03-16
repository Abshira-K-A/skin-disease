


// import 'package:flutter/material.dart';
// import 'firebase_service.dart';
// import 'chatbot_service.dart';

// class ChatbotPage extends StatefulWidget {
//   const ChatbotPage({Key? key}) : super(key: key);

//   @override
//   ChatbotPageState createState() => ChatbotPageState();
// }

// class ChatbotPageState extends State<ChatbotPage> {
//   final TextEditingController _controller = TextEditingController();
//   final FirebaseService firebaseService = FirebaseService();
//   final ChatbotService _chatbotService = ChatbotService();
//   final String userId = "12345"; // Replace with actual user ID

//   List<Map<String, String>> messages = [];

//   @override
//   void initState() {
//     super.initState();
//     _showWelcomeMessage(); // ✅ Show welcome message when chatbot opens
//   }

//   void _showWelcomeMessage() {
//     setState(() {
//       messages.add({
//         "bot": "Hello! 😊 I'm your SkinCare Assistant.\nI can help you schedule your skincare routine. What products do you use?"
//       });
//     });
//   }

//   void sendMessage() async {
//     String userMessage = _controller.text.trim();
//     if (userMessage.isEmpty) return;

//     setState(() {
//       messages.add({"user": userMessage});
//       _controller.clear();
//     });

//     try {
//       String botResponse = await _chatbotService.getChatbotResponse(userMessage, userId);
//       setState(() {
//         messages.add({"bot": botResponse});
//       });
//     } catch (e) {
//       setState(() {
//         messages.add({"bot": "Error: Could not get response. Try again."});
//       });
//       print("Chatbot API Error: $e"); // Debugging
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("SkinCare Chatbot"),
//         backgroundColor: Colors.deepOrangeAccent,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final message = messages[index];
//                 return Align(
//                   alignment: message.containsKey("user") ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: message.containsKey("user") ? Colors.blue.shade200 : Colors.green.shade200,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       message["user"] ?? message["bot"] ?? "",
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: "Type your response...",
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                     onSubmitted: (value) => sendMessage(),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.send, color: Colors.deepOrangeAccent),
//                   onPressed: sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'chatbot_service.dart';
// import 'firebase_service.dart';

// class ChatbotPage extends StatefulWidget {
//   const ChatbotPage({Key? key}) : super(key: key);

//   @override
//   ChatbotPageState createState() => ChatbotPageState();
// }

// class ChatbotPageState extends State<ChatbotPage> {
//   final TextEditingController _controller = TextEditingController();
//   final FirebaseService firebaseService = FirebaseService();
//   final ChatbotService _chatbotService = ChatbotService();
//   final String userId = "12345"; // Replace with actual user ID

//   List<Map<String, String>> messages = [
//     {"bot": "Welcome! How can I assist you with your skincare routine?"}
//   ];

//   void sendMessage() async {
//     String userMessage = _controller.text.trim();
//     if (userMessage.isEmpty) return;

//     setState(() {
//       messages.add({"user": userMessage});
//       _controller.clear();
//     });

//     try {
//       String botResponse = await _chatbotService.getChatbotResponse(userMessage, userId);
//       setState(() {
//         messages.add({"bot": botResponse});
//       });
//     } catch (e) {
//       setState(() {
//         messages.add({"bot": "Error: Could not get response. Try again."});
//       });
//       print("Chatbot API Error: $e"); // Debugging
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("SkinCare Chatbot")),
//       body: Column(
//         children: [
//           Expanded(child: ListView.builder(itemCount: messages.length, itemBuilder: (context, index) {
//             final message = messages[index];
//             return ListTile(title: Text(message["user"] ?? message["bot"] ?? ""));
//           })),
//           TextField(controller: _controller, decoration: const InputDecoration(hintText: "Type your response..."), onSubmitted: (value) => sendMessage()),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'chatbot_service.dart';
import 'firebase_service.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  ChatbotPageState createState() => ChatbotPageState();
}

class ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseService firebaseService = FirebaseService();
  final ChatbotService _chatbotService = ChatbotService();
  final String userId = "12345"; // Replace with actual user ID

  List<Map<String, String>> messages = [
    {"bot": "Welcome! How can I assist you with your skincare routine?"}
  ];

  void sendMessage() async {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"user": userMessage});
      _controller.clear();
    });

    try {
      String botResponse = await _chatbotService.getChatbotResponse(userMessage, userId);
      setState(() {
        messages.add({"bot": botResponse});
      });
    } catch (e) {
      setState(() {
        messages.add({"bot": "Error: Could not get response. Try again."});
      });
      print("Chatbot API Error: $e"); // Debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SkinCare Chatbot"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message.containsKey("user") ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.containsKey("user") ? Colors.blue.shade200 : Colors.green.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message["user"] ?? message["bot"] ?? "",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your response...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onSubmitted: (value) => sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepOrangeAccent),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
