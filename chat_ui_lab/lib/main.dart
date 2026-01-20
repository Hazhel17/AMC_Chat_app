import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';// ← Points to FULL chat screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await dotenv.load(fileName: ".env");
  }
  catch (e) {
    throw Exception('Error loading .env file: $e');
  }
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat UI Lab - Complete ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: ChatScreen(),  // ← Uses your FULL ChatScreen
      debugShowCheckedModeBanner: false,  // Clean screen
    );
  }
}