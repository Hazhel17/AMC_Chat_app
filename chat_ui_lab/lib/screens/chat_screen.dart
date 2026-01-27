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
  bool _isLoading = false;

  // --- VINTAGE COLOR PALETTE ---
  static const Color vintageBg = Color(0xFFF2E8CF);    // Creamy Parchment
  static const Color vintageHeader = Color(0xFF386641); // Deep Hunter Green
  static const Color vintageAccent = Color(0xFFBC4749); // Muted Rust Red
  static const Color vintageText = Color(0xFF2B2D42);   // Typewriter Charcoal

  void addMessage(String text, String role) {
    setState(() {
      messages.add(ChatMessage(
        text: text,
        role: role,
        timestamp: DateTime.now(),
      ));
    });
    scrollToBottom();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> handleSend(String text) async {
    if (text.trim().isEmpty) return;

    addMessage(text, "user");
    setState(() => _isLoading = true);

    try {
      // Logic from gemini_service.dart
      final aiResponse = await GeminiService.sendMultiTurnMessage(messages);
      addMessage(aiResponse, "model");
    } catch (e) {
      addMessage('❌ Error: $e', "model");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: vintageBg, // Apply background color
      appBar: AppBar(
        title: const Text(
          '🤖 AI Chat - Multi-Turn Week 4',
          style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold),
        ),
        backgroundColor: vintageHeader, // Apply green header
        foregroundColor: Colors.white,
        elevation: 8,
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history_edu, size: 80, color: vintageHeader),
                  SizedBox(height: 16),
                  Text(
                    'Begin your correspondence...',
                    style: TextStyle(color: vintageText, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            )
                : ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) => MessageBubble(message: messages[index]),
            ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator(color: vintageAccent)),
            ),

          // Input Bar Background
          Container(
            color: vintageHeader.withOpacity(0.05),
            padding: const EdgeInsets.only(bottom: 8),
            child: InputBar(onSendMessage: handleSend),
          ),
        ],
      ),
    );
  }
}