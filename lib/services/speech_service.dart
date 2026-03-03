import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  String _recognizedText = '';

  factory SpeechService() {
    return _instance;
  }

  SpeechService._internal() {
    _speechToText = stt.SpeechToText();
  }

  bool get isListening => _isListening;
  String get recognizedText => _recognizedText;

  Future<bool> initializeSpeech() async {
    try {
      bool available = await _speechToText.initialize(
        onError: (error) {
          print('Error: $error');
        },
        onStatus: (status) {
          print('Status: $status');
        },
      );
      return available;
    } catch (e) {
      print('Error initializing speech: $e');
      return false;
    }
  }

  Future<void> startListening(
    Function(String) onResult,
  ) async {
    if (_isListening) return;

    try {
      bool available = await initializeSpeech();
      if (!available) {
        print('Speech recognition not available');
        return;
      }

      _isListening = true;
      _recognizedText = '';

      await _speechToText.listen(
        onResult: (result) {
          _recognizedText = result.recognizedWords;
          onResult(_recognizedText);
        },
        localeId: 'en_US',
      );
    } catch (e) {
      print('Error starting listening: $e');
      _isListening = false;
    }
  }

  Future<void> stopListening() async {
    try {
      await _speechToText.stop();
      _isListening = false;
    } catch (e) {
      print('Error stopping listening: $e');
    }
  }

  void cancelListening() {
    _speechToText.cancel();
    _isListening = false;
    _recognizedText = '';
  }
}
