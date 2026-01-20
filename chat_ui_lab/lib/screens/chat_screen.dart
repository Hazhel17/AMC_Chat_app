import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/input_bar.dart';
import '../services/gemini_service.dart';
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [];
  final ScrollController scrollController = ScrollController();

  void addMessage(String text, bool isUser) {
    setState(() {
      messages.add(ChatMessage(
        text: text,
        isUserMessage: isUser,
        timestamp: DateTime.now(),
      ));
    });
    scrollToBottom();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> handleSend(String text) async {
    addMessage(text, true);  // User message

    // 🔥 LOADING
    addMessage('AI is Thinking...', false);

    try {
      // 🔥 REAL GEMINI CALL
      final aiResponse = await GeminiService.sendMessage(text);

      // Remove loading message
      setState(() {
        messages.removeLast();  // Remove "AI Thinking..."
      });

      addMessage(aiResponse, false);  // Real response
    } catch (e) {
      setState(() {
        messages.removeLast();  // Remove loading
      });
      addMessage(' Error: $e', false);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Keeps the top bar clean
        elevation: 0,
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            // Border and Radius for the Title
            border: Border.all(color: Colors.green.shade700, width: 2),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.9),
          ),
          child: const Text(
            '🤖 Chat UI',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
      // This Container adds the Green Gradient background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade100, // Light green at top
              Colors.green.shade300, // Deeper green at bottom
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? const Center(
                child: Text(
                  'Send message to start!',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              )
                  : ListView.builder(
                controller: scrollController,
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                    message: messages[messages.length - 1 - index],
                  );
                },
              ),
            ),
            // Your input bar stays at the bottom
            InputBar(onSendMessage: handleSend),
          ],
        ),
      ),
    );
  }
}