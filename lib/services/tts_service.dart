import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  late FlutterTts _flutterTts;
  bool _isInitialized = false;

  factory TtsService() {
    return _instance;
  }

  TtsService._internal() {
    _flutterTts = FlutterTts();
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;

    // Set language to English
    await _flutterTts.setLanguage("en-US");

    // Set voice parameters
    await _flutterTts.setSpeechRate(0.9); // Speed of speech (0.0 - 1.0)
    await _flutterTts.setVolume(1.0); // Volume (0.0 - 1.0)
    await _flutterTts.setPitch(1.0); // Pitch (0.5 - 2.0)

    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await _initialize();
    }

    try {
      // Stop any ongoing speech
      await stop();

      // Start speaking
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error speaking: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      print('Error stopping speech: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _flutterTts.pause();
    } catch (e) {
      print('Error pausing speech: $e');
    }
  }

  Future<void> setSpeechRate(double rate) async {
    try {
      await _flutterTts.setSpeechRate(rate);
    } catch (e) {
      print('Error setting speech rate: $e');
    }
  }

  Future<void> setLanguage(String language) async {
    try {
      await _flutterTts.setLanguage(language);
    } catch (e) {
      print('Error setting language: $e');
    }
  }
}
