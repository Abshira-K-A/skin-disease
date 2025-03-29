



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

import 'package:flutter/material.dart';
import 'chatbot_service.dart';
import 'firebase_service.dart';
import 'chat_bubble.dart';
import 'chat_ui_theme.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final ChatbotService _chatbot = ChatbotService();
  final TextEditingController _controller = TextEditingController();
  final List<Widget> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final String userId = "12345"; // Replace with actual user ID

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(ChatBubble(
      text: "Welcome! How can I assist you with your skincare routine?",
      isUser: false,
      timestamp: _formatTime(DateTime.now()),
    ));
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(ChatBubble(
        text: text,
        isUser: true,
        timestamp: _formatTime(DateTime.now()),
      ));
      _controller.clear();
    });

    _scrollToBottom();

    try {
      // Get and add bot response
      final response = await _chatbot.getChatbotResponse(text, userId);
      setState(() {
        _messages.add(ChatBubble(
          text: response,
          isUser: false,
          timestamp: _formatTime(DateTime.now()),
        ));
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatBubble(
          text: "Error: Could not get response. Try again.",
          isUser: false,
          timestamp: _formatTime(DateTime.now()),
        ));
      });
      _scrollToBottom();
      print("Chatbot API Error: $e");
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatColors.background,
      appBar: AppBar(
        title: Text('SkinCure Assistant',
            style: TextStyle(color: Colors.white)),
        backgroundColor: ChatColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ChatColors.card,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask about your skin concerns...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: ChatColors.background,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ChatColors.accent,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}