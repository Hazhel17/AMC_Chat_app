import 'package:flutter/material.dart';
import '/models/chat_message.dart';
import '/widgets/message_bubble.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChatScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    final userMsg = ChatMessage(
        text: "User: Hello",
        isUserMessage: true,
        timestamp: DateTime.now(),);

    final aiMsg = ChatMessage(
      text: "AI: Hi there!",
      isUserMessage: false,
      timestamp: DateTime.now(),);

    return Scaffold(
      appBar: AppBar(title: Text('Step 1')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Bubble test', style: TextStyle(fontSize: 24)),
          MessageBubble(message: userMsg),
          SizedBox(height: 20),
          MessageBubble(message: aiMsg),
        ],
      )
    );
  }
}