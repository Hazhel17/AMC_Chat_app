import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  // --- VINTAGE COLOR PALETTE ---
  static const Color userBubble = Color(0xFFBC4749); // Muted Rust Red
  static const Color modelBubble = Color(0xFFE7D8C9); // Deep Parchment / Aged Paper
  static const Color vintageInk = Color(0xFF2B2D42);  // Typewriter Charcoal

  @override
  Widget build(BuildContext context) {
    // Check if the role is 'user' to determine alignment
    final bool isUser = message.role == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? userBubble : modelBubble,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 16,
            color: isUser ? Colors.white : vintageInk,
            fontFamily: 'Serif', // Matches the vintage screen title
          ),
        ),
      ),
    );
  }
}