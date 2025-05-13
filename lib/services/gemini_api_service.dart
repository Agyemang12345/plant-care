import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiApiService {
  final String apiKey;
  final String baseUrl =
      'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent';

  GeminiApiService({required this.apiKey});

  Future<String> generateContent(String prompt) async {
    try {
      final url = Uri.parse('$baseUrl?key=$apiKey');
      print('Sending request to Gemini API with URL: $url');

      final requestBody = {
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.9,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 2048,
          'stopSequences': [],
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          }
        ]
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        try {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse.containsKey('error')) {
            final error = jsonResponse['error'];
            print('API Error: $error');
            return 'Error: ${error['message'] ?? 'Unknown API error'}';
          }

          final candidates = jsonResponse['candidates'] as List?;
          if (candidates == null || candidates.isEmpty) {
            return 'Error: No response candidates found';
          }

          final content = candidates[0]['content'];
          final parts = content['parts'] as List?;
          if (parts == null || parts.isEmpty) {
            return 'Error: No response parts found';
          }

          String responseText = parts[0]['text'] as String;

          // Format the response for better readability
          responseText = responseText.replaceAll('\n\n', '\n');
          responseText = responseText.trim();

          return responseText;
        } catch (e) {
          print('Error parsing response: $e');
          return 'Error: Failed to parse API response';
        }
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
          if (errorResponse.containsKey('error')) {
            final error = errorResponse['error'];
            return 'Error: ${error['message'] ?? 'Unknown API error'} (Status: ${response.statusCode})';
          }
        } catch (_) {
          // If we can't parse the error response, just return the status code
        }
        return 'Error: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      print('Exception in generateContent: $e');
      return 'Error: Failed to communicate with Gemini API. Please check your internet connection.';
    }
  }
}
