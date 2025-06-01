import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:strezzlah/api/config/keys.dart';


final String apiKey = AppKeys.geminiApiKey;

Future<String> generatePFeedback(String prompt) async {
  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$apiKey', // ✅ Updated to v1
  );

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ]
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // ✅ Place the try-catch here
    try {
      final candidates = data['candidates'] as List?;
      if (candidates != null && candidates.isNotEmpty) {
        final content = candidates[0]['content'];
        final parts = content['parts'] as List?;
        if (parts != null && parts.isNotEmpty) {
          return parts[0]['text'];
        }
      }
      throw Exception('Empty or malformed Gemini response');
    } catch (e) {
      throw Exception('Error parsing Gemini response: $e');
    }
  } else {
    throw Exception('Gemini API Error: ${response.statusCode} ${response.body}');
  }
}
