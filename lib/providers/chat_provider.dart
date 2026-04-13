import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/message.dart';
import '../services/bot_service.dart';
import '../services/tts_service.dart';
import '../services/speech_service.dart';

class ChatProvider extends ChangeNotifier {
  final List<Message> _messages = [];
  bool _isLoading = false;
  bool _isListening = false;
  final BotService _botService = BotService();
  final TtsService _ttsService = TtsService();
  final SpeechService _speechService = SpeechService();
  int? _playingIndex;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isListening => _isListening;
  int? get playingIndex => _playingIndex;
  String get currentDraft => _currentDraft;

  ChatProvider() {
    // Welcome message from bot
    _messages.add(
      Message(
        text:
            'Hello! 👋 I\'m your English learning bot. Feel free to chat with me in English or ask me any grammar questions!',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  String _currentDraft = '';
  set currentDraft(String value) {
    _currentDraft = value;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    _messages.add(
      Message(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ),
    );
    _isLoading = true;
    notifyListeners();

    try {
      // Build conversation history for the model (skip system message here)
      final conversation = <Map<String, String>>[];
      for (final m in _messages) {
        // Skip the latest user message we just added when building previous history
        if (m.timestamp.isAtSameMomentAs(_messages.last.timestamp) &&
            m.isUser) {
          // this is the latest user message, will be sent as the current message
          continue;
        }
        conversation.add({
          'role': m.isUser ? 'user' : 'assistant',
          'content': m.text,
        });
      }

      // Get bot response using conversation context
      final response =
          await _botService.getBotResponse(text, conversation: conversation);

      _messages.add(
        Message(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );

      // Auto-play the bot response
      await speak(_messages.length - 1);
    } catch (e) {
      _messages.add(
        Message(
          text: 'Sorry, I encountered an error. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> speak(int messageIndex) async {
    if (messageIndex < 0 || messageIndex >= _messages.length) return;

    final message = _messages[messageIndex];
    if (message.isUser) return; // Don't speak user messages

    _playingIndex = messageIndex;
    notifyListeners();

    try {
      await _ttsService.speak(message.text);
      message.isRead = true;
      notifyListeners();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> stopSpeaking() async {
    await _ttsService.stop();
    _playingIndex = null;
    notifyListeners();
  }

  Future<void> startListening() async {
    if (_isListening) return;

    _isListening = true;
    notifyListeners();

    try {
      await _speechService.startListening((recognizedText) {
        _currentDraft = recognizedText;
        notifyListeners();
      });
    } catch (e) {
      print('Error starting speech recognition: $e');
      _isListening = false;
      notifyListeners();
    }
  }

  Future<void> stopListening() async {
    await _speechService.stopListening();
    _isListening = false;

    // Set the recognized text as draft for editing
    _currentDraft = _speechService.recognizedText.trim();
    notifyListeners();
  }

  Future<void> sendDraft() async {
    if (_currentDraft.trim().isEmpty) return;
    await sendMessage(_currentDraft.trim());
    _currentDraft = '';
    notifyListeners();
  }

  void clearDraft() {
    _currentDraft = '';
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    _playingIndex = null;
    _messages.add(
      Message(
        text: 'Chat cleared. Let\'s start fresh! How can I help you today?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
