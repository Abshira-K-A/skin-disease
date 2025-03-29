import 'package:flutter/material.dart';
import 'chat_ui_theme.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final String? timestamp;

  const ChatBubble({
    required this.text,
    this.isUser = false,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                  SizedBox(width: 6),
                  Text('SkinCure Pro',
                      style: TextStyle(
                        color: ChatColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      )),
                ],
              ),
            SizedBox(height: 6),
            Text(
              text,
              style: TextStyle(
                color: isUser ? ChatColors.userText : ChatColors.botText,
                fontSize: 14,
              ),
            ),
            if (timestamp != null)
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  timestamp!,
                  style: TextStyle(
                    color: (isUser ? Colors.white70 : ChatColors.text.withOpacity(0.5)),
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}