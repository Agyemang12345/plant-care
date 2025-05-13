import 'package:plant_care_app/services/cohere_api_service.dart';

class ChatbotService {
  final CohereApiService _cohereService;
  final List<Map<String, String>> _conversationHistory = [];

  ChatbotService({required String apiKey})
      : _cohereService = CohereApiService(apiKey: apiKey);

  Future<String> sendMessage(String message) async {
    try {
      // Add user message to conversation history
      _conversationHistory.add({
        'role': 'user',
        'content': message,
      });

      // Generate response using Cohere API
      String response =
          await _cohereService.generateContent(message, _conversationHistory);

      // Add assistant response to conversation history
      _conversationHistory.add({
        'role': 'assistant',
        'content': response,
      });

      return response;
    } catch (e) {
      print('Error in sendMessage: $e');
      return 'Sorry, I encountered an error while processing your message. Please try again.';
    }
  }

  void clearConversation() {
    _conversationHistory.clear();
  }

  List<Map<String, String>> get conversationHistory => _conversationHistory;
}
