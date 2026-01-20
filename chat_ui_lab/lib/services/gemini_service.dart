import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = 'AIzaSyC0c8TfyF9OCkArRBhWe2_70d9peSI_3K4';  // ← Replace with your actual API key!
  static const String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent';

  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [{'text': message}]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Network Error: $e';
    }
  }
}