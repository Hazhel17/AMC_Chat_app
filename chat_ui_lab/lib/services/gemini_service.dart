import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static String? get _apiKey => dotenv.env['API_KEY'];
  static String? get _baseUrl => dotenv.env['BASE_URL'];

  static Future<String> sendMessage(String message) async {
    if (_baseUrl == null || _apiKey == null) {
      return 'Error: BASE_URL or API_KEY is missing in .env file.';
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
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

        if (data['candidates'] != null &&
            (data['candidates'] as List).isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        } else {
          return 'Error: No response. (The query might have been blocked by safety filters)';
        }
      } else {
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Network Error: $e';
    }
  }
}