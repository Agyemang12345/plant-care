import 'package:plant_care_app/services/gemini_api_service.dart';

class ChatbotService {
  final GeminiApiService _geminiService;
  final List<Map<String, String>> _conversationHistory = [];

  ChatbotService({required String apiKey})
      : _geminiService = GeminiApiService(apiKey: apiKey);

  Future<String> sendMessage(String message) async {
    try {
      // Add user message to conversation history
      _conversationHistory.add({
        'role': 'user',
        'content': message,
      });

      // Prepare the conversation context with plant care focus
      String context =
          'You are a knowledgeable plant care assistant. Your role is to help users with plant-related questions, provide care tips, diagnose plant issues, and offer gardening advice. Please be specific and practical in your responses.\n\nConversation history:\n';

      context += _conversationHistory.map((msg) {
        return "${msg['role'] == 'user' ? 'User' : 'Assistant'}: ${msg['content']}";
      }).join('\n');

      // Generate response using Gemini API
      String response = await _geminiService.generateContent(context);

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
