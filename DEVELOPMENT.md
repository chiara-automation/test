# Development Guide

## Project Overview

English Bot is a Flutter application designed to help users practice English through interactive conversations with an AI-powered chatbot.

## Architecture

The app uses a layered architecture:

```
Presentation Layer (UI)
    ↓
State Management (Provider)
    ↓
Services Layer (API calls)
    ↓
Models (Data classes)
```

### Layers Explanation

1. **Presentation Layer** (`screens/`)
   - Contains all UI screens
   - Uses widgets for components
   - Consumes state from providers

2. **State Management** (`providers/`)
   - Uses Provider package
   - Manages app state
   - Notifies listeners of changes

3. **Services** (`services/`)
   - Handles API calls
   - Business logic
   - External integrations

4. **Models** (`models/`)
   - Data classes
   - Type definitions
   - Serialization logic

## Code Style Guide

### Naming Conventions
- Classes: PascalCase (e.g., `ChatProvider`)
- Functions/Variables: camelCase (e.g., `userMessage`)
- Constants: camelCase with const keyword

### Code Organization
- Keep widget files under 500 lines
- Extract reusable widgets to separate files
- Use meaningful variable names
- Add comments for complex logic

### Best Practices
- Use `const` constructors when possible
- Dispose controllers and listeners properly
- Handle null safety
- Use proper error handling

## Testing

Currently, the app doesn't have tests. To add tests:

1. Create test files in `test/` directory
2. Name them with `_test.dart` suffix
3. Run tests with: `flutter test`

Example test:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:english_bot/models/message.dart';

void main() {
  test('Message creation', () {
    final message = Message(
      text: 'Hello',
      isUser: true,
      timestamp: DateTime.now(),
    );
    expect(message.text, 'Hello');
    expect(message.isUser, true);
  });
}
```

## Debugging

### Enable Debug Logging
```dart
import 'package:flutter/foundation.dart';

if (kDebugMode) {
  print('Debug message: $message');
}
```

### Common Issues

1. **API calls not working**
   - Check internet connectivity
   - Verify API endpoint
   - Check request/response format

2. **UI not updating**
   - Ensure `notifyListeners()` is called
   - Check Provider consumer setup
   - Verify state changes

3. **Performance issues**
   - Use `const` widgets
   - Optimize list building with `itemBuilder`
   - Profile with DevTools

## Git Workflow

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make changes and commit: `git commit -m "Add feature"`
3. Push to remote: `git push origin feature/your-feature`
4. Create a pull request

## Performance Optimization Tips

1. Use `const` constructors
2. Avoid rebuilds with `Consumer` widgets
3. Lazy load heavy components
4. Use image caching
5. Minimize provider dependencies

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Material Design](https://material.io/design)
- [Dart Language Guide](https://dart.dev/guides)

## Contact & Support

For questions or issues, please create an issue in the repository or contact the development team.
