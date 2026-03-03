# English Bot

A Flutter mobile app for practicing English through conversations with an AI bot.

## Features

- 💬 Real-time chat interface with a conversational bot
- 🎯 Practice English grammar and vocabulary
- 📱 Beautiful and intuitive user interface
- ⏱️ Message timestamps
- 🔄 Clear chat history
- 🌐 Responsive design

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── message.dart         # Message model
├── providers/
│   └── chat_provider.dart   # State management (Provider)
├── screens/
│   └── chat_screen.dart     # Main chat UI
└── services/
    └── bot_service.dart     # Bot API service
```

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0 or higher)
- Dart SDK
- An IDE (VS Code, Android Studio, or equivalent)

### Installation

1. Clone or navigate to the project directory:
```bash
cd englishbot
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## How to Use

1. Launch the app
2. You'll see a welcome message from the English Bot
3. Type your message in the input field
4. Press the send button (📤) or press Enter
5. The bot will respond to help you practice English
6. Use the menu to clear your chat history

## Mobile (Android) setup

### Permissions
The Android build requires microphone and internet permissions. These are already added to `android/app/src/main/AndroidManifest.xml` (`RECORD_AUDIO`, `INTERNET`).

### Build & Run on Android device
1. Install Android Studio and SDK, enable USB debugging on your phone.
2. Connect your phone via USB (or run an emulator).
3. Run:
```bash
flutter devices
flutter run -d <device-id>
```

### Build an APK
```bash
flutter build apk --release
# The APK will be in build/app/outputs/flutter-apk/app-release.apk
```

Notes:
- On Android 6.0+ you must request `RECORD_AUDIO` at runtime; the `speech_to_text` and `flutter_tts` plugins will handle runtime permission prompts when used correctly.
- For iOS, you need to add `NSMicrophoneUsageDescription` and `NSAppTransportSecurity` entries to `ios/Runner/Info.plist` and build from macOS.

## Customization

### Connecting to a Real API

To replace the mock bot responses with real API calls, update the `BotService` class in `lib/services/bot_service.dart`:

```dart
Future<String> getBotResponse(String userMessage) async {
  final response = await http.post(
    Uri.parse('YOUR_API_ENDPOINT'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'message': userMessage}),
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['reply'];
  }
  throw Exception('Failed to get response');
}
```

### Using OpenAI (optional)

The project can use OpenAI's Chat Completions to have natural conversations. To enable it, set the environment variable `OPENAI_API_KEY` on your development machine before running the app.

On Windows (PowerShell):

```powershell
setx OPENAI_API_KEY "sk_your_key_here"
```

Then restart your terminal/IDE so the variable is available to Flutter. When `OPENAI_API_KEY` is present, the app will send conversation context to the OpenAI API and the bot will produce richer replies.

Note: For web builds you should not embed secret keys client-side; instead create a small backend that holds the key and proxies requests.

### Customizing the Theme

Edit the theme in `lib/main.dart` to customize colors, fonts, and styles.

## Dependencies

- **provider**: ^6.0.0 - State management
- **http**: ^1.1.0 - HTTP requests
- **intl**: ^0.19.0 - Internationalization
- **flutter**: SDK dependency

## Future Enhancements

- [ ] Integration with advanced AI models (GPT, etc.)
- [ ] Grammar correction feedback
- [ ] Vocabulary suggestions
- [ ] Voice input/output
- [ ] User authentication
- [ ] Conversation history storage
- [ ] Multiple language support
- [ ] Pronunciation guide

## License

This project is open source and available under the MIT License.

## Web / PWA (installable from browser)

You can publish the web build and let users install the app directly from the browser as a Progressive Web App (PWA).

1. Build the web app with PWA support:
```bash
flutter build web --pwa-strategy=offline
```

2. Host the contents of `build/web` on any static host (Netlify, Vercel, GitHub Pages, Firebase Hosting, a simple nginx/Apache server, etc.).

3. When users visit your site on mobile (Chrome, Edge, Safari on iOS has limited PWA support), the browser will prompt to "Add to Home screen" or show an install option. The app will then be installable and run standalone.

Notes:
- The app already includes a `manifest.json` and registers a service worker in `web/index.html` for offline/installation behavior.
- For secure API keys (OpenAI), do NOT include the key in the client. Use a small backend proxy to call OpenAI and return responses to the client.

### Deploy to GitHub Pages (automatic)

This repository includes a GitHub Actions workflow that will build and deploy the Flutter web app to GitHub Pages when you push to the `main` branch.

Steps:

1. Create a new GitHub repository and push this project to it (if not already):

```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/<your-username>/<your-repo>.git
git push -u origin main
```

2. The workflow `.github/workflows/deploy.yml` will run on push to `main`, build `build/web`, and publish it to the `gh-pages` branch using the built-in `GITHUB_TOKEN`.

3. Go to your repository settings → Pages and ensure the source is set to `gh-pages` branch (the action will create/update it). Your site will be available at `https://<your-username>.github.io/<your-repo>/`.

Note: The Actions runner installs Flutter and runs `flutter build web` — no additional secrets are required for a public deploy. If you need to call private APIs from the web client, create a backend and deploy it separately.

## Support

For issues or questions, please create an issue in the repository.
