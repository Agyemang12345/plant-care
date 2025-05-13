import 'dart:convert';
import 'package:http/http.dart' as http;

class CohereApiService {
  final String apiKey;
  final String baseUrl = 'https://api.cohere.ai/v1/chat';

  CohereApiService({required this.apiKey});

  Future<String> generateContent(
      String prompt, List<Map<String, String>> history) async {
    try {
      final url = Uri.parse(baseUrl);
      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      };

      // Format history for Cohere
      final chatHistory = history
          .map((msg) => {
                'role': msg['role'] == 'user' ? 'USER' : 'CHATBOT',
                'message': msg['content'] ?? ''
              })
          .toList();

      final requestBody = {
        'model': 'command',
        'message': prompt,
        'chat_history': chatHistory,
        'temperature': 0.8,
        'max_tokens': 512,
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['text'] ?? 'No response from Cohere.';
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
          return 'Error: ${errorResponse['message'] ?? 'Unknown error'} (Status: ${response.statusCode})';
        } catch (_) {
          return 'Error: ${response.statusCode} - ${response.reasonPhrase}';
        }
      }
    } catch (e) {
      return 'Error: Failed to communicate with Cohere API. Please check your internet connection.';
    }
  }
}
