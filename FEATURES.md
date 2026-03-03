# FEATURES.md

## English Bot - Features & Roadmap

### Current Features ✅

- **Chat Interface**: Real-time conversation with the bot
- **Message Formatting**: Timestamps and message bubbles
- **State Management**: Provider pattern for clean state management
- **User-Friendly UI**: Intuitive Material Design interface
- **Chat History**: Clear chat functionality

### Planned Features 🚀

#### Phase 1 - Core Learning Features
- [ ] Grammar correction with explanations
- [ ] Vocabulary suggestions and definitions
- [ ] Difficulty level selection (Beginner, Intermediate, Advanced)
- [ ] Common phrase suggestions

#### Phase 2 - Advanced Features
- [ ] Speech-to-text input (voice chat)
- [ ] Text-to-speech output (pronunciation guide)
- [ ] Conversation topics/categories
- [ ] Grammar exercises with answers
- [ ] Vocabulary flashcards

#### Phase 3 - Personal Learning
- [ ] User authentication and profiles
- [ ] Learning progress tracking
- [ ] Personalized lesson recommendations
- [ ] Save favorite conversations
- [ ] Achievement badges

#### Phase 4 - AI Integration
- [ ] Integration with GPT models
- [ ] Context-aware responses
- [ ] Multiple conversation styles (formal, casual, etc.)
- [ ] Translation assistance
- [ ] Pronunciation feedback

### Technical Improvements
- [ ] Add unit and widget tests
- [ ] Implement error handling and logging
- [ ] Add analytics
- [ ] Performance optimization
- [ ] Offline mode support
- [ ] Dark mode support

### API Integration Examples

To connect to a real AI API, update the `BotService`:

#### Using OpenAI API:
```dart
Future<String> getBotResponse(String userMessage) async {
  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/chat/completions'),
    headers: {
      'Authorization': 'Bearer YOUR_API_KEY',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': 'You are an English language tutor.'},
        {'role': 'user', 'content': userMessage},
      ],
    }),
  );
  // Parse and return response
}
```

#### Using Hugging Face API:
```dart
Future<String> getBotResponse(String userMessage) async {
  final response = await http.post(
    Uri.parse('https://api-inference.huggingface.co/models/mistral-community/Mistral-7B-Instruct-v0.1'),
    headers: {'Authorization': 'Bearer YOUR_API_KEY'},
    body: jsonEncode({'inputs': userMessage}),
  );
  // Parse and return response
}
```

## Contributing

We welcome contributions! Please feel free to submit pull requests or open issues for bugs and feature requests.
