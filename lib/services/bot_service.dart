import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

/// BotService supports two modes:
/// - If an OpenAI API key is present in the environment variable
///   `OPENAI_API_KEY` it will call the OpenAI Chat Completions API.
/// - Otherwise it falls back to a simple mock response generator.
class BotService {
  String? get _openAiKey {
    try {
      return Platform.environment['OPENAI_API_KEY'];
    } catch (_) {
      return null;
    }
  }

  Future<String> getBotResponse(String userMessage,
      {List<Map<String, String>>? conversation}) async {
    final apiKey = _openAiKey;
    if (apiKey != null && apiKey.isNotEmpty) {
      try {
        return await _callOpenAi(apiKey, userMessage,
            conversation: conversation);
      } catch (e) {
        print('OpenAI call failed: $e');
        // Fall back to mock if OpenAI fails
        return _generateMockResponse(userMessage);
      }
    }

    // No API key -> mock
    return _generateMockResponse(userMessage);
  }

  Future<String> _callOpenAi(String apiKey, String userMessage,
      {List<Map<String, String>>? conversation}) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final messages = <Map<String, String>>[];
    // Add system prompt
    messages.add({
      'role': 'system',
      'content':
          'You are an English tutor. Reply in clear, helpful English and help the user practice conversation. Keep responses concise.'
    });

    if (conversation != null && conversation.isNotEmpty) {
      messages.addAll(conversation);
    }

    // Add the latest user message
    messages.add({'role': 'user', 'content': userMessage});

    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': messages,
      'temperature': 0.8,
      'max_tokens': 300,
    });

    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: body,
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final choices = data['choices'] as List<dynamic>?;
      if (choices != null && choices.isNotEmpty) {
        final message = choices[0]['message'];
        final content = message != null ? message['content'] as String? : null;
        return content?.trim() ?? 'Sorry, I could not generate a response.';
      }
      return 'Sorry, I could not parse OpenAI response.';
    } else {
      print('OpenAI error ${response.statusCode}: ${response.body}');
      throw Exception('OpenAI API error: ${response.statusCode}');
    }
  }

  String _generateMockResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      return 'Hello! It\'s great to meet you. How are you doing today? 😊';
    } else if (lowerMessage.contains('thank')) {
      return 'You\'re welcome! Always happy to help with your English learning journey. 🙌';
    } else if (lowerMessage.contains('how are you')) {
      return 'I\'m doing great, thanks for asking! I\'m here to help you improve your English skills. How can I help?';
    } else if (lowerMessage.contains('what is')) {
      return 'That\'s a great question! Could you be more specific about what you\'d like to know?';
    } else if (lowerMessage.contains('help') ||
        lowerMessage.contains('grammar')) {
      return 'Of course! I can help you with grammar, vocabulary, pronunciation, and general conversation. What would you like to work on?';
    } else if (lowerMessage.contains('bad') || lowerMessage.contains('wrong')) {
      return 'No worries! Making mistakes is part of the learning process. Let me help you improve! 💪';
    } else {
      final responses = [
        'That\'s interesting! Can you tell me more about that?',
        'I see. Let me help you with that.',
        'Good point! How does that relate to your English learning?',
        'That\'s a nice thought! Would you like me to correct any mistakes or help you with something specific?',
        'I understand. What would you like to focus on?',
      ];
      final random = responses[userMessage.length % responses.length];
      return random;
    }
  }
}
